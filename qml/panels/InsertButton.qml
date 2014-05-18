import QtQuick 2.0

Rectangle {
    id: nodeButton
    property alias title: titleLabel.text
    property variant defaultLocation

    Component.onCompleted: defaultLocation = [x, y];  // Avoid the property binding; this never changes.

    border {
        width: 2
        color: "black"
    }
    height: parent.height
    width: height

    Text {
        id: titleLabel
        text: "Setting"
        anchors.fill: parent
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        onPressed: {
            nodeButton.opacity = 0.5

        }

        onReleased: {
            parent.Drag.drop()
            nodeButton.opacity = 1.0
            nodeButton.x = defaultLocation[0]
            nodeButton.y = defaultLocation[1]
            // TODO: Insert this thing there. Should probably be handled on the line object instead.
            //nodes.insertType(title)
        }
        drag { target: parent }
    }

    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

}
