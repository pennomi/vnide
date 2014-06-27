import QtQuick 2.0
import "components" as Components

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

        function startAnimating() {
            for (var i=0; i < spriteRepeater.count; i++) {
                spriteRepeater.itemAt(i).startAnimating();
            }
        }

        function stopAnimating() {
            for (var i=0; i < spriteRepeater.count; i++) {
                spriteRepeater.itemAt(i).stopAnimating();
            }
        }

        Image {
            id: background
            source: '../../saves/testproj/resources/' + display.backgroundSprite.filename
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        Repeater {
            id: spriteRepeater
            model: display.sprites
            delegate: Components.AnimatedSprite {
                globalScale: container.globalScale
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

        MouseArea {
            anchors.fill: parent
            onClicked: {
                //container.showWidescreen = !showWidescreen
                // TODO: on window resize, reset the animation like this
                viewport.stopAnimating()
                viewport.startAnimating()
            }
        }
    }
}