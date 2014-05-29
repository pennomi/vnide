import QtQuick 2.0

Node {
    id: node
    color: "#224422"

    iconComponent: Rectangle {
        width: 100
        height: 80
        radius: 2
        color: node.color
        border {
            color: "black"
            width: 2
        }
    }
}