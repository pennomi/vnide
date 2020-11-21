import {VnideNode} from "../node.js";


export class VariableNode extends VnideNode {
	static defaultData = {"key": "myVariable", "value": "\"This is a string!\""}
	static title = "🖥 Set Variable";
	static color = "#ff6680";
	static template = `
		Variable
		<input type="text" data-bind="key">
		Value
		<input type="text" data-bind="value">
	`;
}


export class SwitchNode extends VnideNode {
	static defaultData = {"conditionExpression": "game.myVariable > 3"}
	static title = "🔀 Switch";
	static color = "#ff6680";
	static template = `
		<input type="text" data-bind="conditionExpression">
	`;
	static outputSocketCount = 2;
}
