import QtQuick 2.0

Rectangle {
    id: editor
    property Item node
    property bool editing: node && node.editing
    visible: editing
    anchors.fill: flickable
    color: "red"

    Loader {
        id: editorFormLoader
        anchors.fill: parent
        sourceComponent: editing ? node.editorComponent : undefined
    }

    Image {
        id: closeImage
        source: "icons/close.svg"
        width: 64
        height: 64
        anchors.right: parent.right
        MouseArea {
            anchors.fill: parent
            onClicked: {
                node.editing = false;
            }
        }
    }
}