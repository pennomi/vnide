import {VnideImage} from "./media.js";

export class Character {
	constructor (name) {
		this.name = name;
		this.images = [];
	}

	serialize() {
		return {
			name: this.name,
			images: this.images.map(i=>i.serialize()),
		};
	}

	static deserialize(data) {
		let character = new Character(data.name);
		for (let i of data.images) {
			character.images.push(VnideImage.deserialize(i));
		}
		return character;
	}

	async load(filesystem) {
		await Promise.all(this.images.map(async i=>await i.load(filesystem)));
	}
}
