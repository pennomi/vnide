import QtQuick 2.0

Item {
    id: container
    property real hue: Math.random()

    BorderImage {
        source: "borders/frame.svg"
        anchors.fill: parent
        border {
            top: 35
            bottom: 5
            left: 25
            right: 4
        }
        // z: 1  // Reimplement this once it has a hole in it

        ColorizeEffect { hue: container.hue }
    }
}