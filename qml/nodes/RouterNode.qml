import QtQuick 2.0

Node {
    id: node
    width: choices.width
    height: choices.height
    ChoiceList { id: choices }

    function arrowYPos(index) {
        var item = choices.itemAt(index);
        return item.mapToItem(choices, 0, item.height / 2).y + choices.padding;
    }
}