import QtQuick 2.0

Rectangle {
    width: 100
    height: 80
    radius: 5
    border.color: selected ? "yellow" : "black"
    border.width: 2

    property bool selected: false


    MouseArea {
        anchors.fill: parent
        onClicked: {
            selected = true
            // TODO: notify the app about who's selected.
        }
    }
}
