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
        id: editorTitle
        x: 50
        text: "Choice Editor"
    }

    ListView {
        x: 50
        anchors {
            top: editorTitle.bottom
            topMargin: 20
            bottom: parent.bottom
        }
        width: parent.width
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