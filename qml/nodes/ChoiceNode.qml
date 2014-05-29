import QtQuick 2.0

Node {
    id: node
    color: style.blue

    iconComponent: Rectangle {
        property real padding: 5
        height: childrenRect.height + padding * 2
        width: childrenRect.width + padding * 2
        color: node.color

        Column {
            id: col
            x: padding
            y: padding
            width: childrenRect.width
            spacing: 10
            Repeater {
                model: display.exitConditions
                delegate: Rectangle {
                    color: "#00000000"
                    height: 32
                    width: childrenRect.width
                    Text {
                        id: choiceText
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        height: 10
                        font.pointSize: height
                        text: display.text
                    }
                    Text {
                        anchors.top: choiceText.bottom
                        anchors.topMargin: 3
                        height: 8
                        font.pointSize: height
                        font.italic: true
                        text: display.condition
                    }
                }
            }
        }
    }
}