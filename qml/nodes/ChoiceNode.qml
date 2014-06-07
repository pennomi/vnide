import QtQuick 2.0

Node {
    id: node
    width: choices.width
    height: choices.height
    ChoiceList { id: choices }

    function arrowYPos(index) {
        var h = choices.itemHeight;
        var p = choices.padding;
        return (p + h) * index + h / 2 + p;
    }

    editorComponent: Rectangle {
        anchors.fill: parent
        ListView {
            id: conditions
            anchors.fill: parent
            anchors.bottomMargin: 20
            spacing: 10
            model: display.exitConditions
            delegate: conditionItem
            clip: true
        }
        Image {
            id: addButton
            anchors {
                top: conditions.bottom
                bottom: parent.bottom
            }
            width: height
            source: "icons/add.svg"
            MouseArea {
                anchors.fill: parent
                onClicked: { nodeList.addCondition(nid) }
            }
        }
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
                onEdited: { display.text = newText; }
            }

            EditorField {
                anchors.top: choiceEditor.bottom
                anchors.topMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 32
                title: "Condition"
                text: display.condition
                onEdited: { display.condition = newText; }
            }

            Image {
                source: "icons/delete.svg"
                height: choiceEditor.height
                width: height
                anchors.left: choiceEditor.right

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("TODO: DELETE ME");
                    }
                }
            }
        }
    }
}