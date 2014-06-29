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
            spriteRepeater.itemAt(i).startAnimating();
        }
    }

    function showStart() {
        for (var i=0; i < spriteRepeater.count; i++) {
            spriteRepeater.itemAt(i).showStart();
        }
    }

    function showEnd() {
        for (var i=0; i < spriteRepeater.count; i++) {
            spriteRepeater.itemAt(i).showEnd();
        }
    }

    Image {
        id: background
        source: '../../../saves/testproj/resources/' + display.backgroundSprite.filename
        anchors.fill: parent
        width: parent.width
        //fillMode: Image.PreserveAspectCrop
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