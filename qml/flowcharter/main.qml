import QtQuick 2.0
import "panels" as Panels

Rectangle {
    id: app  // Globally we can use app to access this root element
    width: 800
    height: 600
    color: "black"

    ListModel {
        id: nodes

        property int selectedIndex: 0

        ListElement {
            nid: 314159
            x: 5
            y: 30
            selected: false
            parentNodeIDs: []
            childNodeIDs: [
                ListElement { nid: 9277 }
            ]
        }

        ListElement {
            nid: 9277
            x: 120
            y: 30
            selected: false
            parentNodeIDs: [
                ListElement { nid: 314159 }
            ]
            childNodeIDs: []
        }
    }

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

}
