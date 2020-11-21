import { VnideNode } from "../node.js";


export class SceneStartNode extends VnideNode {
	static defaultData = {name: "New Scene"};
	static title = "🚦 Scene Start";
	static color = "#ffd500";
	static template = `
		<p>Scene-wide configuration data will go here.</p>
		<input type="text" data-bind="name">
	`;
	static hasInput = false;

	async updateData() {
		await super.updateData();
		let project = this.project.deref();
		let scene = project.getSceneForNode(this);
		scene.name = this.data.name;
	}
}


export class SceneEndNode extends VnideNode {
	static title = "🛑 End Scene";
	static color = "#ffd500";
	static template = `
		<p>The scene is finished.</p>
	`;
	static outputSocketCount = 0;
}


export class RunSceneNode extends VnideNode {
	static defaultData = {"scene": ''};
	static title = "🎬 Run Scene";
	static color = "#ffd500";
	static template = `
		<select data-bind="scene">
			<option value="scene1">Scene 1</option>
			<option value="scene2">Scene 2</option>
			<option value="scene3">Scene 3</option>
			<option value="scene4">Scene 4</option>
		</select>
	`;
}
