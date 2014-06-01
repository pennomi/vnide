import QtQuick 2.0

Node {
    id: node
    color: style.blue
    iconComponent: ChoiceList {}

    function arrowYPos(index) {
        var item = icon.itemAt(index);
        return item.mapToItem(icon, 0, item.height / 2).y;
    }

    Text {
        text: "Choice Editor"
    }

    ListView {

    }
}