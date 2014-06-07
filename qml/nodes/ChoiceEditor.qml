import QtQuick 2.0

Rectangle {
    property bool allowText: true

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
    Text {
        anchors {
            top: addButton.top
            left: addButton.right
            leftMargin: 5
        }
        height: addButton.height
        text: "Add Another Choice"
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
                visible: allowText
            }

            EditorField {
                id: conditionEditor
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
                height: conditionEditor.height
                width: height
                anchors.top: conditionEditor.top
                anchors.left: choiceEditor.right
                anchors.leftMargin: 20

                MouseArea {
                    anchors.fill: parent
                    onClicked: { nodeList.removeCondition(nid, index) }
                }
            }
        }
    }
}
