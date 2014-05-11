import QtQuick 2.0

Rectangle {
    id: genericNode

    property int nid: 0
    property bool selected
    property variant parentNodeIDs: []
    property variant childNodeIDs: []

    width: 100
    height: 80
    radius: 5
    color: "red"
    border.color: "black"
    border.width: 2
    scale: selected ? 1.2 : 1.0




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
        for (var j=0; j<genericNode.childNodeIDs.count; j++) {
            var node_data = genericNode.childNodeIDs.get(j);
            var child = nodesByID[node_data.nid];
            lineList.append({"x2": child.x, "y2": child.y + height/2,})
        }

        // If a child moves, the parent needs updated
        if(recurse) {
            for (var i=0; i<genericNode.parentNodeIDs.count; i++) {
                var recurse_nid = genericNode.parentNodeIDs.get(i).nid;
                nodeRepeater.updateLinesForNid(recurse_nid);
            }
        }
    }



    ListModel {
        id: lineList

        Component.onCompleted: {
            genericNode.recalculateLines();
        }
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
