export class VnideImage {
	constructor (name, filepath) {
		this.name = name;
		this.filepath = filepath;
		this.url = null;
	}

	serialize() {
		return {
			name: this.name,
			filepath: this.filepath,
		}
	}

	static deserialize(data) {
		return new VnideImage(data.name, data.filepath);
	}

	async load(filesystem) {
		this.url = await filesystem.getFileImageUrl(this.filepath);
	}
}


export class VnideSound {
	constructor (name, filepath) {
		this.name = name;
		this.filepath = filepath;
		this.url = null;
	}

	serialize() {
		return {
			name: this.name,
			filepath: this.filepath,
		}
	}

	static deserialize(data) {
		return new VnideSound(data.name, data.filepath);
	}

	async load(filesystem) {
		this.url = await filesystem.getFileImageUrl(this.filepath);
	}
}
