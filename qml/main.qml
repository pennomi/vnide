import QtQuick 2.0
import "panels" as Panels
import "nodes" as Nodes

Rectangle {
    id: app
    width: 800
    height: 600
    color: "black"

    Nodes.NodeList{ id: nodes }

    Grid {
        anchors.fill: parent
        columns: 2
        rows: 2
        spacing: 2

        Panels.FlowchartPanel {
            width: parent.width * .8
            height: parent.height * .8
        }
        Panels.EditPanel {
            width: parent.width * .2
            height: parent.height * .8
        }
        Panels.InsertPanel {
            width: parent.width * .8
            height: parent.height * .2
        }
        Panels.PreviewPanel {
            width: parent.width * .2
            height: parent.height * .2
        }
    }

    Repeater {
        model: nodeList
        delegate: Rectangle {
                Component.onCompleted: {
                    console.log("Model: " + model)
                    if (index == 1) {
                        display.x = 55;
                    }
                    console.log("display.x " + display.x)
                }
                x: display.x
                y: display.y
                width: 120
                height: 20
                color: "blue"

                Text {
                    anchors.fill: parent
                    text: display.id
                    color: "white"
                }

                MouseArea {
                    anchors.fill: parent
                    drag { target: parent }
                    onClicked: {
                        nodeList.insertNode()
                    }
                }
            }
    }

}
