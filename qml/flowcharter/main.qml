import QtQuick 2.0

Rectangle {
    id: app  // Globally we can use app to access this root element
    width: 800
    height: 600
    color: "black"

    Grid {
        anchors.fill: parent
        columns: 2
        rows: 2
        spacing: 2

        FlowchartPanel {
            width: parent.width * .8
            height: parent.height * .8
        }
        EditPanel {
            width: parent.width * .2
            height: parent.height * .8
        }
        InsertPanel {
            width: parent.width * .8
            height: parent.height * .2
        }
        PreviewPanel {
            width: parent.width * .2
            height: parent.height * .2
        }
    }

}
