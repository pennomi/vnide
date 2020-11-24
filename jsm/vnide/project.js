import {VnideMedia} from "./media/media.js";
import {Character} from "./media/characters.js";
import {Scene} from "./scene.js";

import {RunSceneNode, SceneEndNode, SceneStartNode} from "./nodes/nodeTypes/sceneNodes.js";
import {BackgroundImageNode, CharacterEnterNode, CharacterExitNode} from "./nodes/nodeTypes/environmentNodes.js";
import {VariableNode, SwitchNode} from "./nodes/nodeTypes/logicNodes.js";
import {TextNode, ChoiceNode} from "./nodes/nodeTypes/storyNodes.js";


window.NODE_TYPE_MAP = {
	SceneStartNode: SceneStartNode,
	SceneEndNode: SceneEndNode,
	RunSceneNode: RunSceneNode,

	BackgroundImageNode: BackgroundImageNode,
	CharacterEnterNode: CharacterEnterNode,
	CharacterExitNode: CharacterExitNode,

	VariableNode: VariableNode,
	SwitchNode: SwitchNode,

	TextNode: TextNode,
	ChoiceNode: ChoiceNode,
};


class EditorTab {
	constructor(type, key, name, object) {
		this.type = type;
		this.key = key;
		this.name = name;
		this.object = object;
		this.active = false;
	}

	serialize() {
		return {
			type: this.type,
			key: this.key,
			active: this.active,
		}
	}

	static deserialize(data, project) {
		let tab = null;
		if (data.type === "scene") {
			let scene = project.getSceneById(data.key);
			tab = new EditorTab(data.type, data.key, scene.name, scene);
		} else if (data.type === "character") {
			let character = project.getCharacterById(data.key);
			tab = new EditorTab(data.type, data.key, character.name, character);
		} else if (data.type === "background") {
			let bg = project.getBackgroundById(data.key);
			tab = new EditorTab(data.type, data.key, bg.name, bg);
		} else if (data.type === "music") {
			let music = project.getMusicById(data.key);
			tab = new EditorTab(data.type, data.key, music.name, music);
		} else if (data.type === "sound") {
			let sound = project.getSoundById(data.key);
			tab = new EditorTab(data.type, data.key, sound.name, sound);
		} else {
			throw Error("Failed to open the asset for editing: " + data.type + " - " + data.key);
		}

		tab.active = data.active;
		return tab;
	}
}


export class VnideProject {
	// TODO: Make this load from a filesystem instead
	constructor(virtualFilesystem) {
		this.filesystem = virtualFilesystem;

		this.backgrounds = [];
		this.characters = [];
		this.sounds = [];
		this.music = [];
		this.scenes = [];

		// Editor state for remembering where you left off
		this.tabs = [];
	}


	/* Loading and saving */
	async load() {
		// First load the objects themselves
		await Promise.all([
			this.loadBackgrounds(),
			this.loadCharacters(),
			this.loadSounds(),
			this.loadMusic(),
			this.loadScenes(),
		]);

		// Then load the editor state for these objects
		await this.loadEditorState();

	}

	async loadEditorState() {
		let data = await this.filesystem.readFileJson('project.json');
		this.tabs.push(...data.tabs.map(_=>EditorTab.deserialize(_, this)));
	}

	async loadBackgrounds() {
		let backgrounds = await this.filesystem.readFileJson('backgrounds.json');
		this.backgrounds.push(...backgrounds.map(_=>VnideMedia.deserialize(_)));
		await Promise.all(this.backgrounds.map(async _=>await _.load(this.filesystem)));
	}

	async loadCharacters() {
		let characters = await this.filesystem.readFileJson("characters.json");
		this.characters.push(...characters.map(_=>Character.deserialize(_)));
		await Promise.all(this.characters.map(async _=>await _.load(this.filesystem)));
	}

	async loadSounds() {
		let sounds = await this.filesystem.readFileJson("sounds.json");
		this.sounds.push(...sounds.map(_=>VnideMedia.deserialize(_)));
		await Promise.all(this.sounds.map(async _=>await _.load(this.filesystem)));
	}

	async loadMusic() {
		let music = await this.filesystem.readFileJson("music.json");
		this.music.push(...music.map(_=>VnideMedia.deserialize(_)));
		await Promise.all(this.music.map(async _=>await _.load(this.filesystem)));
	}

