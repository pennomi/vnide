import QtQuick 2.0
import "panels" as Panels
import "nodes" as Nodes

Rectangle {
    id: app
    width: 800
    height: 600
    color: "black"

    //Nodes.NodeList{ id: nodes }

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
