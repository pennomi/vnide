import QtQuick 2.0

Loader {
    id: loader

    sourceComponent: {
        var types = {
            root: rootNode,
            scene: sceneNode,
            dialog: dialogNode,
            script: scriptNode,
            choice: choiceNode,
            router: routerNode,
            macro: macroNode,
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
    Component { id: sceneNode; SceneNode {} }
    Component { id: dialogNode; DialogNode {} }
    Component { id: scriptNode; ScriptNode {} }
    Component { id: choiceNode; ChoiceNode {} }
    Component { id: routerNode; RouterNode {} }
    Component { id: macroNode; MacroNode {} }
    Component { id: endNode; EndNode {} }
    Component { id: unknownNode; UnknownNode {} }
}