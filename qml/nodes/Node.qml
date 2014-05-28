import QtQuick 2.0

Item {
    id: node
    // Make all children of this actually appear in the editor
    default property alias contents: editor.children
    property alias iconComponent: iconLoader.sourceComponent

    property string color: "red"
    property string nid: display.nid
    property string type: display.type
    property bool editing: false

    signal beganEditing()
    signal endedEditing()

    x: display.x
    y: display.y - node.height/2

    // Hook up to the loader to forward the signals
    onBeganEditing: loader.beganEditing();
    onEndedEditing: loader.endedEditing();


    Loader {
        id: iconLoader
        anchors.fill: parent
    }

    Item {
        id: arrows
        Repeater {
            id: arrowRepeater
            model: display.exitConditions
            delegate: Arrow {
                x1: node.width
                y1: node.height / 2 - weight / 2
                x2: display.nextX - node.x
                y2: display.nextY - node.y
                weight: 10
                onDropped: {
                    nodeList.insertNodeAfterParent(nid, index, source)
                }
            }
        }
    }

    Rectangle {
        id: editor
        anchors.fill: parent
        color: node.color
        visible: editing
        opacity: editing ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation {} }
        Behavior on visible { NumberAnimation {} }

        Image {
            id: closeImage
            source: "icons/close.svg"
            width: 64
            height: 64
            anchors.right: parent.right
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    node.state = "not editing";
                    node.editing = false;
                    node.endedEditing();
                }
            }
        }
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
        // If we've disabled the flickable, this should be as well.
        enabled: flickable.interactive

        onClicked: {
            node.state = "editing";
            node.editing = true;
            node.beganEditing();
        }
        onMouseXChanged: {
            if (node.state == "editing") return;
            // TODO: Don't allow dragging to negative values. OR! Find a way to
            // make the Flickables less sucky
            display.x = node.x;
            display.y = node.y + height/2;
        }
        onMouseYChanged: onMouseXChanged
        drag {
            target: node.state == "editing" ? undefined : node
        }
    }
}
