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

        text: '/*
 * do some true jQuery magic on load
 */
$(document).ready(function() {
    function showHiddenParagraphs() {
        $("p.hidden").fadeIn(500);
    }
    foo.length + console.log(showHiddenParagraphs, 1000);
});'
    }
}