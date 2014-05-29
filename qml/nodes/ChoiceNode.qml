import QtQuick 2.0

Node {
    id: node

    iconComponent: Rectangle {
        height: childrenRect.height
        width: childrenRect.width
        color: "green"

        Column {
            id: col
            width: childrenRect.width
            Repeater {
                model: display.exitConditions
                delegate: Rectangle {
                    color: "blue"
                    height: 40
                    width: childrenRect.width
                    Text {
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        height: 20
                        text: display.text
                    }
                }
            }
        }
    }
}