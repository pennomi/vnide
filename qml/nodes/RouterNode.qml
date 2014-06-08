import QtQuick 2.0

Node {
    id: node
    width: choices.width
    height: choices.height
    icon: "icons/router.svg"
    title: "Router"
    tint: "teal"

    ChoiceList { id: choices }

    function arrowYPos(index) {
        var h = choices.itemHeight;
        var p = choices.padding;
        return (p + h) * index + h / 2 + p;
    }

    editorComponent: ChoiceEditor { allowText: false }
}