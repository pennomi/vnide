import {
	convertPointFromPageToNode,
	createElementFromTemplate,
	renderElementContents,
	uuidv4,
	Vector2
} from "../utils.js";
import {VnideSocket} from "../nodes/node.js";
import {VnidePlayer} from "../player/player.js";
import {VnideProject} from "../project.js";
import {VnideVirtualFileSystem} from "../files.js";


export class VnideEditor {
	constructor() {
		// Configure nunjucks
		window.nunjucks = nunjucks;
		// noinspection JSUnresolvedFunction
		nunjucks.configure("templates");

		// References to the currently loaded data elements (what are we editing?)
		this.filesystem = new VnideVirtualFileSystem();
		this.project = null;
		this.scene = null;
		this.player = null;

		// HTML element references
		this.editorPanel = document.querySelector('#vnideSceneEditorPanel');
		this.sceneContainer = document.querySelector('#vnideSceneContainer');
		this.sceneContainer.positioning = new Vector2(0, 0);
		this.playerContainer = document.querySelector('#player');

		// Render a few elements that don't require more data
		renderElementContents("#nodePalette", 'editor/sceneEditor/nodePalette.jinja2', {nodeTypes: Object.values(NODE_TYPE_MAP)});

		/* Mouse & Keyboard Actions */
		this.editorPanel.addEventListener("drop", this.dropExternalStuff.bind(this));
		this.editorPanel.addEventListener("dragover", (e) => { e.preventDefault(); });
		this.editorPanel.addEventListener('mousedown', this.handleMouseDown.bind(this));
		document.addEventListener('mousemove', this.position.bind(this));
		document.addEventListener('mouseup', this.dragEnd.bind(this));
		document.addEventListener('contextmenu', this.contextmenu.bind(this));
		document.addEventListener('keydown', this.handleKeypress.bind(this));
		// Handle scroll wheel zoom
		this.editorPanel.addEventListener('wheel', (e) => {
			e.preventDefault();
			e.deltaY > 0 ? this.zoomOut(e) : this.zoomIn(e);
		});
		// Handle Ctrl-S shortcut
		document.addEventListener("keydown", (e) => {
			if (e.code === "KeyS" && (e.metaKey || e.ctrlKey)) {
				e.preventDefault();
				this.save().then();
			}
		}, false);

		// Drag state
		this.selectedElement = null;
		this.selectedNode = null;
		this.drag = false;
		this.editor_selected = false;
		this.activeDragConnection = undefined;

		// Configurable options
		this.zoom = 1;
		this.zoomMax = 1.0;
		this.zoomMin = 0.25;
	}

	dropExternalStuff(ev) {
		ev.preventDefault();
		let data = ev.dataTransfer.getData("node");
		this.addNodeFromSidebar(data, new Vector2(ev.clientX, ev.clientY));
	}

	async presentProjectSelector() {
		let projects = await this.filesystem.getProjectList();

		let mostRecent = projects[0];
		if (await this.filesystem.hasPermission(mostRecent)) {
			// If we already have permission to access the last-opened project, do it.
			await this.loadProject(mostRecent.id);
		} else {
			// Otherwise, open the projectSelectionMenu
			renderElementContents(
				"#projectSelectionMenu",
				'editor/projectSelectionMenu.jinja2',
				{projects: projects}
			);
		}
	}

	async save() {
		await this.project.save();
	}

