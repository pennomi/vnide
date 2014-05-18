import QtQuick 2.0

ListModel {
    id: nodes

    property int selectedIndex: -1

    Component.onCompleted: {
        nodes.append({
                         nid: 314159,
                         x: 5,
                         y: 30,
                         selected: false,
                         parentNodes: {},
                         childNodes: { 9277: "" },
                     });
        nodes.append({
                         nid: 9277,
                         x: 120,
                         y: 30,
                         selected: false,
                         parentNodes: { 314159: "" },
                         childNodes: {},
                     });
    }

    function getByNid(nid) {
        nid = Number(nid);
        for (var i=0; i<nodes.count; i++) {
            var current = nodes.get(i);
            if (current.nid === nid) {
                return current;
            }
        }
        console.log("Cound not find nid " + nid)
        return undefined;
    }

    function referenceData(nids) {
        var temp = {};
        for (var i=0; i<nids.length; i++) {
            temp[nids[i]] = undefined;
        }
        return temp;
    }

    function insertType(type) {
        // calculate next nid
        var nextNid = 0;
        for (var i=0; i<nodes.count; i++) {
            nextNid = Math.max(nextNid, nodes.get(i).nid + 1)
        }

        // put the new node into the list
        var selectedNode = nodes.get(selectedIndex);
        nodes.append({
                         nid: nextNid,
                         x: selectedNode.x + 100,
                         y: selectedNode.y,
                         selected: false,
                         parentNodes: referenceData([selectedNode.nid]),
                         childNodes: selectedNode.childNodes
                     });
        // set the child's parent to this
        for (var childNid in selectedNode.childNodes) {
            var child = getByNid(childNid);
            child.parentNodes = referenceData([nextNid]);
        }
        // set the parent's child nodes to this
        selectedNode.childNodes = referenceData([nextNid]);


    }
}
