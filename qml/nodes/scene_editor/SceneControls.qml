import QtQuick 2.0
import "../../elements" as Elements

Column {
    property variant viewport

    spacing: 10

    Elements.TextButtonArray {
        model: ["Start", "Animate", "End"]
        onSelected: {
            if (label == "Start") {
                viewport.showStart()
            } else if (label == "Animate") {
                viewport.startAnimating()
            } else if (label == "End") {
                viewport.showEnd()
            }
        }
    }
    Elements.TextButtonArray {
        model: ["Widescreen On", "Widescreen Off"]
        onSelected: {
            if (label == "Widescreen On") {
                viewport.showWidescreen = true;
            } else if (label == "Widescreen Off") {
                viewport.showWidescreen = false;
            }
        }
    }
    Elements.TextButtonArray {
        model: ["Guides On", "Guides Off"]
    }
}