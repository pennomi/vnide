import QtQuick 2.0

Rectangle {
    id: genericNode

    property int nid: model.nid

    x: model.x
    y: model.y

    width: 100
    height: 80
    radius: 5
    color: "red"
    border.color: "black"
    border.width: 2
    scale: selected ? 1.2 : 1.0

    // TODO: get the line list to populate correctly initially

    // Repopulates the lineList
    function recalculateLines(recurse) {
        console.log(nid + ": recalculate lines")
        lineList.clear()

        // Build a dictionary of nids to positions (TODO: Cache somehow)
        var nodesByID = {};
        for (var i=0; i<nodes.count; i++) {
            var n = nodes.get(i);
            nodesByID[n.nid] = n;
        }

        // Generate all child lines for this node
        for (var key in model.childNodes) {
            var child = nodesByID[key];
            lineList.append({"x2": child.x, "y2": child.y + height/2,})
        }

        // If a child moves, all parents need updated...
        if(!recurse) return;  // ...(but don't update ALL the nodes!)

        for (var i=0; i<nodes.count; i++) {
            var nodeElement = nodeRepeater.itemAt(i);
            if (String(nodeElement.nid) in model.parentNodes) {
                nodeElement.recalculateLines();
                return;
            }
        }
    }



    ListModel {
        id: lineList
    }

    Repeater {
        id: lineRepeater
        model: lineList
        delegate: Line {
            parent: genericNode.parent
            x1: genericNode.width
            y1: genericNode.height / 2
            x2: model.x2 - genericNode.x
            y2: model.y2 - genericNode.y
            color: "black"
        }
    }








    MouseArea {
        anchors.fill: parent
        onClicked: {
            nodes.setProperty(nodes.selectedIndex, "selected", false)
            nodes.setProperty(index, "selected", true)
            nodes.selectedIndex = index;
        }
        onMouseXChanged: {
            nodes.setProperty(index, "x", genericNode.x);
            nodes.setProperty(index, "y", genericNode.y);
            genericNode.recalculateLines(true)
        }
        onMouseYChanged: {
            nodes.setProperty(index, "x", genericNode.x);
            nodes.setProperty(index, "y", genericNode.y);
            genericNode.recalculateLines(true)
        }

        drag { target: genericNode }
    }

    Behavior on scale {
        NumberAnimation {}
    }
}
