import {createElementFromTemplate, renderElementContents} from "../utils.js";
import {VnideProject} from "../project.js";
import {VnideVirtualFileSystem} from "../files.js";
import {SceneEditor} from "./sceneEditor.js";


export class VnideEditor {
	constructor() {
		// Configure nunjucks
		window.nunjucks = nunjucks;
		// noinspection JSUnresolvedFunction
		nunjucks.configure("templates");

		// References to the currently loaded data elements (what are we editing?)
		this.filesystem = new VnideVirtualFileSystem();
		this.project = null;

		// Handle Ctrl-S shortcut
		document.addEventListener("keydown", (e) => {
			if (e.code === "KeyS" && (e.metaKey || e.ctrlKey)) {
				e.preventDefault();
				this.save().then();
			}
		}, false);
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

		// Render the asset browser
		renderElementContents("#assetBrowserWindow", "editor/assetBrowser.jinja2", {project: this.project});
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});

		if(this.project.tabs.length > 0) {
			let active = this.project.getActiveTab();
			this.startEditing(active.type, active.key);
		}
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

		let newKey = this.project.createNewAsset(type, key);
		this.startEditing(type, newKey);
	}

	async openNewAssetModal(type) {
		// Create and show the dialog
		let dialog = createElementFromTemplate("editor/newAssetModal.jinja2", {type: type})
		document.querySelector("body").appendChild(dialog);
		dialog.showModal();

		// Wait for the modal to close asynchronously
		let key = await new Promise((resolve, reject) => {
			dialog.addEventListener('close', (e) => {
				if (document.activeElement.value !== "cancel") {
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

		// Clean up any old editor
		this.editor?.removeAllListeners();

		if (type === 'scene') {
			renderElementContents("#contentWindow", "editor/editorWindows/sceneEditor.jinja2", {project: this.project});
			let scene = this.project.getSceneById(key);
			this.editor = new SceneEditor(this.project, scene);
		} else if (type === 'character') {
			let character = this.project.getCharacterById(key);
			renderElementContents("#contentWindow", "editor/editorWindows/characterEditor.jinja2", {character: character});
		} else if (type === 'background') {
			let background = this.project.getBackgroundById(key);
			renderElementContents("#contentWindow", "editor/editorWindows/mediaEditor.jinja2", {media: background, type: "image"});
		} else if (type === 'music') {
			let music = this.project.getMusicById(key);
			renderElementContents("#contentWindow", "editor/editorWindows/mediaEditor.jinja2", {media: music, type: "audio"});
		} else if (type === 'sound') {
			let sound = this.project.getSoundById(key);
			renderElementContents("#contentWindow", "editor/editorWindows/mediaEditor.jinja2", {media: sound, type: "audio"});
		} else {
			throw Error("Unknown type of editor: " + type)
		}

		renderElementContents("#assetBrowserWindow", "editor/assetBrowser.jinja2", {project: this.project});
		renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});
	}

	switchToTab(index) {
		let tab = this.project.tabs[index];
		this.project.switchToTab(tab);
		this.startEditing(tab.type, tab.key);
	}

	closeTab(index) {
		let tab = this.project.tabs[index];
		this.project.closeTab(tab);
		if (this.project.tabs.length > 0) {
			let newTab = this.project.getActiveTab();
			this.startEditing(newTab.type, newTab.key)
		} else {
			renderElementContents("#editorTabs", "editor/tabMenu.jinja2", {project: this.project});
			renderElementContents("#contentWindow", "editor/editorWindows/noEditor.jinja2", {project: this.project});
		}
	}

}
