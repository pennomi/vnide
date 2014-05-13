import QtQuick 2.0

Rectangle {
    property alias title: titleLabel.text

    border {
        width: 2
        color: "black"
    }
    height: parent.height
    width: height

    Text {
        id: titleLabel
        text: "Setting"
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            console.log("Clicked " + title);

        }
    }

}
