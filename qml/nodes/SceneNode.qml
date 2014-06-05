import QtQuick 2.0

Node {
    id: node
    width: 100
    height: 80

    Image {
        anchors.fill: parent
        source: "../../saves/testproj/resources/Tavern1600x1200_0.png"
        fillMode: Image.PreserveAspectCrop
    }
}