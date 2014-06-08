import QtQuick 2.0

Node {
    id: node

    width: 32
    height: width
    Text {
        text: "?"
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}