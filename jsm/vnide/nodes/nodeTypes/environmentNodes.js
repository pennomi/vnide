import {VnideNode} from "../node.js";


export class BackgroundImageNode extends VnideNode {
	static defaultData = {"backgroundImage": ''};
	static title = "🌳 Change Background";
	static template = `
		<img alt="Background Image" src="" style="width:100%; min-height: 150px; object-fit: contain;"/>
		<select data-bind="backgroundImage"></select>
	`;
	static color = "#40bf4a";
	static autoAdvance = true;

	async updateData() {
		let selectElement = this.element.querySelector('select');
		let project = this.project.deref();

		let html = '';
		for (let background of project.backgrounds) {
			html += `<option value="${background.filepath}">${background.name}</option>`
		}
		selectElement.innerHTML = html;

		await super.updateData();

		let img = this.element.querySelector('img');
		let filepath = selectElement.value;
		img.src = await project.filesystem.getFileImageUrl(filepath);
	}
}


export class CharacterEnterNode extends VnideNode {
	static defaultData = {"character": undefined, "positionX": 0, "positionY": 0};
	static title = "🧍 Character Enter";
	static template = `
		<select data-bind="character"></select>
		<div class="row">
			<img src="" alt="Character Portrait" style="width: 64px; height: 64px;" />
			<div style="width: 80px; margin-left: 16px; margin-top: 8px;">
					<span>X: </span><input style="width: 64px;" type="text" data-bind="positionX">
					<span>Y: </span><input style="width: 64px;" type="text" data-bind="positionY">
			</div>
		</div>
	`;
	static color = "#40bf4a";
	static autoAdvance = true;

	async updateData() {
		let selectElement = this.element.querySelector('select');
		let project = this.project.deref();

		let html = '';
		for (let character of project.characters) {
			html += `<option value="${character.name}">${character.name}</option>`
		}
		selectElement.innerHTML = html;

		await super.updateData();

		let selectedCharacter = project.getCharacterByName(selectElement.value);
		let img = this.element.querySelector('img');
		img.src = await project.filesystem.getFileImageUrl(selectedCharacter.images[0].filepath);
	}
}


export class CharacterExitNode extends CharacterEnterNode {
	static title = "🏃💨 Character Exit";
}
