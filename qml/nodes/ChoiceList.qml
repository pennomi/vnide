import QtQuick 2.0
import "../elements" as Elements

Elements.NodeBorder {
    property real padding: 5
    height: childrenRect.height + padding * 2
    width: childrenRect.width + style.leftBorderPadding - 1

    function itemAt(index) {
        return choiceRepeater.itemAt(index)
    }

    Column {
        id: col
        x: style.leftBorderPadding
        width: childrenRect.width
        spacing: padding
        Repeater {
            id: choiceRepeater
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
                    x: padding * 2
                    width: paintedWidth + padding
                }
                Text {
                    anchors.top: choiceText.bottom
                    anchors.topMargin: 3
                    height: 8
                    font.pointSize: height
                    font.italic: true
                    text: display.condition
                    x: padding * 2
                    width: paintedWidth + padding
                }

                // TODO: This will be a shiny separator
                Rectangle {
                    visible: index  // only show if not the first item
                    x: -3
                    height: 3
                    width: col.width
                    color: "#686868"
                    Rectangle {
                        height: 1
                        width: parent.width
                        color: "#424242"
                    }
                    Rectangle {
                        y: 2
                        height: 1
                        width: parent.width
                        color: "#2f2f2f"
                    }
                    Rectangle {
                        x: 1
                        y: 3
                        height: 2
                        width: parent.width - 2
                        color: "#a5a5a5"
                    }
                }
            }
        }
    }
}