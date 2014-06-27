import QtQuick 2.0

Rectangle {
    id: container
    property bool showWidescreen: true

    anchors.fill: parent

    // The view area
    Rectangle {
        color: "green"
        anchors {
            left: parent.left
            right: parent.horizontalCenter
        }
        height: 9 / 16 * width  // 16:9 aspect ratio

        Image {
            source: '../../saves/testproj/resources/' + display.backgroundSprite.filename
            anchors.fill: parent
            fillMode: Image.PreserveAspectCrop
        }

        // Cover bars
        Rectangle {
            color: "black"
            anchors.left: parent.left
            width: parent.width / 8
            height: parent.height
            opacity: showWidescreen ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }
        Rectangle {
            color: "black"
            anchors.right: parent.right
            width: parent.width / 8
            height: parent.height
            opacity: showWidescreen ? 0 : 1
            Behavior on opacity { NumberAnimation {} }
        }

        // TODO: this is temporary!
        MouseArea {
            anchors.fill: parent
            onClicked: {
                container.showWidescreen = !showWidescreen
            }
        }
    }
}