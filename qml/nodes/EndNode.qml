import QtQuick 2.0

Node {
    id: node
    width: 48
    height: width

    // End Nodes have special functionality on a drop
    Drag.active: dragArea.drag.active
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2
    Drag.keys: ["MergeEndNode"]


    Image {
        source: {
            switch(display.dataType) {
                case "stop": return "icons/stop.svg"
                case "return": return "icons/return.svg"
                case "exception": return "icons/bug.svg"
            }
        }
        anchors.fill: parent
        anchors.margins: 5
    }

    editorComponent: Row {
        spacing: 10
        Repeater {
            model: ListModel {
                ListElement { dataType: "stop" }
                ListElement { dataType: "return" }
                ListElement { dataType: "exception" }
            }
            delegate: Rectangle{
                width: 64
                height: width
                border.color: "yellow"
                border.width: display.dataType == model.dataType ? 2 : 0
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: {
                        switch(model.dataType) {
                            case "stop": return "icons/stop.svg"
                            case "return": return "icons/return.svg"
                            case "exception": return "icons/bug.svg"
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        display.dataType = model.dataType
                    }
                }
            }
        }
    }
}