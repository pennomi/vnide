import QtQuick 2.0

Node {
    id: node
    color: "white"

    iconComponent: Rectangle {
        width: 32
        height: width
        radius: width / 2
        color: node.color
        border {
            color: "black"
            width: 2
        }
        Image {
            source: "icons/root.svg"
            anchors.fill: parent
            anchors.margins: 5
        }
    }
}