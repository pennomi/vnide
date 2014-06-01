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
                color: style.green
                title: "scene"
            }

            InsertButton {
                color: style.white
                title: "dialog"
            }

            InsertButton {
                color: style.blue
                title: "choice"
            }

            InsertButton {
                color: style.green
                title: "router"
            }

            InsertButton {
                color: style.red
                title: "script"
            }

            InsertButton {
                color: style.red
                title: "macro"
            }
        }
    }
}
