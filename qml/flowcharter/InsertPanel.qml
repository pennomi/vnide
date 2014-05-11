import QtQuick 2.0

Rectangle {
    color: "#ddffdd"

    Row {
        anchors.verticalCenter: parent.verticalCenter
        height: parent.height * .75

        Rectangle {
            color: "red"
            border {
                width: 2
                color: "black"
            }
            height: parent.height
            width: height

            Text {
                text: "Setting Node"
                anchors.fill: parent
            }

        }
    }

}
