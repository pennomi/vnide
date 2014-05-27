import QtQuick 2.0

Node {
    id: node
    color: "#22ff22"
    width: 100
    height: 80

    iconComponent: Rectangle {
        radius: 5
        color: node.color
        border {
            color: "black"
            width: 2
        }
    }
}