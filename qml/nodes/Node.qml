import QtQuick 2.0
import "../elements" as Elements

Elements.NodeBorder {
    id: node
    property Component editorComponent
    property string nid: display.nid
    property string type: display.type
    property bool editing: false
    property alias dragArea: mouseArea

    x: display.x
    y: display.y - node.height/2

    function arrowYPos(index) {
        return node.height / 2;
    }

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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: flickable.interactive

        onClicked: {
            if (!node.editorComponent){
                console.log("Editing not implemented for " + node + ".")
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
        drag.target: node
        onReleased: { parent.Drag.drop() }
    }

    // End nodes can be dropped on another node to merge them
    DropArea {
        anchors.fill: parent
        keys: node.type == "end" ? ["NoMergingAllowed"] : ["MergeEndNode"]
        onDropped: { nodeList.mergeNodes(drag.source.nid, node.nid) }
    }


}
