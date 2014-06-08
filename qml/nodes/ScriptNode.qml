import QtQuick 2.0
import "../elements" as Elements

Node {
    id: node
    width: 110
    height: 80
    icon: "icons/script.svg"
    title: "Script"
    tint: "orange"

    Elements.SyntaxHighlighter {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 12
        text: display.text
    }

    editorComponent: EditorField {
        title: "Script"
        text: display.text
        multiline: true
        onEdited: { display.text = newText; }
    }
}