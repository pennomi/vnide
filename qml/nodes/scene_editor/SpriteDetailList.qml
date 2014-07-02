import QtQuick 2.0
import "../../elements" as Elements

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
    footer: Elements.TextButton {
        text: "Add Sprite"
        width: 120
        height: 30
        backgroundColor: "#99cc99"
        onClicked: { container.model.addSprite() }
    }
}