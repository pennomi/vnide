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
                color: "red"
                title: "setting"
            }

            InsertButton {
                color: "green"
                title: "dialog"
            }

            InsertButton {
                color: "blue"
                title: "choice"
            }

            InsertButton {
                color: "white"
                title: "script"
            }

            InsertButton {
                color: "gray"
                title: "scripted choice"
            }

            InsertButton {
                color: "yellow"
                title: "macro"
            }
        }
    }
}
