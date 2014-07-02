import QtQuick 2.0
import "../elements" as Elements
Rectangle {
    color: "#ddddff"

    Elements.TextButton {
        width: 70
        height: 30
        text: "Save"
        onClicked: {
            nodeList.save("saves/testproj/main.flow")
        }
    }
}
