import {SceneStartNode} from "./nodes/nodeTypes/sceneNodes.js";
import {uuidv4, Vector2} from "./utils.js";
import {VnideConnection} from "./nodes/connection.js";
import {VnideNode} from "./nodes/node.js";


export class Scene {
	constructor(id) {
		this.id = id || uuidv4();
		this.nodes = [];
		this.connections = [];
		this.path = [];
		this.filepath = null;
		this.name = "";
	}

	serialize() {
		let data = {
			id: this.id,
			nodes: this.nodes.map(n=>n.serialize()),
			connections: this.connections.map(c=>c.serialize()),
		};
		const dataExport = JSON.parse(JSON.stringify(data));
		return dataExport;
	}

	static deserialize(data, project, filepath) {
		let scene = new Scene(data.id);
		scene.filepath = filepath;
		scene.name = data.name || "Untitled Scene";
		scene.nodes = data.nodes.map(_ => VnideNode.deserialize(_, project));
		scene.connections = data.connections.map(_ => VnideConnection.deserialize(_, scene));
		return scene;
	}

	static createNew(name, project) {
		let scene = new Scene();
		scene.name = name;
		scene.filepath = `scenes/${name}.json`;

		// Every graph needs a singular start node
		let startNode = new SceneStartNode(project, "start", new Vector2(0, 0));
		scene.addNode(startNode);

		return scene;
	}

	addNode(node) {
		this.nodes.push(node);
		return node;
	}

	getNode(id) {
		let node = this.nodes.filter(n=>n.id.toString() === id.toString())[0];
		if (node === undefined) {
			throw Error("Node was not found");
		}
		return node;
	}

	removeNode(node) {
		// Remove all node connections
		this.connections.filter(
			c=>c.targetNode === node || c.sourceNode === node
		).forEach((c)=>{
			this.removeConnection(c);
		});

		// Remove the node
		node.element.remove();
		this.nodes = this.nodes.filter(n => n !== node);
	}

	addConnection(sourceNode, outputIndex, targetNode) {
		// Verify the connection is legal
		if (this.connections.filter(c=>c.sourceNode === sourceNode && c.outputIndex === outputIndex)[0]) {
			throw Error("This socket already has an output");
		}

		// Create the connection
		let connection = new VnideConnection(sourceNode, outputIndex, targetNode);
		this.connections.push(connection);
		connection.updateCurve();
		return connection;
	}

	getOutputConnectionsForNode(node) {
		let connections = this.connections.filter(c=>c.sourceNode === node);
		connections.sort((a, b)=>a.outputIndex - b.outputIndex);
		return connections;
	}

	getInputConnectionsForNode(node) {
		let connections = this.connections.filter(c=>c.targetNode === node);
		return connections;
	}

	removeConnection(connection) {
		if (!connection) {
			return;
		}
		this.connections = this.connections.filter(x=>x !== connection);
		connection.element.remove();
	}

	advance(outputIndex=0) {
		// If we haven't started yet, use the SceneStartNode as the first node.
		if (this.path.length === 0) {
			let startNode = this.nodes.filter(n=>n instanceof SceneStartNode)[0];
			if (startNode === undefined) { throw Error("No SceneStartNode is available."); }
			this.path.push(startNode);
		}

		// Find the output of the active node and follow it.
		let activeNode = this.path[this.path.length-1];
		let connections = this.getOutputConnectionsForNode(activeNode);
		let selectedConnection = connections[outputIndex];
		let newNode = selectedConnection.targetNode;
		this.path.push(newNode);

		return newNode;
	}

	reverseWalkNode(node) {
		// Walk backwards through the scene graph until we get to a start location using any possible path.
		let activeNode = node;
		let path = [node];

		let counter = 0;
		while (activeNode.constructor !== SceneStartNode) {
			let inputs = this.getInputConnectionsForNode(activeNode);
			inputs = inputs.filter(i=>path.indexOf(i.sourceNode) === -1)
			if (inputs.length === 0) {
				// We encountered a path that had no inputs.
				// We possibly could get trapped by this since we don't backtrace (yet). I'll fix it when/if it happens.
				return null;
			}
			activeNode = inputs[0].sourceNode;
			path.push(activeNode);
			counter += 1;
			if (counter > 1000) {
				throw Error("Someone screwed up and an infinite loop caught us.");
			}
		}

		// Reverse it so it's in the right order
		path.reverse();
		return path;
	}
}
