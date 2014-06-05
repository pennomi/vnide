import QtQuick 2.0
import "../elements" as Elements

Node {
    id: node
    width: 100
    height: 80

    Elements.SyntaxHighlighter {
        anchors.fill: parent
        anchors.margins: 3
        anchors.leftMargin: 12
    }
}