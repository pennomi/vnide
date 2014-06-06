import QtQuick 2.0

Node {
    id: node
    width: 100
    height: 40

    Item {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 20

        Text {
            anchors.fill: parent
            text: display.filename
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
            font.italic: true
        }
    }
}