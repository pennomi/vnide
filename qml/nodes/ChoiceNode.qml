import QtQuick 2.0

Node {
    id: node
    ChoiceList { id: choices }

    function arrowYPos(index) {
        var item = choices.itemAt(index);
        return item.mapToItem(choices, 0, item.height / 2).y + choices.padding;
    }

    editorComponent: ListView {
        spacing: 10
        model: display.exitConditions
        delegate: conditionItem
    }

    Component {
        id: conditionItem
        Rectangle {
            width: parent.width
            height: childrenRect.height
            color: "#00000000"

            EditorField {
                id: choiceEditor
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 32
                title: "Choice"
                text: display.text
            }

            EditorField {
                anchors.top: choiceEditor.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 32
                title: "Condition"
                text: display.condition
            }
        }
    }
}