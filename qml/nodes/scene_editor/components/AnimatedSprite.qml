import QtQuick 2.0

Image {
    id: sprite
    property real globalScale

    source: '../../../../saves/testproj/resources/' + display.filename
    height: globalScale * sourceSize.height
    width: globalScale * sourceSize.width
    x: viewport.width * display.startX
    y: viewport.width * display.startY

    function startAnimating() {
        x = viewport.width * display.startX
        y = viewport.width * display.startY
        previewAnimation.start()
    }
    function showStart() {
        previewAnimation.stop()
        x = viewport.width * display.startX
        y = viewport.width * display.startY
    }
    function showEnd() {
        previewAnimation.stop()
        x = viewport.width * display.endX
        y = viewport.width * display.endY
    }

    SequentialAnimation {
        id: previewAnimation
        loops: Animation.Infinite

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
                to: viewport.width * display.endY
                duration: 1000
            }
        }
        PauseAnimation { duration: 1000 }
        PropertyAction {
            target: sprite
            property: "x"
            value: viewport.width * display.startX
        }
        PropertyAction {
            target: sprite
            property: "y"
            value: viewport.width * display.startY
        }
    }
}