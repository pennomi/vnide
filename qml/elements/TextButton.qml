import QtQuick 2.0

Item {
    id: container
    property alias text: txt.text
    property alias textColor: txt.color
    property color backgroundColor: "transparent"
    property bool active: false

    signal clicked()
     Component.onCompleted: {
         mouse.clicked.connect(clicked)
     }

    Rectangle {
        id: background
        color: mouse.containsMouse ? Qt.lighter(container.backgroundColor, 1.2) : container.backgroundColor
        anchors.fill: parent
    }

    Text {
        id: txt
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
    }
}