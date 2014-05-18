import QtQuick 2.0
import "../nodes" as Nodes

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
            delegate: Nodes.Node {}
        }

    }

}
