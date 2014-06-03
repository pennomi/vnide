import QtQuick 2.0

Node {
    id: node

    Rectangle {
        width: 32
        height: width
        radius: width / 2
        color: style.red
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