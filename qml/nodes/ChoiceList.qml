import QtQuick 2.0

Rectangle {
    property real padding: 5
    height: childrenRect.height + padding * 2
    width: childrenRect.width + padding * 2
    color: node.color
    radius: 5
    border {
        width: 2
        color: style.black
    }

    Column {
        id: col
        x: padding
        y: padding
        width: childrenRect.width
        spacing: padding
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
                    height: display.text ? 10 : 0
                    font.pointSize: 10
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
                Rectangle {
                    visible: index  // only show if not the first item
                    height: 1
                    width: col.width
                    color: style.black
                }
            }
        }
    }
}