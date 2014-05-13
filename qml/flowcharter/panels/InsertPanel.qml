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
            x: parent.height * .125
            height: parent.height * .75
            spacing: parent.height * .125

            InsertButton {
                color: "red"
                title: "Setting"
            }

            InsertButton {
                color: "green"
                title: "Dialog"
            }

            InsertButton {
                color: "blue"
                title: "Choice"
            }

            InsertButton {
                color: "white"
                title: "Script"
            }

            InsertButton {
                color: "gray"
                title: "Scripted Choice"
            }

            InsertButton {
                color: "yellow"
                title: "Macro"
            }
        }
    }
}
