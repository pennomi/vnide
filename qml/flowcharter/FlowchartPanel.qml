import QtQuick 2.0

Rectangle {
    color: "#dddddd"

    Flickable {
        anchors.fill: parent

        // TODO: Calculate the content width and height by
        // iterating over the nodes
        contentWidth: 1000
        contentHeight: 1000

        Node {
            x: 5
            y: 30
        }

    }

}
