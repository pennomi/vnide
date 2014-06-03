import QtQuick 2.0

Node {
    id: node
    color: "white"
    width: 48
    height: width
    //radius: width / 2

    Image {
        source: "icons/root.svg"
        anchors.fill: parent
        anchors.margins: 5
    }
}