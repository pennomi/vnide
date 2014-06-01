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
        text: "Choice Editor"
    }

    ListView {
        anchors {
            top: editorTitle.bottom
            topMargin: 20
            bottom: parent.bottom
        }
        width: parent.width
        spacing: 15
        model: display.exitConditions
        delegate: Rectangle {
            width: childrenRect.width
            height: childrenRect.height

            /*Text {
                id: textLabel
                height: 30
                width: 100
                text: "Choice Text"
            }
            Rectangle {
                anchors.left: textLabel.right
                anchors.leftMargin: 10
                height: textLabel.height
                width: 200
                border.color: "black"
                border.width: 1
                TextInput {
                    anchors.fill: parent
                    anchors.margins: 3
                }
            }*/

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