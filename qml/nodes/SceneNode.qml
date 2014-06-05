import QtQuick 2.0

Node {
    id: node
    width: 110
    height: 80

    // TODO: This should be wrapped in the Node Border or have a different
    //       border altogether.
    Image {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 12
        source: "../../saves/testproj/resources/Tavern1600x1200_0.png"
        fillMode: Image.PreserveAspectCrop
    }
}