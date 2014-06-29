import QtQuick 2.0

Rectangle {
    property alias model: repeater.model
    height: childrenRect.height
    width: childrenRect.width
    radius: 4
    clip: true

    signal selected(string label)

    Row {
        Repeater {
            id: repeater
            TextButton {
                id: startButton
                width: 110
                height: 30
                text: modelData
                active: index == 0
                backgroundColor: active ? "#99cc99" : "#cc9999"
                onClicked: {
                    for (var i=0; i<repeater.count; i++) {
                        repeater.itemAt(i).active = false;
                    }
                    active = true;
                    // Send off signal
                    selected(modelData);
                }
            }
        }
    }
}