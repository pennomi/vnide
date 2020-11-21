import {uuidv4} from "./utils.js";


async function _getDatabase(storeName){
	return await new Promise((resolve, reject) => {
		const dbRequest = indexedDB.open(storeName, 4);

		dbRequest.onerror = function(event) {
			reject(Error(event.target.error));
		};

		dbRequest.onupgradeneeded = function(event) {
			console.log("Creating projects database")
			let db = event.target.result;
			db.createObjectStore('projects', {keyPath: 'id'});
			resolve(db);
		};

		dbRequest.onsuccess = function(event) {
			resolve(event.target.result);
		};
	});
}


export class VnideVirtualFileSystem {
	constructor() {
		this.rootDirectoryHandle = null;
		this.db = null;
	}

	async loadProject(projectId) {
		let projectData = await this.getProject(projectId);
		this.rootDirectoryHandle = projectData.fileHandle;
		let permission = await _verifyPermission(this.rootDirectoryHandle, true);
		if (!permission) {
			return false;
		}

		// Update the lastLoaded timestamp here
		projectData.lastLoaded = new Date();
		await this.writeProject(projectData);

		// Return the project file handle
		return projectData;
	}

	async createNewProject() {
		// noinspection JSUnresolvedFunction
		this.rootDirectoryHandle = await window.showDirectoryPicker();

		// Save it in the database
		let id = await this.writeProject({
			id: uuidv4(),
			fileHandle: this.rootDirectoryHandle,
			lastLoaded: new Date(),
		});
		return id;
	}

	async hasPermission(projectRecord) {
		return await projectRecord.fileHandle.queryPermission({mode: 'readwrite'}) === 'granted';
	}

	// Database operations
	async _storeOp(op, args) {
		// Ensure the database exists
		if (!this.db) {
			this.db = await _getDatabase("VnideVirtualFilesystem");
		}

		// Then run the operation
		return await new Promise((resolve, reject) => {
			let transaction = this.db.transaction('projects', 'readwrite');
			let objectStore = transaction.objectStore("projects");
			let request = objectStore[op](...args);
			request.onsuccess = function() {
				resolve(request.result);
			};
			request.onerror = function() {
				reject(Error(request.error));
			};
		});
	}
	async writeProject(project) { return await this._storeOp("put", [project]); }
	async getProject(projectId) { return await this._storeOp("get", [projectId]); }
	async getProjectList() { return await this._storeOp("getAll", []); }
	async unlinkProject(projectId) { return await this._storeOp("delete", [projectId]) }


	// File operations
	async listDirectoryFiles(path) {
		let dirHandle = await this.getDirectoryHandleFromPath(path);
		let paths = [];
		for await (const entry of dirHandle.values()) {
			if (entry.kind === 'file') {
				paths.push(path + "/" + entry.name);
			}
		}
		return paths;
	}

	async readFile(path) {
		let fileHandle = await this.getFileHandleFromPath(path);
		// noinspection JSUnresolvedFunction
		let file = await fileHandle.getFile();
		return file;
	}

	async readFileJson(path) {
		let file = await this.readFile(path);
		const contents = await file.text();
		return JSON.parse(contents);
	}

	async writeFile(path, text) {
		let fileHandle = await this.getFileHandleFromPath(path);
		// noinspection JSUnresolvedFunction
		const writable = await fileHandle.createWritable();
		await writable.write(text);
		await writable.close();
	}

	async writeFileJson(path, data) {
		await this.writeFile(path, JSON.stringify(data, null, 4));
	}

	// async createDirectory() {
	// 	// In an existing directory, create a new directory named "My Documents".
	// 	const newDirectoryHandle = await existingDirectoryHandle.getDirectoryHandle(
	// 		'My Documents', { create: true });
	// }
	//
	// async createFile(filename) {
	// 	const newFileHandle = await newDirectoryHandle.getFileHandle(filename, { create: true });
	// }

	async getFileImageUrl(path) {
		let file = await this.readFile(path);
		return URL.createObjectURL(file);
	}

	async getFileHandleFromPath(path) {
		let parts = path.split('/');
		let currentDirectory = this.rootDirectoryHandle;
		for (let i = 0; i < parts.length; i++) {
			let part = parts[i];
			if (i === parts.length - 1) {
				// This is the file name
			// noinspection JSUnresolvedFunction
				return await currentDirectory.getFileHandle(part);
			} else {
				// This is a directory
			// noinspection JSUnresolvedFunction
				currentDirectory = await currentDirectory.getDirectoryHandle(part);
			}
		}
	}

	async getDirectoryHandleFromPath(path) {
		let parts = path.split('/');
		let currentDirectory = this.rootDirectoryHandle;
		for (let part of parts) {
			// noinspection JSUnresolvedFunction
			currentDirectory = await currentDirectory.getDirectoryHandle(part);
		}
		return currentDirectory;
	}
}


async function _verifyPermission(fileHandle, readWrite) {
	const options = {};
	if (readWrite) {
		options.mode = 'readwrite';
	}
	// Check if permission was already granted. If so, return true.
	// noinspection JSUnresolvedFunction
	if ((await fileHandle.queryPermission(options)) === 'granted') {
		return true;
	}
	// Request permission. If the user grants permission, return true.
	if ((await fileHandle.requestPermission(options)) === 'granted') {
		return true;
	}
	// The user didn't grant permission, so return false.
	return false;
}
