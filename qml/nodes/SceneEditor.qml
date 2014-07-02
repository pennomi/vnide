import QtQuick 2.0
import "scene_editor" as Editor

Rectangle {
    id: container
    property bool showWidescreen: true

    anchors.fill: parent

    // The view area
    Editor.SceneViewport {
        id: viewport
        anchors {
            left: parent.left
            right: details.left
        }
        height: 9 / 16 * width  // 16:9 aspect ratio
    }

    Editor.SceneControls {
        viewport: viewport
        width: viewport.width
        anchors {
            top: viewport.bottom
            bottom: parent.bottom
        }
    }

    Editor.SpriteDetailList {
        id: details
        width: 350
        anchors {
            right: parent.right
        }
        height: parent.height
    }
}