import {VnideMedia} from "./media.js";
import {uuidv4} from "../utils.js";

export class Character {
	constructor (name, id=undefined) {
		this.id = id || uuidv4();
		this.name = name;
		this.images = [];
	}

	serialize() {
		return {
			id: this.id,
			name: this.name,
			images: this.images.map(i=>i.serialize()),
		};
	}

	static deserialize(data) {
		let character = new Character(data.name, data.id);
		for (let i of data.images) {
			character.images.push(VnideMedia.deserialize(i));
		}
		return character;
	}

	async load(filesystem) {
		await Promise.all(this.images.map(async i=>await i.load(filesystem)));
	}
}
