


/**
 * @param qs - Query Selector
 * @param tp - Path to an HTML template in the templates folder
 * @param ctx - JS context which will be passed to the template
 */
export function renderElementContents(qs, tp, ctx) {
	document.querySelector(qs).innerHTML = nunjucks.render(tp, ctx);
}

export function createElementFromTemplate(tp, ctx) {
	return htmlToElement(nunjucks.render(tp, ctx));
}


export async function sleep(seconds) {
  return new Promise(resolve => setTimeout(resolve, Math.floor(seconds * 1000)));
}

export function uuidv4() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}


/**
 * @param {String} html - HTML representing a single element
 * @return {Element}
 */
export function htmlToElement(html) {
	const template = document.createElement('template');
	html = html.trim();  // Never return a text node of whitespace as the result
	template.innerHTML = html;
	return template.content.firstChild;
}


/* Handling CSS Transforms */
const I = new WebKitCSSMatrix();
export class Vector2 {
	constructor(x, y) {
		this.x = x;
		this.y = y;
	}

	transformBy = function (matrix) {
		const tmp = matrix.multiply(I.translate(this.x, this.y));
		return new Vector2(tmp.m41, tmp.m42, tmp.m43);
	};
}

function _getTransformationMatrix(element) {
	let transformationMatrix = I;
	let x = element;

	while (x !== undefined && x !== x.ownerDocument.documentElement) {
		const computedStyle = window.getComputedStyle(x, undefined);
		const transform = computedStyle.transform || "none";
		const c = transform === "none" ? I : new WebKitCSSMatrix(transform);
		transformationMatrix = c.multiply(transformationMatrix);
		x = x.parentNode;
	}

	const w = element.offsetWidth;
	const h = element.offsetHeight;
	const p1 = new Vector2(w, 0, 0).transformBy(transformationMatrix);
	const p2 = new Vector2(w, h, 0).transformBy(transformationMatrix);
	const p3 = new Vector2(0, h, 0).transformBy(transformationMatrix);
	const left = Math.min(p1.x, p2.x, p3.x);
	const top = Math.min(p1.y, p2.y, p3.y);

	const rect = element.getBoundingClientRect();
	transformationMatrix = I.translate(window.pageXOffset + rect.left - left, window.pageYOffset + rect.top - top, 0).multiply(transformationMatrix);

	return transformationMatrix;
}
export function convertPointFromPageToNode (element, pageX, pageY) {
	return new Vector2(pageX, pageY, 0).transformBy(_getTransformationMatrix(element).inverse());
}
export function convertPointFromNodeToPage (element, offsetX, offsetY) {
	return new Vector2(offsetX, offsetY, 0).transformBy(_getTransformationMatrix(element));
}
