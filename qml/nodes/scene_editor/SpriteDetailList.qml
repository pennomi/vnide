import QtQuick 2.0

ListView {
    id: container
    spacing: 10
    model: display.sprites
    header: Rectangle{
        height: childrenRect.height + spacing
        width: container.width
        SpriteDetailEditor {
            width: container.width
            displayData: display.backgroundSprite
        }
    }
    delegate: SpriteDetailEditor {
        width: container.width
        displayData: display
    }
}