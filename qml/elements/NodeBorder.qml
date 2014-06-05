import QtQuick 2.0

Item {
    id: container
    property real hue: Math.random()

    BorderImage {
        source: "borders/frame.svg"
        anchors.fill: parent
        border {
            top: 43
            bottom: 4
            left: 25
            right: 4
        }

        ColorizeEffect { hue: container.hue }
    }
}