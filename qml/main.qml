import QtQuick 2.0
import "panels" as Panels
import "nodes" as Nodes

Rectangle {
    id: app
    width: 800
    height: 600
    color: "black"

    Style { id: style }

    Panels.FlowchartPanel {
        id: flowchart
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: insert.top
        anchors.bottomMargin: 2
    }
    Panels.InsertPanel {
        id: insert
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 120
        width: parent.width * .8
    }
    Panels.PreviewPanel {
        anchors.top: insert.top
        anchors.bottom: parent.bottom
        anchors.left: insert.right
        anchors.leftMargin: 2
        anchors.right: parent.right
    }
}
