import QtQuick 2.0

Node {
    id: node
    width: choices.width
    height: choices.height
    icon: "icons/choice.svg"
    title: "Choice"
    tint: "#00aa44"

    function arrowYPos(index) {
        var h = choices.itemHeight;
        var p = choices.padding;
        return (p + h) * index + h / 2 + p;
    }

    ChoiceList { id: choices }
    editorComponent: ChoiceEditor {}
}