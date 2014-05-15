import QtQuick 2.0
import "panels" as Panels

Rectangle {
    id: app
    width: 800
    height: 600
    color: "black"

    ListModel {
        id: nodes

        property int selectedIndex: 0

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

        function insertType(type) {
            // calculate next nid
            var nextNid = 0;
            for (var i=0; i<nodes.count; i++) {
                nextNid = Math.max(nextNid, nodes.get(i).nid + 1)
            }

            // insert after selectedIndex
            var insertAfter = nodes.get(selectedIndex);
            var newParentNodes = {};
            newParentNodes[insertAfter.nid] = "";
            nodes.append({
                             nid: nextNid,
                             x: 0,
                             y: 0,
                             selected: false,
                             parentNodes: newParentNodes,
                             childNodes:  insertAfter.childNodes
                         });
            var newChildNodes = {};
            newChildNodes[nextNid] = "";
            insertAfter.childNodes = newChildNodes;
        }
    }

    Grid {
        anchors.fill: parent
        columns: 2
        rows: 2
        spacing: 2

        Panels.FlowchartPanel {
            width: parent.width * .8
            height: parent.height * .8
        }
        Panels.EditPanel {
            width: parent.width * .2
            height: parent.height * .8
        }
        Panels.InsertPanel {
            width: parent.width * .8
            height: parent.height * .2
        }
        Panels.PreviewPanel {
            width: parent.width * .2
            height: parent.height * .2
        }
    }

}
