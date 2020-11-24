import {uuidv4} from "../utils.js";

export class VnideMedia {
	constructor (name, filepath, id=undefined) {
		this.id = id || uuidv4();
		this.name = name;
		this.filepath = filepath;
		this.url = null;
	}

	serialize() {
		return {
			id: this.id,
			name: this.name,
			filepath: this.filepath,
		}
	}

	static deserialize(data) {
		return new VnideMedia(data.name, data.filepath, data.id);
	}

	async load(filesystem) {
		this.url = await filesystem.getFileImageUrl(this.filepath);
	}
}
