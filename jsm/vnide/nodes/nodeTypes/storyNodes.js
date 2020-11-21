import {VnideNode} from "../node.js";


export class TextNode extends VnideNode {
	static defaultData = {"characterId": "narrator", "text": ""};
	static title = "💬 Text";
	static color = "#4c97ff";
	static template = `
		<select data-bind="character"></select>
		<textarea data-bind="text"></textarea>
	`;

	async updateData() {
		let selectElement = this.element.querySelector('select');
		let project = this.project.deref();

		let html = '';
		for (let character of project.characters) {
			html += `<option value="${character.name}">${character.name}</option>`
		}
		selectElement.innerHTML = html;

		await super.updateData();
	}
}


export class ChoiceNode extends VnideNode {
	static title = "💭 Choice";
	static color = "#4c97ff";
	static template = `
		<input type="text" data-bind="choice1">
		<input type="text" data-bind="choice2">
		<input type="text" data-bind="choice3">
	`;
	static outputSocketCount = 3;
}
