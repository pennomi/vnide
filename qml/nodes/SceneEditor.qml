import QtQuick 2.0

Rectangle {
    id: container
    property bool showWidescreen: true
    property real globalScale: viewport.width / background.sourceSize.width

    anchors.fill: parent

    // The view area
    Rectangle {
        id: viewport
        color: "red"
        clip: true
        anchors {
            left: parent.left
            right: parent.horizontalCenter
        }
        height: 9 / 16 * width  // 16:9 aspect ratio

        Image {
            id: background
            source: '../../saves/testproj/resources/' + display.backgroundSprite.filename
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        Repeater {
            model: display.sprites
            delegate: Image {
                source: '../../saves/testproj/resources/' + display.filename
                height: globalScale * sourceSize.height
                width: globalScale * sourceSize.width
                x: parent.width * display.startX
                y: parent.width * display.startY
                Component.onCompleted: {
                    console.log(display.startX)
                }
            }
        }

        // Cover bars
        Rectangle {
            color: "black"
            anchors.left: parent.left
            width: parent.width / 8
            height: parent.height
            opacity: showWidescreen ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }
        Rectangle {
            color: "black"
            anchors.right: parent.right
            width: parent.width / 8
            height: parent.height
            opacity: showWidescreen ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }

        // TODO: this is temporary!
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.showWidescreen = !showWidescreen
            }
        }
    }
}