	async loadScenes() {
		let scenes = await this.filesystem.listDirectoryFiles("scenes");
		for (let sceneUrl of scenes) {
			let data = await this.filesystem.readFileJson(sceneUrl);
			this.scenes.push(Scene.deserialize(data, this, sceneUrl));
		}
	}

	async save() {
		// TODO: Only save the items which have been updated
		await Promise.all([
			this.saveEditorState(),
			this.saveBackgrounds(),
			this.saveCharacters(),
			this.saveSounds(),
			this.saveMusic(),
			this.saveScenes(),
		])
	}

	async saveEditorState() {
		let data = {
			tabs: this.tabs.map(_=>_.serialize())
		};
		await this.filesystem.writeFileJson('project.json', data);
	}

	async saveBackgrounds() {
		let data = this.backgrounds.map(_=>_.serialize());
		await this.filesystem.writeFileJson('backgrounds.json', data);
	}

	async saveCharacters() {
		let data = this.characters.map(_=>_.serialize());
		await this.filesystem.writeFileJson('characters.json', data);
	}

	async saveSounds() {
		let data = this.sounds.map(_=>_.serialize());
		await this.filesystem.writeFileJson('sounds.json', data);
	}

	async saveMusic() {
		let data = this.music.map(_=>_.serialize());
		await this.filesystem.writeFileJson('music.json', data);
	}

	async saveScenes() {
		for (let scene of this.scenes) {
			let data = scene.serialize();
			await this.filesystem.writeFileJson(scene.filepath, data);
		}
	}

	// Create new assets
	createNewAsset(type, key) {
		if (type === "character") {
			let newCharacter = new Character(key);
			this.characters.push(newCharacter);
			key = newCharacter.id;
		} else if (type === "scene") {
			let newScene = Scene.createNew(key, this);
			this.scenes.push(newScene);
			key = newScene.id;
		} else if (type === "background") {
			let _ = new VnideMedia(key);
			this.backgrounds.push(_);
			key = _.id;
		} else if (type === "music") {
			let _ = new VnideMedia(key);
			this.music.push(_);
			key = _.id;
		} else if (type === "sound") {
			let _ = new VnideMedia(key);
			this.sounds.push(_);
			key = _.id;
		} else {
			throw Error("Cannot create asset of type: " + type);
		}

		return key;
	}


	// Tab Management
	openTab(type, key) {
		// Don't duplicate an open tab, instead switch to it.
		let targetTab = this.tabs.filter(t=>t.type === type && t.key === key)[0];
		if (targetTab !== undefined) {
			this.switchToTab(targetTab);
			return;
		}

		targetTab = EditorTab.deserialize({type: type, key: key}, this);
		this.tabs.push(targetTab);
		this.switchToTab(targetTab);
	}

	switchToTab(tab) {
		this.tabs.forEach(t=>t.active = false);
		tab.active = true;
	}

	closeTab(tab) {
		let index = this.tabs.indexOf(tab);

		if (tab.active && this.tabs.length > 1) {
			// Switch to the nearest tab first
			let newIndex = index + 1 === this.tabs.length ? index - 1 : index + 1;
			this.switchToTab(this.tabs[newIndex]);
		}

		// Then slice out the index
		this.tabs.splice(index, 1);
	}

	// Convenient getters
	getCharacterById(id) {
		for (let character of this.characters) {
			if (character.id === id) {
				return character;
			}
		}
		throw Error(`Character "${id}" not found.`);
	}

	getSceneById(id) {
		for (let scene of this.scenes) {
			if (scene.id === id) {
				return scene;
			}
		}
		throw Error(`Scene "${id}" not found.`);
	}

	getBackgroundById(id) {
		for (let _ of this.backgrounds) {
			if (_.id === id) {
				return _;
			}
		}
		throw Error(`Background "${id}" not found.`);
	}

	getMusicById(id) {
		for (let _ of this.music) {
			if (_.id === id) {
				return _;
			}
		}
		throw Error(`Music "${id}" not found.`);
	}

	getSoundById(id) {
		for (let _ of this.sounds) {
			if (_.id === id) {
				return _;
			}
		}
		throw Error(`Sound "${id}" not found.`);
	}

	getSceneForNode(node) {
		for (let scene of this.scenes) {
			if (scene.nodes.includes(node)) {
				return scene;
			}
		}
		throw Error(`Scene for node "${node.id}" not found.`);
	}
}
