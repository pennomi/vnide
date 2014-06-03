import QtQuick 2.0
import "../nodes" as Nodes

Rectangle {
    id: panel

    function recalculateBounds() {
        // Remember where the person was looking
        var oldX = flickable.contentX;
        var oldY = flickable.contentY;

        // Size the Flickable to the contents
        var minX = 99999;
        var minY = 99999;
        var maxX = -99999;
        var maxY = -99999;
        for (var i=0; i<nodeRepeater.count; i++) {
            if (!nodeRepeater.itemAt(i)) continue;
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

    Connections {
        target: nodeList
        onNodeMoved: recalculateBounds()
    }

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: childrenRect.width
        contentHeight: childrenRect.height
        interactive: !editorFrame.editing

        Repeater {
            id: nodeRepeater
            model: nodeList
            onItemAdded: recalculateBounds()
            delegate: Nodes.NodeLoader {}
        }
    }

    EditorFrame { id: editorFrame }
}
