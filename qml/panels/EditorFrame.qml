import QtQuick 2.0
import "../elements" as Elements

Elements.NodeBorder {
    id: editor
    property Item node
    property bool editing: node && node.editing
    visible: editing
    anchors.fill: flickable

    // TODO: An alternate interface border for this, please.
    Elements.NodeBorder {
        anchors {
            fill: parent
            margins: 32
        }

        Loader {
            id: editorFormLoader
            anchors {
                fill: parent
                topMargin: 3
                bottomMargin: 3
                leftMargin: 3
                rightMargin: 3
            }
            clip: true
            sourceComponent: editing ? node.editorComponent : undefined
        }
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