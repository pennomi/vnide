import QtQuick 2.0

Node {
    id: node
    color: "white"

    width: 100
    height: 80

    Text {
        anchors.fill: parent
        anchors.margins: 5
        text: display.text
        font.pointSize: 10
        wrapMode: Text.WordWrap
    }

    Image {
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.bottom
        height: 32
        width: 32
        smooth: true
        source: display.filename ? "../../saves/testproj/resources/" + display.filename : ""
    }
}