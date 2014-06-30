import QtQuick 2.0
import '..' as Stuff
import '../../elements' as Elements

Rectangle {
    color: "light gray"
    height: childrenRect.height

    Elements.ImageButton {
        source: '../icons/delete.svg'
        width: 30
        height: 30
        anchors.right: parent.right
        onClicked: {
            console.log("delete");
        }
    }

    Column {
        Stuff.EditorField {
            title: "Filename"
            text: display.filename
            onEdited: { display.filename = newText; }
        }

        Stuff.EditorField {
            id: startXField
            title: "Start X"
            text: display.startX
            validator: DoubleValidator {}
            onEdited: { display.startX = parseFloat(newText); }
        }

        Stuff.EditorField {
            title: "Start Y"
            text: display.startY
            validator: DoubleValidator {}
            onEdited: { display.startY = parseFloat(newText); }
        }

        Stuff.EditorField {
            title: "End X"
            text: display.endX
            validator: DoubleValidator {}
            onEdited: { display.endX = parseFloat(newText); }
        }

        Stuff.EditorField {
            title: "End Y"
            text: display.endY
            validator: DoubleValidator {}
            onEdited: { display.endY = parseFloat(newText); }
        }
    }
}