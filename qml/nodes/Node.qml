import QtQuick 2.0

BorderImage {
    id: node
    source: "borders/frame.svg"
    border {
        top: 43
        bottom: 4
        left: 25
        right: 4
    }
    // Make all children of this actually appear in the editor
    //default property alias contents: editor.children
    property Component editorComponent
    //property alias editor: editorLoader.item
    property string color: style.white
    property string nid: display.nid
    property string type: display.type
    property bool editing: false

    x: display.x
    y: display.y - node.height/2

    height: childrenRect.height
    width: childrenRect.width

    function arrowYPos(index) {
        return node.height / 2;
    }

    /*Loader {
        id: editorLoader
        visible: editing
        Behavior on visible { NumberAnimation {} }

        parent: flickable
        x: flickable.contentX
        y: flickable.contentY
        width: flickable.width
        height: flickable.height

    }*/

    Item {
        id: arrows
        Repeater {
            id: arrowRepeater
            model: display.exitConditions
            delegate: Arrow {
                x1: node.width
                y1: arrowYPos(index) - weight / 2
                x2: display.nextX - node.x
                y2: display.nextY - node.y
                weight: 10
                onDropped: {
                    nodeList.insertNodeAfterParent(nid, index, source)
                }
            }
        }
    }

    Behavior on x {
        NumberAnimation {}
    }
    Behavior on y {
        NumberAnimation {}
    }
    Behavior on width {
        NumberAnimation {}
    }
    Behavior on height {
        NumberAnimation {}
    }

    // Mouse Actions
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        // If we've disabled the flickable, this should be as well.
        enabled: flickable.interactive

        onClicked: {
            if (!node.editorComponent){
                console.log("No source component. Not editing.")
                return;
            }
            editorFrame.node = node;
            node.editing = true;
        }
        onMouseXChanged: {
            if (editing) return;
            // TODO: Don't allow dragging to negative values. OR! Find a way to
            // make the Flickables less sucky
            display.x = node.x;
            display.y = node.y + height/2;
        }
        onMouseYChanged: onMouseXChanged
        drag {
            target: /*editing ? undefined : */node
        }
    }
}
