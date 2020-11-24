import {htmlToElement, Vector2} from "../utils.js";
import {BackgroundImageNode, CharacterEnterNode, CharacterExitNode} from "../nodes/nodeTypes/environmentNodes.js";
import {ChoiceNode, TextNode} from "../nodes/nodeTypes/storyNodes.js";
import {SceneEndNode, SceneStartNode} from "../nodes/nodeTypes/sceneNodes.js";

const PLAYER_TEMPLATE = `
<div class="vnide-player">
	<div class="safe-area">
		<div class="text-area">
			<h1>Speaker Name</h1>
			<p>Content</p>
		</div>
		<div class="choice-area"></div>
	</div>
</div>
`;


export class VnidePlayer {
	activeCharacters = {};

	constructor(container, project, scene) {
		this.container = container;
		this.recreatePlayerElement();

		this.frozen = false;  // Set this to true if you want to use it in a images context

		// Calculate the safe size and background size
		let style = getComputedStyle(document.documentElement);
		this.safeWidth = parseInt(style.getPropertyValue('--safe-width').replace("px", ""));
		this.safeHeight = parseInt(style.getPropertyValue('--safe-height').replace("px", ""));
		this.backgroundWidth = Math.ceil(this.safeHeight * 2.2);  // 2.2:1 aspect ratio (iPhoneX)
		this.backgroundHeight = Math.ceil(this.safeWidth / 4 * 3);  // 4:3 aspect ratio (iPad)

		// Bind the resize code
		this.observer = new ResizeObserver(this.updateSafeArea.bind(this));
		this.observer.observe(this.element);

		// Bind the click code
		this.element.addEventListener("click", this.handleClick.bind(this));

		// Initialize the project
		this.project = project;
		this.scene = scene;


		this.advance().then();
	}

	recreatePlayerElement() {
		this.element = htmlToElement(PLAYER_TEMPLATE);
		if (this.container) {
			this.container.innerHTML = "";
			this.container.appendChild(this.element);
		}

		// Save some queries for faster use later
		this.safeAreaElement = this.element.querySelector(".safe-area");
		this.textAreaElement = this.element.querySelector(".text-area");
		this.textSpeakerNameElement = this.element.querySelector(".text-area h1");
		this.textContentElement = this.element.querySelector(".text-area p");
		this.choiceAreaElement = this.element.querySelector(".choice-area");

		this.updateSafeArea();
	}

	updateSafeArea() {
		// Base calculations
		let scaleX = this.element.offsetWidth / this.safeAreaElement.offsetWidth;
		let scaleY = this.element.offsetHeight / this.safeAreaElement.offsetHeight;
		let scale = Math.min(scaleX, scaleY);

		// Update the background size
		this.element.style.backgroundSize = `${this.backgroundWidth * scale}px ${this.backgroundHeight * scale}px`;
		this.element.style.backgroundPosition = `${(this.element.offsetWidth - this.backgroundWidth * scale) / 2.0}px ${(this.element.offsetHeight - this.backgroundHeight * scale)}px`;

		// Update the safe area
		this.safeAreaElement.style.transform = `scale(${scale})`;
	}

	async handleClick(e) {
		if (this.frozen) {
			return;
		}

		// TODO: This doesn't block clicks outside of the safe area
		if (this.choiceAreaElement.contains(e.target)) {
			return;
		}
		await this.advance(0);
	}

	async advance(outputIndex=0) {
		let node = this.scene.advance(outputIndex);

		await this.processNodeToElements(node);

		// If the node wants to auto-advance then recurse.
		if (node.constructor.autoAdvance && !this.frozen) {
			await this.advance(0);
		}

		return true;
	}

	recreateStateForNode(node) {
		let path = this.scene.reverseWalkNode(node);
		this.recreatePlayerElement();
		if (path === null) {
			return;
		}
		for (let node of path) {
			this.processNodeToElements(node, false).then();
		}
	}

	async processNodeToElements(node, wait=true) {
		// Reset most state
		this.textAreaElement.style.visibility = "hidden";
		this.choiceAreaElement.style.visibility = "hidden";

		// TODO: How to execute a new node? For now just hardcode it here by class
		if (node.constructor === BackgroundImageNode) {
			let url = await this.project.filesystem.getFileImageUrl(node.data.backgroundImage);
			this.element.style.backgroundImage = `url(${url}`;
		} else if (node.constructor === CharacterEnterNode) {
			let character = this.project.getCharacterById(node.data.character);
			this.activeCharacters[character.name] = new CharacterElement(character, new Vector2(node.data.positionX, node.data.positionY), this.project);
			this.safeAreaElement.appendChild(this.activeCharacters[character.name].element);
		} else if (node.constructor === CharacterExitNode) {
			let character = this.project.getCharacterById(node.data.character);
			let toDelete = this.activeCharacters[character.name];
			toDelete.element.remove();
		} else if (node.constructor === TextNode) {
			this.textAreaElement.style.visibility = "visible";
			this.textSpeakerNameElement.innerHTML = node.data.character;
			this.textContentElement.innerHTML = node.data.text;
		} else if (node.constructor === ChoiceNode) {
			this.choiceAreaElement.style.visibility = "visible";
			let html = "";
			for (let c of [node.data.choice1, node.data.choice2, node.data.choice3]) {
				html += `<button>${c}</button>`
			}
			this.choiceAreaElement.innerHTML = html;
			this.choiceAreaElement.querySelectorAll("button").forEach((element)=>{
				element.addEventListener("click", (e)=>{
					if (this.frozen) { return; }
					let index = Array.from(element.parentNode.childNodes).indexOf(element);
					this.advance(index);
				});
			});

		} else if (node.constructor === SceneStartNode) {
			this.recreatePlayerElement();
		} else if (node.constructor === SceneEndNode) {
			console.log("Scene ended.");
			this.recreatePlayerElement();
			return false;
		} else {
			console.warn(`${node.constructor.name} not yet implemented`);
		}
	}
}



const CHARACTER_TEMPLATE = `
<div class="character">
	<img src="" alt="Character"/>
</div>
`;


export class CharacterElement {
	constructor(character, position, project) {
		this.project = new WeakRef(project);

		this.name = character.name;

		this.position = position;

		this.element = htmlToElement(CHARACTER_TEMPLATE)
		this.element.style.left = this.position.x + "px";
		this.element.style.bottom = this.position.y + "px";

		this.imgElement = this.element.querySelector("img");

		this.imgElement.src = character.images[0].url;
	}
}
