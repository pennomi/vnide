import QtQuick 2.0

Item {
    id: container
    property alias source: img.source

    signal clicked()
    Component.onCompleted: {
        mouse.clicked.connect(clicked)
    }

    Image {
        id: img
        anchors.fill: parent
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
    }
}