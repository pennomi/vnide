import QtQuick 2.0
import "../elements" as Elements

Node {
    id: node
    width: 110
    height: 80
    z: 9000

    Elements.SyntaxHighlighter {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 12

        text: display.text
    }
}