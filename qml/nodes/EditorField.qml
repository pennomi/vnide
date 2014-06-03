import QtQuick 2.0

Item {
    id: container
    property alias title: label.text
    property alias text: input.text
    height: childrenRect.height
    width: childrenRect.width

    Text {
        id: label
        height: 30
        width: 100
    }
    Rectangle {
        anchors.top: label.top
        anchors.left: label.right
        anchors.leftMargin: 10
        height: label.height
        width: 200
        border.color: "black"
        border.width: 1
        TextInput {
            id: input
            anchors.fill: parent
            anchors.margins: 3
        }
    }
}