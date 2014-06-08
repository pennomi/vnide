import QtQuick 2.0

Node {
    id: node
    width: 48
    height: width
    icon: "icons/root.svg"
    title: "Root"
    tint: "yellow"

    Image {
        source: "icons/root.svg"
        anchors.fill: parent
        anchors.margins: 5
    }
}