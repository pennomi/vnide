import QtQuick 2.0

Rectangle {
    id: genericNode

    property string nid: display.nid
    property string type: display.type

    signal beganEditing()
    signal endedEditing()

    x: display.x
    y: display.y
    width: 100
    height: 80

    radius: 5
    color: "red"
    border.color: display.selected ? "yellow" : "black"
    border.width: 2
    //scale: display.selected ? 1.2 : 1.0

    // States
    state: "unselected"

    states: [
        State {
            name: "unselected"
            PropertyChanges {
                target: genericNode

                x: display.x
                y: display.y
            }
        },
        State {
            name: "selected"
            PropertyChanges {
                target: genericNode

                x: display.x
                y: display.y
            }
        },
        State {
            name: "editing"
            PropertyChanges {
                target: genericNode
                x: flickable.contentX
                y: flickable.contentY
                width: flickable.width
                height: flickable.height
            }
        }
    ]

    Behavior on x {
        NumberAnimation {}
    }
    Behavior on y {
        NumberAnimation {}
    }
    Behavior on width {
        NumberAnimation {}
    }
    Behavior on height {
        NumberAnimation {}
    }



    Text {
        anchors.centerIn: parent
        text: type
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        // TODO: is selected even necessary? Could be useful for copy/paste.
        // TODO: But how would that work anyway?
        /*onClicked: {
            // TODO: Toggle selected
            console.log("TODO: Toggle `selected`!")
            //nodes.setProperty(nodes.selectedIndex, "selected", false)
            //nodes.setProperty(index, "selected", true)
            //nodes.selectedIndex = index;
        }*/
        onDoubleClicked: {
            if (genericNode.state == "editing") {
                genericNode.state = "unselected";
                genericNode.endedEditing();
            } else {
                genericNode.state = "editing";
                genericNode.beganEditing();
            }
        }
        onMouseXChanged: {
            if (genericNode.state == "editing") return;
            // TODO: Don't allow dragging to negative values. OR! Find a way to
            // make the Flickables less sucky
            display.x = genericNode.x;
            display.y = genericNode.y;
        }
        onMouseYChanged: {
            if (genericNode.state == "editing") return;
            display.x = genericNode.x;
            display.y = genericNode.y;
        }
        drag {
            target: genericNode.state == "editing" ? undefined : genericNode
        }
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
