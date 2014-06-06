import QtQuick 2.0

Flickable {
    id: flick
    property alias text: edit.text
    contentWidth: edit.paintedWidth
    contentHeight: edit.paintedHeight
    clip: true

    function ensureVisible(r) {
        if (contentX >= r.x)
            contentX = r.x;
        else if (contentX+width <= r.x+r.width)
            contentX = r.x+r.width-width;
        if (contentY >= r.y)
            contentY = r.y;
        else if (contentY+height <= r.y+r.height)
            contentY = r.y+r.height-height;
    }

    TextEdit {
        id: edit
        width: flick.width
        height: flick.height
        onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
    }
}