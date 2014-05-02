import QtQuick 2.0

Rectangle {
    color: "#dddddd"

    Flickable {
        anchors.fill: parent

        // TODO: Calculate the content width and height by
        // iterating over the nodes
        contentWidth: 1000
        contentHeight: 1000

        // Show the nodes on top of the lines
        Repeater {
            id: nodeRepeater
            model: nodes
            delegate: Node {
                x: model.x
                y: model.y
                selected: model.selected
                parentNodeIDs: model.parentNodeIDs
                childNodeIDs: model.childNodeIDs
            }
        }

    }

}