	async loadProject(projectId) {
		// TODO: Probably this functionality would be encapsulated inside the VnideProject?
		let projectHandle = await this.filesystem.loadProject(projectId);
		if (!projectHandle) {
			// TODO: This might be a nice error message to show the user.
			console.error("Permission was NOT granted to edit the files.");
			return;
		}
		document.querySelector("#projectSelectionMenu").style.visibility = "hidden";

		// Load the project file
		let project = new VnideProject(this.filesystem);
		await project.load();

		this.project = project;
		this.scene = this.project.scenes[0];

		// Render the asset browser
		renderElementContents("#assetBrowserWindow", "editor/assetBrowser.jinja2", {project: this.project});

		// Render the tab menu
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});

		// Add the elements for the graph editor
		for (let node of this.scene.nodes) {
			this.sceneContainer.appendChild(node.element);
		}

		for (let connection of this.scene.connections) {
			this.sceneContainer.appendChild(connection.element);
			connection.updateCurve();
		}

		// Create the player preview container
		this.player = new VnidePlayer(this.playerContainer, this.project);
		this.player.frozen = true;
	}

	async createNewProject() {
		let projectId = await this.filesystem.createNewProject();
		await this.presentProjectSelector();  // Re-renders the file list
		await this.loadProject(projectId);
	}

	async unlinkProject(projectId) {
		await this.filesystem.unlinkProject(projectId);
		await this.presentProjectSelector();  // Re-renders the file list
	}

	async startEditingNew(type) {
		let key = await this.openNewAssetModal(type);
		if (key === "") {
			return;
		}

		this.project.createNewAsset(type, key);
		this.project.openTab(type, key);
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});
	}

	async openNewAssetModal(type) {
		// Create and show the dialog
		let dialog = createElementFromTemplate("editor/newAssetModal.jinja2", {type: type})
		document.querySelector("body").appendChild(dialog);
		dialog.showModal();

		// Wait for the modal to close asynchronously
		let key = await new Promise((resolve, reject) => {
			dialog.addEventListener('close', (e) => {
				if (document.activeElement.value === "create") {
					resolve(dialog.querySelector("input").value);
				}
				resolve("");
			});
		});

		// Cleanup and return
		dialog.remove();
		return key;
	}

	startEditing(type, key) {
		this.project.openTab(type, key);
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});
	}

	switchToTab(index) {
		let tab = this.project.tabs[index];
		this.project.switchToTab(tab);
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});
	}

	closeTab(index) {
		let tab = this.project.tabs[index];
		this.project.closeTab(tab);
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});
	}

	getNodeFromElement(e) {
		let obj = e.jsObject;
		if (obj instanceof VnideSocket) {
			return obj.node.deref();
		}
		return undefined;
	}

	handleMouseDown(e) {
		// TODO: Change this to get the actual jsObject and then let each class handle it using polymorphism
		this.selectedElement = e.target;

		// If we're on an editable area, never process this event
		if (e.target instanceof HTMLSelectElement || e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) {
			return;
		}

		if (e.button === 0) {
			this.contextmenuDel();
		}

		if (e.target.closest(".vnideNodeContent") != null) {
			this.selectedElement = e.target.closest(".vnideNodeContent").parentElement;
		}

		switch (this.selectedElement.classList[0]) {
			case 'vnideNode':
				if (this.selectedNode != null) {
					this.selectedNode.classList.remove("selected");
				}
				this.selectedNode = this.selectedElement;
				this.selectedNode.classList.add("selected");
				this.drag = true;

				// The selected node should be used to render the preview window
				this.player.recreateStateForNode(this.selectedNode.jsObject);

				break;
			case 'socket':
				let node = this.getNodeFromElement(this.selectedElement);
				let socketElements = Array.from(this.selectedElement.parentElement.children);
				let index = socketElements.indexOf(this.selectedElement);

				if (this.selectedElement.parentElement.classList.contains("outputs")) {
					// This is an output. We remember the previous target to reconnect it if not dropped on a valid target
					let connection = this.scene.connections.filter(c=>c.sourceNode === node && c.outputIndex === index)[0];
					if (connection !== undefined) {
						connection.previousTargetNode = connection.targetNode;
						connection.targetNode = null;
						this.activeDragConnection = connection;
					} else {
						// If there's no connection, we create a temporary one to fill in
						this.activeDragConnection = this.scene.addConnection(node, index);
						this.sceneContainer.appendChild(this.activeDragConnection.element);
					}
				} else {
					// This is an input. We unlink the input if not dropped on a valid target
					let connection = this.scene.connections.filter(c=>c.targetNode === node)[0];
					if (connection !== undefined) {
						connection.previousTargetNode = null;
						connection.targetNode = null;
						this.activeDragConnection = connection;
					}
				}

				if (this.selectedNode != null) {
					this.selectedNode.classList.remove("selected");
					this.selectedNode = null;
				}
				break;
			case 'vnide':
				if (this.selectedNode != null) {
					this.selectedNode.classList.remove("selected");
					this.selectedNode = null;
				}
				this.editor_selected = true;
				break;
			case 'vnide-delete':
				if (this.selectedNode) {
					this.scene.removeNode(this.selectedNode.jsObject);
				}

				if (this.selectedNode != null) {
					this.selectedNode.classList.remove("selected");
					this.selectedNode = null;
				}
				break;
			default:
		}
	}

	position(e) {
		let point = convertPointFromPageToNode(this.sceneContainer, e.clientX, e.clientY)

		if (this.activeDragConnection !== undefined) {
			this.activeDragConnection.updateCurve([point.x, point.y]);
		}

		if (this.editor_selected) {
			// TODO: Remove the element.positioning thing and make a real SceneEditor class to maintain state
			let x = this.sceneContainer.positioning.x + e.movementX;
			let y = this.sceneContainer.positioning.y + e.movementY;
			this.sceneContainer.positioning = new Vector2(x, y);
			this.sceneContainer.style.transform = `translate(${x}px, ${y}px) scale(${this.zoom})`;
			this.updateBackgroundGrid();
		}

		if (this.drag) {
			// Dragging a node
			let x = this.selectedElement.offsetLeft + e.movementX / this.zoom;
			let y = this.selectedElement.offsetTop + e.movementY / this.zoom;
			this.selectedElement.style.left = x + "px";
			this.selectedElement.style.top = y + "px";

			let node = this.selectedElement.jsObject;
			node.position = new Vector2(x, y);  // TODO: Make the node manage its own style and positioning
			this.updateConnectionsForNode(node, new Vector2(point.x, point.y));
		}
	}

	updateBackgroundGrid() {
		let scale = 64 * this.zoom;
		this.editorPanel.style.backgroundSize = `${scale}px ${scale}px`;
		this.editorPanel.style.backgroundPositionX = this.sceneContainer.positioning.x + "px";
		this.editorPanel.style.backgroundPositionY = this.sceneContainer.positioning.y + "px";
	}

	dragEnd(e) {
		if (this.activeDragConnection !== undefined) {
			if (e.target.parentElement.classList.contains("inputs")) {
				let socketElements = Array.from(e.target.parentElement.children);
				this.activeDragConnection.inputSocketId = socketElements.indexOf(e.target);
				this.activeDragConnection.targetNode = e.target.parentElement.parentElement.jsObject;
				this.activeDragConnection.updateCurve();
			} else if (this.activeDragConnection.previousTargetNode !== null) {
				this.activeDragConnection.targetNode = this.activeDragConnection.previousTargetNode;
				this.activeDragConnection.updateCurve();
			} else {
				// Remove the connection
				this.scene.removeConnection(this.activeDragConnection);
			}
			this.activeDragConnection = undefined;
		}

		this.drag = false;
		this.activeDragConnection = undefined;
		this.selectedElement = null;
		this.editor_selected = false;
	}

	contextmenu(e) {
		e.preventDefault();
		if (this.sceneContainer.getElementsByClassName("vnide-delete").length) {
			this.sceneContainer.getElementsByClassName("vnide-delete")[0].remove()
		}
		if (this.selectedNode) {
			const deleteElement = document.createElement('div');
			deleteElement.classList.add("vnide-delete");
			deleteElement.innerHTML = "x";
			if (this.selectedNode) {
				this.selectedNode.appendChild(deleteElement);

			}
		}
	}

	contextmenuDel() {
		if (this.sceneContainer.getElementsByClassName("vnide-delete").length) {
			this.sceneContainer.getElementsByClassName("vnide-delete")[0].remove()
		}
	}

	handleKeypress(e) {
		if (document.activeElement.tagName.toLowerCase() !== "body") {
			// We must be in an editable field, which means we should suspend this function.
			return;
		}
		if (e.key === 'Delete' || (e.key === 'Backspace' && e.metaKey)) {
			if (this.selectedNode != null) {
				this.scene.removeNode(this.selectedNode.jsObject);
			}
		}
	}

	zoomRefresh() {
		this.sceneContainer.style.transform = "translate(" + this.sceneContainer.positioning.x + "px, " + this.sceneContainer.positioning.y + "px) scale(" + this.zoom + ")";
		this.updateBackgroundGrid();
	}

	zoomIn(e) {
		// TODO: The zoom in/out is repeated code. Deduplicate it.
		let anchorX, anchorY;
		if (e !== undefined) {
			anchorX = e.clientX;
			anchorY = e.clientY;
		} else {
			anchorX = this.sceneContainer.offsetLeft + this.sceneContainer.clientWidth / 2.0;
			anchorY = this.sceneContainer.offsetTop + this.sceneContainer.clientHeight / 2.0;
		}

		if (this.zoom >= this.zoomMax) {
			return;
		}

		let oldPoint = convertPointFromPageToNode(this.sceneContainer, anchorX, anchorY)
		this.zoom *= 2.0;
		this.zoomRefresh();

		let newPoint = convertPointFromPageToNode(this.sceneContainer, anchorX, anchorY)
		this.sceneContainer.positioning.x += (newPoint.x - oldPoint.x) * this.zoom;
		this.sceneContainer.positioning.y += (newPoint.y - oldPoint.y) * this.zoom;
		this.zoomRefresh();
	}

	zoomOut(e) {
		// TODO: The zoom in/out is repeated code. Deduplicate it.
		let anchorX, anchorY;
		if (e !== undefined) {
			anchorX = e.clientX;
			anchorY = e.clientY;
		} else {
			anchorX = this.sceneContainer.offsetLeft + this.sceneContainer.clientWidth / 2.0;
			anchorY = this.sceneContainer.offsetTop + this.sceneContainer.clientHeight / 2.0;
		}

		if (this.zoom <= this.zoomMin) {
			return;
		}

		let oldPoint = convertPointFromPageToNode(this.sceneContainer, anchorX, anchorY)
		this.zoom *= 0.5;
		this.zoomRefresh();

		let newPoint = convertPointFromPageToNode(this.sceneContainer, anchorX, anchorY)
		this.sceneContainer.positioning.x += (newPoint.x - oldPoint.x) * this.zoom;
		this.sceneContainer.positioning.y += (newPoint.y - oldPoint.y) * this.zoom;
		this.zoomRefresh();
	}

	zoomReset() {
		if (this.zoom !== 1) {
			this.zoom = 1;
			this.zoomRefresh();
		}
	}

	addNodeFromSidebar(name, position) {
		position.x = position.x * (this.sceneContainer.clientWidth / (this.sceneContainer.clientWidth * this.zoom)) - (this.sceneContainer.getBoundingClientRect().x * (this.sceneContainer.clientWidth / (this.sceneContainer.clientWidth * this.zoom)));
		position.y = position.y * (this.sceneContainer.clientHeight / (this.sceneContainer.clientHeight * this.zoom)) - (this.sceneContainer.getBoundingClientRect().y * (this.sceneContainer.clientHeight / (this.sceneContainer.clientHeight * this.zoom)));

		let node = new NODE_TYPE_MAP[name](this.project, uuidv4(), position);
		this.scene.addNode(node);
		this.sceneContainer.appendChild(node.element);
	}

	updateConnectionsForNode(node, mousePosition=undefined) {
		this.scene.connections.filter(
			c => c.sourceNode === node || c.targetNode === node
		).forEach(c => {
			c.updateCurve(mousePosition);
		})
	}

	clear() {
		for (let node of this.scene.nodes) {
			this.scene.removeNode(node);
		}
	}

}
