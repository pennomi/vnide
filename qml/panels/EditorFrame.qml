import QtQuick 2.0
import "../nodes" as Nodes

Nodes.NodeBorder {
    id: editor
    property Item node
    property bool editing: node && node.editing
    visible: editing
    anchors.fill: flickable

    Rectangle {
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
            id: closeArea
            anchors.fill: parent
            onClicked: { node.editing = false; }
        }
    }

    Image {
        source: "../nodes/icons/delete.svg"
        width: 32
        height: 32
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: node && node.type != "end" && node.type != "root"
        MouseArea {
            anchors.fill: parent
            onClicked: { node.editing = false; nodeList.removeNode(node.nid) }
        }
    }
}