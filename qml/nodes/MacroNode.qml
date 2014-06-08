import QtQuick 2.0

Node {
    id: node
    width: 100
    height: 60
    icon: "icons/macro.svg"
    title: "Macro"
    tint: "blue"

    Item {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 20

        Text {
            anchors.fill: parent
            text: display.filename
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
            font.italic: true
        }
    }

    editorComponent: EditorField {
        // TODO: Make this a file open dialog
        title: "Filename"
        text: display.filename
        onEdited: { display.filename = newText; }
    }
}