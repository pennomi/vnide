import QtQuick 2.0

Node {
    id: node
    color: "#d9534f"
    width: 32
    height: width

    iconComponent: Rectangle {
        radius: node.width / 2
        color: node.color
        border {
            color: "black"
            width: 2
        }
        Text {
            text: "?"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}