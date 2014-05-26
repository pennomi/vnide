import QtQuick 2.0

Loader {
    id: loader
    signal beganEditing()
    signal endedEditing()

    sourceComponent: {
        var types = {
            root: rootNode,
            end: endNode,
        }
        if (display.type in types) {
            return types[display.type];
        } else {
            return unknownNode;
        }
    }

    // Each node type gets defined here.
    Component { id: rootNode; RootNode {} }
    Component { id: endNode; EndNode {} }
    Component { id: scriptNode; ScriptNode {} }
    Component { id: unknownNode; Node {} }
}