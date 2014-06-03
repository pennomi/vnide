import QtQuick 2.0

Node {
    id: node
    color: style.blue
    ChoiceList { id: choices }

    function arrowYPos(index) {
        var item = choices.itemAt(index);
        return item.mapToItem(choices, 0, item.height / 2).y + choices.padding;
    }

    editorComponent: ListView {
        x: 50
        //anchors {
            //top: parent.top
            //topMargin: 20
            //bottom: parent.bottom
        //}
        //width: parent.width
        spacing: 10
        model: display.exitConditions
        delegate: Rectangle {
            width: childrenRect.width
            height: childrenRect.height

            EditorField {
                id: choiceEditor
                anchors.topMargin: 5
                title: "Choice"
                text: display.text
            }

            EditorField {
                anchors.top: choiceEditor.bottom
                anchors.topMargin: 5
                title: "Condition"
                text: display.condition
            }
        }
    }
}