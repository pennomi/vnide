import QtQuick 2.0
import "scene_editor" as Scene

Node {
    id: node
    width: 110
    height: 80
    icon: "icons/scene.svg"
    title: "Scene"
    tint: "#5529dd"

    Scene.SceneViewport {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 12
        showGuides: false
        Component.onCompleted: {
            console.log(display.backgroundSprite.filename)
        }
    }
    /*Image {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 12
        source: "../../saves/testproj/resources/Tavern1600x1200_0.png"
        fillMode: Image.PreserveAspectCrop
    }*/

    editorComponent: SceneEditor{}
}