import QtQuick 2.0

Node {
    id: node
    color: "white"
    width: 32
    height: width

    iconComponent: Rectangle {
        radius: node.width / 2
        color: node.color
        border {
            color: "black"
            width: 2
        }
        Image {
            source: "bug.svg"
            anchors.fill: parent
        }
    }
}