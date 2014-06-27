import QtQuick 2.0

Rectangle {
    color: "#ddffdd"

    Flickable {
        anchors.fill: parent
        contentWidth: buttonRow.width + height * .25
        contentHeight: height

        Row {
            id: buttonRow
            anchors.verticalCenter: parent.verticalCenter
            x: 5
            height: 40
            spacing: 5

            InsertButton {
                color: globalStyle.green
                title: "scene"
            }

            InsertButton {
                color: globalStyle.white
                title: "dialog"
            }

            InsertButton {
                color: globalStyle.blue
                title: "choice"
            }

            InsertButton {
                color: globalStyle.green
                title: "router"
            }

            InsertButton {
                color: globalStyle.red
                title: "script"
            }

            InsertButton {
                color: globalStyle.red
                title: "macro"
            }
        }
    }
}
