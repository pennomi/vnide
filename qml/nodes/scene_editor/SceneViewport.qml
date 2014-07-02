import QtQuick 2.0
import "components" as Components

Rectangle {
    id: viewport
    property bool showWidescreen: true
    property bool showGuides: true
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
        source: {
            if (display.backgroundSprite.filename) {
                '../../../saves/testproj/resources/' + display.backgroundSprite.filename
            }
            else {
                ""
            }
        }
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

    // Guides
    // Fullscreen borders
    Rectangle {
        color: "#0000ff"
        opacity: showGuides ? .3 : 0
        height: viewport.height
        width: 1
        anchors.right: leftCover.right
        Behavior on opacity { NumberAnimation {} }
    }
    Rectangle {
        color: "#0000ff"
        opacity: showGuides ? .3 : 0
        height: viewport.height
        width: 1
        anchors.left: rightCover.left
        Behavior on opacity { NumberAnimation {} }
    }
    // Center lines
    Rectangle {
        color: "#00cc00"
        opacity: showGuides ? .3 : 0
        height: viewport.height
        width: 1
        anchors.horizontalCenter: viewport.horizontalCenter
        Behavior on opacity { NumberAnimation {} }
    }
    Rectangle {
        color: "#00cc00"
        opacity: showGuides ? .3 : 0
        width: viewport.width
        height: 1
        anchors.verticalCenter: viewport.verticalCenter
        Behavior on opacity { NumberAnimation {} }
    }
    // Rule of thirds lines
    Rectangle {
        color: "#cc0000"
        opacity: showGuides ? .3 : 0
        width: viewport.width
        height: 1
        y: viewport.height / 3
        Behavior on opacity { NumberAnimation {} }
    }
    Rectangle {
        color: "#cc0000"
        opacity: showGuides ? .3 : 0
        width: viewport.width
        height: 1
        y: viewport.height * 2 / 3
        Behavior on opacity { NumberAnimation {} }
    }
    Rectangle {
        color: "#cc0000"
        opacity: showGuides ? .3 : 0
        height: viewport.height
        width: 1
        x: viewport.width / 2 - viewport.width / 8
        Behavior on opacity { NumberAnimation {} }
    }
    Rectangle {
        color: "#cc0000"
        opacity: showGuides ? .3 : 0
        height: viewport.height
        width: 1
        x: viewport.width / 2 + viewport.width / 8
        Behavior on opacity { NumberAnimation {} }
    }

    // Cover bars
    Rectangle {
        id: leftCover
        color: "black"
        anchors.left: parent.left
        width: parent.width / 8
        height: parent.height
        opacity: showWidescreen ? 0 : 1
        Behavior on opacity { NumberAnimation {} }
    }
    Rectangle {
        id: rightCover
        color: "black"
        anchors.right: parent.right
        width: parent.width / 8
        height: parent.height
        opacity: showWidescreen ? 0 : 1
        Behavior on opacity { NumberAnimation {} }
    }
}