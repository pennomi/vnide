import QtQuick 2.0

Loader {
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

    Component {
        id: rootNode
        RootNode {}
    }

    Component {
        id: endNode
        EndNode {}
    }

    Component {
        id: unknownNode
        Node {}
    }
}