import QtQuick 2.0

Rectangle {
    id: genericNode

    property string nid: display.nid

    x: display.x
    y: display.y

    width: 100
    height: 80
    radius: 5
    color: "red"
    border.color: display.selected ? "yellow" : "black"
    border.width: 2
    //scale: display.selected ? 1.2 : 1.0

    Text {
        anchors.centerIn: parent
        text: display.type
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            // TODO: This would cause an error. Refactor!
            //nodes.setProperty(nodes.selectedIndex, "selected", false)
            //nodes.setProperty(index, "selected", true)
            //nodes.selectedIndex = index;
        }
        onMouseXChanged: {
            // TODO: Don't allow dragging to negative values. OR! Find a way to
            // make the Flickables less sucky
            display.x = genericNode.x;
            display.y = genericNode.y;
        }
        onMouseYChanged: {
            display.x = genericNode.x;
            display.y = genericNode.y;
        }
        drag { target: genericNode }
    }

    Behavior on scale {
        NumberAnimation {}
    }

    Repeater {
        id: lineRepeater
        model: display.exitConditions
        delegate: Line {
            parent: genericNode.parent
            x1: genericNode.width
            y1: genericNode.height / 2
            x2: display.nextX - genericNode.x //model.x2 - genericNode.x
            y2: display.nextY - genericNode.y + genericNode.height / 2 //model.y2 - genericNode.y
            color: "black"
            onDropped: {
                nodeList.insertNodeAfterParent(nid, index, source)
            }
        }
    }
}
