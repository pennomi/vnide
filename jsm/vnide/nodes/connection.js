const CURVATURE = 0.5;


function _createCurvature(x1, y1, x2, y2) {
	const hy1 = y1 + Math.abs(y2 - y1) * CURVATURE;
	const hy2 = y2 - Math.abs(y2 - y1) * CURVATURE;
	return ` M ${x1} ${y1} C ${x1} ${hy1} ${x2} ${hy2} ${x2}  ${y2}`;
}


export class VnideConnection {
	constructor(sourceNode, outputSocketIndex, targetNode=null) {
		this.sourceNode = sourceNode;
		this.outputIndex = outputSocketIndex;
		this.targetNode = targetNode;
		this.previousTargetNode = null;  // Used to store an old value while attempting to connect to something new
		this._createElement();
	}

	serialize() {
		return {
			"source": this.sourceNode.id.toString(),
			"output": this.outputIndex,
			"target": this.targetNode.id.toString(),
		};
	}

	static deserialize(data, scene) {
		let connection = new VnideConnection(scene.getNode(data.source), data.output, scene.getNode(data.target));
		return connection;
	}

	_createElement() {
		// TODO: Make this more template-based
		this.element = document.createElementNS('http://www.w3.org/2000/svg', "svg");
		this.element.jsObject = this;

		const path = document.createElementNS('http://www.w3.org/2000/svg', "path");
		path.classList.add("connection");
		path.setAttributeNS(null, 'd', '');
		this.element.classList.add("connection");
		this.element.appendChild(path);
	}

	updateCurve(mousePosition) {
		const outputNode = this.sourceNode.element;
		const outputSocket = this.sourceNode.getOutputSocket(this.outputIndex).element;
		const outputX = outputNode.offsetLeft + outputSocket.offsetLeft + outputSocket.offsetWidth / 2;
		const outputY = outputNode.offsetTop + outputSocket.offsetTop + outputSocket.offsetHeight / 2;

		let inputX, inputY;
		if (this.targetNode) {
			const inputNode = this.targetNode.element;
			const inputSocket = this.targetNode.inputSocket.element;
			inputX = inputNode.offsetLeft + inputSocket.offsetLeft + inputSocket.offsetWidth / 2;
			inputY = inputNode.offsetTop + inputSocket.offsetTop + inputSocket.offsetHeight / 2;
		} else if (mousePosition){
			inputX = mousePosition[0];
			inputY = mousePosition[1];
		} else {
			return;
		}

		const lineCurve = _createCurvature(outputX, outputY, inputX, inputY);
		this.element.children[0].setAttributeNS(null, 'd', lineCurve);
	}
}
