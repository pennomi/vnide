import json
import sys

# noinspection PyUnresolvedReferences
from OpenGL import GL  # HEADS UP! This is required to not segfault on Ubuntu
# noinspection PyUnresolvedReferences
from PyQt5 import QtCore, QtWidgets, QtQuick
from nodes import Node, NodeList

# Make PyQt stop on a Ctrl-C... it's not a clean shutdown, BTW.
import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)


SAVE_LOCATION = "saves/testproj/main.flow"


def saveOnQuit():
    print("INFO: Auto-saving on exit")
    nodeList.save(SAVE_LOCATION)


# Load the data
with open(SAVE_LOCATION, "r") as infile:
    node_data = json.load(infile)
nodes = [Node(**n) for n in node_data["nodes"]]
nodeList = NodeList(*nodes)

# Show the window
# TODO: Handle resize events
app = QtWidgets.QApplication(sys.argv)
app.aboutToQuit.connect(saveOnQuit)
view = QtQuick.QQuickView()
view.setResizeMode(QtQuick.QQuickView.SizeRootObjectToView)
context = view.rootContext()
context.setContextProperty("nodeList", nodeList)
view.setSource(QtCore.QUrl("qml/main.qml"))
view.show()
app.exec()