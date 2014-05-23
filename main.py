import sys

# noinspection PyUnresolvedReferences
from OpenGL import GL  # HEADS UP! This is required to not segfault on Ubuntu
# noinspection PyUnresolvedReferences
from PyQt5 import QtCore, QtWidgets, QtQuick
from nodes import Node, NodeList, ExitCondition
from qt import ListModel

# Make PyQt stop on a Ctrl-C... it's not a clean shutdown, BTW.
import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)


# Generate the data
n2 = Node(type="end", x=240, y=30, selected=False, )
n1 = Node(
    type="scene", x=120, y=30, selected=False,
    exitConditions=ListModel(
        ExitCondition(nextNode=n2.nid, condition=None, text=None)
    ))
rootNode = Node(
    type="root", x=0, y=0,
    exitConditions=ListModel(
        ExitCondition(nextNode=n1.nid, condition=None, text=None)
    ))
nodeList = NodeList(rootNode, n1, n2)

# Show the window
# TODO: Handle resize events
app = QtWidgets.QApplication(sys.argv)
view = QtQuick.QQuickView()
context = view.rootContext()
context.setContextProperty("nodeList", nodeList)
view.setSource(QtCore.QUrl("qml/main.qml"))
view.show()
app.exec()