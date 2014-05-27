import QtQuick 2.0

Node {
    id: node
    color: "white"
    width: 32
    height: width

    Text {
        id: titleText
        text: "Pick a style!"
    }
    Row {
        anchors.top: titleText.bottom
        anchors.topMargin: 32
        spacing: 10
        Repeater {
            model: ListModel {
                ListElement { endNodeType: "stop" }
                ListElement { endNodeType: "return" }
                ListElement { endNodeType: "exception" }
            }
            delegate: Rectangle{
                width: 64
                height: width
                border.color: "yellow"
                border.width: display.endNodeType == model.endNodeType ? 2 : 0
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: {
                        switch(model.endNodeType) {
                            case "stop": return "stop.svg"
                            case "return": return "return.svg"
                            case "exception": return "bug.svg"
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        display.endNodeType = model.endNodeType
                    }
                }
            }
        }
    }

    iconComponent: Rectangle {
        radius: node.width / 2
        color: node.color
        border {
            color: "black"
            width: 2
        }
        Image {
            source: {
                switch(display.endNodeType) {
                    case "stop": return "stop.svg"
                    case "return": return "return.svg"
                    case "exception": return "bug.svg"
                }
            }
            anchors.fill: parent
            anchors.margins: 5
        }
    }
}