import QtQuick 2.0
import '..' as Stuff
import '../../elements' as Elements

Rectangle {
    color: "light gray"
    height: childrenRect.height
    property variant displayData

    Elements.ImageButton {
        source: '../icons/delete.svg'
        width: 30
        height: 30
        anchors.right: parent.right
        onClicked: {
            console.log("delete");
            container.model.pop(index)
        }
    }

    Column {
        Stuff.EditorField {
            title: "Filename"
            text: displayData.filename
            onEdited: { displayData.filename = newText; }
        }

        Stuff.EditorField {
            id: startXField
            title: "Start X"
            text: displayData.startX
            validator: DoubleValidator {}
            onEdited: { displayData.startX = parseFloat(newText); }
        }

        Stuff.EditorField {
            title: "Start Y"
            text: displayData.startY
            validator: DoubleValidator {}
            onEdited: { displayData.startY = parseFloat(newText); }
        }

        Stuff.EditorField {
            title: "End X"
            text: displayData.endX
            validator: DoubleValidator {}
            onEdited: { displayData.endX = parseFloat(newText); }
        }

        Stuff.EditorField {
            title: "End Y"
            text: displayData.endY
            validator: DoubleValidator {}
            onEdited: { displayData.endY = parseFloat(newText); }
        }
    }
}