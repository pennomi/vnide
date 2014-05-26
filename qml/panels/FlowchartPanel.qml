import QtQuick 2.0
import "../nodes" as Nodes

Rectangle {
    id: panel
    color: "white"

    Connections {
        target: nodeList
        onNodeMoved: {
            // Remember where the person was looking
            var oldX = flickable.contentX;
            var oldY = flickable.contentY;

            // Size the Flickable to the contents
            var minX = 99999;
            var minY = 99999;
            var maxX = -99999;
            var maxY = -99999;
            for (var i=0; i<nodeRepeater.count; i++) {
                var child = nodeRepeater.itemAt(i).item;
                minX = Math.min(child.x, minX);
                minY = Math.min(child.y, minY);
                maxX = Math.max(child.x + child.width, maxX);
                maxY = Math.max(child.y + child.height, maxY);
            }
            flickable.contentX = oldX;
            flickable.contentY = oldY;
            // Currently minX/minY have to be zero. The Flickable doesn't
            // support a non-0 start x or y
            minX = 0; minY = 0;
            flickable.contentWidth = maxX - minX;
            flickable.contentHeight = maxY - minY;
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent

        // TODO: Calculate the content width and height by
        // iterating over the nodes
        contentWidth: childrenRect.width
        contentHeight: childrenRect.height

        Repeater {
            id: nodeRepeater
            model: nodeList
            delegate: Nodes.NodeLoader {
                onBeganEditing: {
                    flickable.interactive = false;
                    z = 1.0  // Push it to the front
                }
                onEndedEditing: {
                    flickable.interactive = true;
                    z = 0.0  // Put it back where it belongs
                }
                Behavior on z { NumberAnimation {} }  // Avoids jerkiness
            }
        }

    }
}
