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
                    if (index == 1) {
                        display.x = 55;
                    }
                }
                x: display.x
                y: display.y
                width: 300
                height: 30 + listy.count * 30
                color: "blue"

                ListView {
                    y: 30
                    id: listy
                    anchors.fill: parent
                    model: display.exitConditions
                    delegate: Text {
                        height: 30
                        width: 100
                        text: display.text
                    }
                }

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
