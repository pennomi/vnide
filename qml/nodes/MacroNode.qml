import QtQuick 2.0

Node {
    id: node
    color: "#22ff22"

    Rectangle {
        width: 100
        height: 80
        radius: 5
        color: node.color
        border {
            color: "black"
            width: 2
        }
    }
}