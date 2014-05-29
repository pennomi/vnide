import QtQuick 2.0

Node {
    id: node
    color: style.white

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

    iconComponent: Rectangle {
        width: 32
        height: width
        radius: width / 2
        color: node.color
        border {
            color: "black"
            width: 2
        }
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
    }
}