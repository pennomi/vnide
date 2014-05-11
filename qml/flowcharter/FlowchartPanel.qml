import QtQuick 2.0
import "nodes" as Nodes

Rectangle {
    color: "#dddddd"

    Flickable {
        anchors.fill: parent

        // TODO: Calculate the content width and height by
        // iterating over the nodes
        contentWidth: 1000
        contentHeight: 1000

        Repeater {
            id: nodeRepeater
            model: nodes
            delegate: Nodes.Node {
                nid: model.nid
                x: model.x
                y: model.y
                selected: model.selected
                parentNodeIDs: model.parentNodeIDs
                childNodeIDs: model.childNodeIDs
            }

            // This function forces the lines to update
            function updateLinesForNid(nid) {
                for (var i=0; i<nodes.count; i++) {
                    var nodeElement = nodeRepeater.itemAt(i);
                    if (nodeElement.nid === nid) {
                        nodeElement.recalculateLines();
                        return;
                    }
                }
            }
        }

    }

}
