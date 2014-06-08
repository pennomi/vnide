import QtQuick 2.0

Node {
    id: node
    width: 110
    height: 80
    icon: "icons/dialog.svg"
    title: "Dialog"
    tint: "white"


    Text {
        anchors {
            fill: parent
            margins: 5
            leftMargin: 24
        }
        text: display.text
        font.pointSize: 10
        wrapMode: Text.WordWrap
    }

    Image {
        anchors.horizontalCenter: parent.left
        anchors.verticalCenter: parent.bottom
        height: 32
        width: 32
        smooth: true
        z: 2
        source: display.filename ? "../../saves/testproj/resources/" + display.filename : ""
    }

    editorComponent: Rectangle {
        anchors.fill: parent

        // TODO: Make this a file open dialog
        EditorField {
            id: speaker
            title: "Speaker"
            text: display.filename
            onEdited: { display.filename = newText; }
        }

        EditorField {
            anchors.top: speaker.bottom
            anchors.topMargin: 5
            title: "Text"
            text: display.text
            multiline: true
            onEdited: { display.text = newText; }
        }
    }
}