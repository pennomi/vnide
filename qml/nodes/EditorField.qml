import QtQuick 2.0
import "../elements" as Elements

Item {
    id: container
    signal edited(string newText)

    property alias title: label.text
    property alias validator: input.validator
    property string text
    property bool multiline: false
    height: childrenRect.height
    width: childrenRect.width

    onTextChanged: {
        input.text = container.text;
        edit.text = container.text;
    }

    Text {
        id: label
        height: 30
        width: 100
    }
    Rectangle {
        anchors.top: label.top
        anchors.left: label.right
        anchors.leftMargin: 10
        height: multiline ? 200 : label.height
        width: 200
        border.color: "black"
        border.width: 1
        clip: true

        TextInput {
            id: input
            anchors.fill: parent
            anchors.margins: 3
            visible: !multiline
            onTextChanged: {
                if (text != container.text) {
                    container.edited(text);
                }
            }
        }

        Elements.FlickableTextEdit {
            id: edit
            anchors.fill: parent
            anchors.margins: 3
            visible: multiline
            onTextChanged: {
                if (text != container.text) {
                    container.edited(text);
                }
            }
        }
    }
}