import QtQuick 2.0

ListView {
    id: container
    spacing: 10
    model: display.sprites
    delegate: SpriteDetailEditor{
        width: container.width
    }
}