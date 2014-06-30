import QtQuick 2.0
import "components" as Components

Rectangle {
    id: viewport
    property bool showWidescreen: true
    property real globalScale: viewport.width / background.sourceSize.width

    color: "red"
    clip: true

    function startAnimating() {
        for (var i=0; i < spriteRepeater.count; i++) {
            spriteRepeater.itemAt(i).state = "animating";
        }
    }

    function showStart() {
        for (var i=0; i < spriteRepeater.count; i++) {
            spriteRepeater.itemAt(i).state = "start";
        }
    }

    function showEnd() {
        for (var i=0; i < spriteRepeater.count; i++) {
            spriteRepeater.itemAt(i).state = "end";
        }
    }

    Image {
        id: background
        source: '../../../saves/testproj/resources/' + display.backgroundSprite.filename
        anchors.fill: parent
        width: parent.width
    }

    Repeater {
        id: spriteRepeater
        model: display.sprites
        delegate: Components.AnimatedSprite {
            globalScale: viewport.globalScale
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
}