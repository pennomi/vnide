import QtQuick 2.0

Node {
    id: node
    color: "#d9534f"
    height: 30
    width: 30

    iconComponent: Rectangle {
        radius: 15
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