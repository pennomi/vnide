import {createElementFromTemplate, htmlToElement, renderElementContents, uuidv4, Vector2} from "../utils.js";


export class VnideSocket {
	constructor(node, id=undefined) {
		this.id = id || uuidv4();
		this.node = new WeakRef(node);

		this.element = document.createElement("div");
		this.element.classList.add("socket");
		this.element.jsObject = this;
	}
}


export class VnideNode {
	static defaultData = {};
	static template = `<div>This is the base node. Don't use it directly!</div>`;
	static hasInput = true;
	static outputSocketCount = 1;
	static color = "#333333";
	static title = null;
	static autoAdvance = false;

	constructor(project, id, position, data=undefined) {
		// Store the project (weakly) so we can render information about characters and media in the elements
		this.project = new WeakRef(project);

		this.id = id;
		this.position = position;
		this.data = data ? data : this.constructor.defaultData;

		// Ensure the data is deep-copied
		this.data = JSON.parse(JSON.stringify(this.data));
		this.createElement();
	}

	serialize() {
		return {
			"id": this.id.toString(),
			"data": this.data,
			"class": this.constructor.name,
			"position": [this.position.x, this.position.y],
		};
	}

	static deserialize(data, project) {
		let node = new NODE_TYPE_MAP[data.class](project, data.id, new Vector2(...data.position), data.data);
		return node;
	}

	getOutputSocket(socketIndex) {
		let socket = this.outputSockets[socketIndex];
		if (socket === undefined) {
			throw Error("Socket not found:");
		}
		return socket;
	}

	createElement() {
		// Create element from the base template
		this.element = createElementFromTemplate("nodes/baseNode.jinja2", {
			node: this,
			title: this.constructor.title,
			template: this.constructor.template,
		});
		this.element.style.setProperty('--defaultNodeColor', this.constructor.color);
		this.element.jsObject = this;

		// Create sockets
		if (this.constructor.hasInput) {
			let inputElement = this.element.querySelector(".inputs");
			this.inputSocket = new VnideSocket(this, uuidv4());
			inputElement.appendChild(this.inputSocket.element);
		}

		this.outputSockets = [];
		let outputElement = this.element.querySelector(".outputs");
		for (let i = 0; i < this.constructor.outputSocketCount; i++) {
			let socket = new VnideSocket(this, uuidv4());
			this.outputSockets.push(socket);
			outputElement.appendChild(socket.element);
		}

		// Bind all data items
		this.createListeners();
		this.updateData().then();

		return this.element;
	}

	createListeners() {
		for (let element of this.element.querySelectorAll("[data-bind]")) {
			let key = element.dataset['bind'];
			if (element instanceof HTMLInputElement || element instanceof HTMLTextAreaElement) {
				element.addEventListener('input', (e) => {
					this.data[key] = e.target.value;
					this.updateData().then();
				});
			} else if (element instanceof HTMLSelectElement) {
				element.addEventListener('change', (e) => {
					this.data[key] = e.target.value;
					this.updateData().then();
				});
			} else if (element instanceof HTMLImageElement) {
				// Do nothing
			} else {
				throw Error("`data-bind` is on an element I don't know how to handle!")
			}
		}
	}

	async updateData() {
		for (let element of this.element.querySelectorAll("[data-bind]")) {
			let key = element.dataset['bind'];
			if (element instanceof HTMLInputElement || element instanceof HTMLTextAreaElement || element instanceof HTMLSelectElement) {
				element.value = this.data[key];
			} else if (element instanceof HTMLImageElement) {
				let url = await this.project.deref().filesystem.getFileImageUrl(this.data[key])
				element.src = url;
			} else {
				throw Error("`data-bind` is on an element I don't know how to handle!")
			}
		}
	}
}
