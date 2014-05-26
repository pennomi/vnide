import QtQuick 2.0

Item {
    id: node
    // Make all children of this actually appear in the editor
    default property alias contents: editor.children

    property string color: "red"
    property string nid: display.nid
    property string type: display.type
    property bool editing: false

    signal beganEditing()
    signal endedEditing()

    x: display.x
    y: display.y
    width: 100
    height: 80

    // Hook up to the loader to forward the signals
    onBeganEditing: loader.beganEditing();
    onEndedEditing: loader.endedEditing();


    Rectangle {
        id: icon
        radius: 5
        color: node.color
        border.color: display.selected ? "yellow" : "black"
        border.width: 2
        anchors.fill: parent
        opacity: editing ? 0.0 : 1.0
        Behavior on opacity { NumberAnimation {} }

        Text {
            anchors.centerIn: parent
            text: type
        }

        /*BorderImage {
            anchors.fill: parent
            border { left: 30; top: 30; right: 30; bottom: 30 }
            horizontalTileMode: BorderImage.Stretch
            verticalTileMode: BorderImage.Stretch
            source: "border.png"
        }*/
    }

    Rectangle {
        id: editor
        anchors.fill: parent
        color: node.color
        opacity: editing ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation {} }
    }

    Item {
        id: lines
        Repeater {
            id: lineRepeater
            model: display.exitConditions
            delegate: Line {
                parent: node.parent
                x1: node.width
                y1: node.height / 2
                x2: display.nextX - node.x //model.x2 - node.x
                y2: display.nextY - node.y + node.height / 2 //model.y2 - node.y
                onDropped: {
                    nodeList.insertNodeAfterParent(nid, index, source)
                }
            }
        }
        opacity: editing ? 0.0 : 1.0
        Behavior on opacity { NumberAnimation {} }
    }

    // States and size animations
    states: [
        State {
            name: "editing"
            when: editing
            PropertyChanges {
                target: node
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

    // Mouse Actions
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onDoubleClicked: {
            if (node.state == "editing") {
                node.state = "not editing";
                node.editing = false;
                node.endedEditing();
            } else {
                node.state = "editing";
                node.editing = true;
                node.beganEditing();
            }
        }
        onMouseXChanged: {
            if (node.state == "editing") return;
            // TODO: Don't allow dragging to negative values. OR! Find a way to
            // make the Flickables less sucky
            display.x = node.x;
            display.y = node.y;
        }
        onMouseYChanged: {
            if (node.state == "editing") return;
            display.x = node.x;
            display.y = node.y;
        }
        drag {
            target: node.state == "editing" ? undefined : node
        }
    }
}
