import QtQuick 2.0

Node {
    id: node

    width: 100
    height: 80

    Text {
        anchors {
            fill: parent
            topMargin: 5
            bottomMargin: 5
            rightMargin: 5
            leftMargin: style.leftBorderPadding
        }
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