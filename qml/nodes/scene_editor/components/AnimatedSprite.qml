import QtQuick 2.0

Image {
    id: sprite
    property real globalScale

    source: '../../../../saves/testproj/resources/' + display.filename
    height: globalScale * sourceSize.height
    width: globalScale * sourceSize.width
    x: viewport.width * display.startX
    y: viewport.height * display.startY
    state: "start"

    states: [
        State {
            name: "start"
            PropertyChanges {
                target: sprite
                x: viewport.width * display.startX
                y: viewport.height * display.startY
            }
        },
        State {
            name: "end"
            PropertyChanges {
                target: sprite
                x: viewport.width * display.endX
                y: viewport.height * display.endY
            }
        },
        State {
            name: "animating"
            PropertyChanges {
                target: sprite
                x: viewport.width * display.startX
                y: viewport.height * display.startY
            }
        }
    ]

    MouseArea {
        anchors.fill: parent
        enabled: !previewAnimation.running
        drag.target: sprite
        onReleased: {
            if (sprite.state == "start") {
                display.startX = sprite.x / viewport.width;
                display.startY = sprite.y / viewport.height;
            } else if (sprite.state == "end") {
                display.endX = sprite.x / viewport.width;
                display.endY = sprite.y / viewport.height;
            }
        }
    }

    SequentialAnimation {
        id: previewAnimation
        running: sprite.state == "animating"
        loops: Animation.Infinite

        PropertyAction {
            target: sprite
            property: "x"
            value: viewport.width * display.startX
        }
        PropertyAction {
            target: sprite
            property: "y"
            value: viewport.height * display.startY
        }
        ParallelAnimation {
            NumberAnimation {
                target: sprite
                property: "x"
                to: viewport.width * display.endX
                duration: 1000
            }
            NumberAnimation {
                target: sprite
                property: "y"
                to: viewport.height * display.endY
                duration: 1000
            }
        }
        PauseAnimation { duration: 1000 }
    }
}