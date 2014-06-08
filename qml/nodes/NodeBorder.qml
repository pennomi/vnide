import QtQuick 2.0

Item {
    id: container
    property alias icon: iconImage.source
    property color tint
    property alias title: titleText.text

    BorderImage {
        source: "borders/frame.svg"
        anchors.fill: parent
        border {
            top: 35
            bottom: 5
            left: 25
            right: 4
        }
        z: 1
        ColorizeEffect { tint: container.tint }
    }
    Image {
        id: iconImage
        x: 3
        y: 8
        width: 16
        height: 16
        z: 1
        ColorizeEffect { tint: container.tint }
    }
    Text {
        id: titleText
        anchors{
            left: parent.left
            leftMargin: 0
            bottom: parent.bottom
            bottomMargin: 4
        }
        rotation: -90
        width: 8
        height: 8
        font.pointSize: 7
        color: "#111111"
        z: 1
    }

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 12
        }
        color: "#d27878"
        ColorizeEffect { tint: container.tint }
    }
}