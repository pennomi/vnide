import QtQuick 2.0
import "panels" as Panels
import "nodes" as Nodes

Rectangle {
    id: app
    width: 800
    height: 600
    color: "black"

    Panels.FlowchartPanel {
        id: flowchart
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * .8
    }
    Panels.InsertPanel {
        id: insert
        anchors.top: flowchart.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width * .8
    }
    Panels.PreviewPanel {
        anchors.top: flowchart.bottom
        anchors.bottom: parent.bottom
        anchors.left: insert.right
        anchors.right: parent.right
    }
}
