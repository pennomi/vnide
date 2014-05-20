import sys

# noinspection PyUnresolvedReferences
from OpenGL import GL  # HEADS UP! This is required to not segfault on Ubuntu
# noinspection PyUnresolvedReferences
from PyQt5 import QtCore, QtWidgets, QtQuick
from nodes import Node, NodeList, ExitCondition

# Make PyQt stop on a Ctrl-C... it's not a clean shutdown, BTW.
import signal
from qt import SimpleListModel

signal.signal(signal.SIGINT, signal.SIG_DFL)


# Generate the data
nodes = [
    Node(type="root", x=0, y=0,),
    Node(type="root", x=5, y=100,),
    Node(type="root", x=0, y=200,
         exitConditions=SimpleListModel(
             [ExitCondition(nextNode="uuid",
                            condition="blah=='bar'",
                            text="Hello World")
              ])),
]
nodeList = NodeList(nodes)

# Show the window
app = QtWidgets.QApplication(sys.argv)
view = QtQuick.QQuickView()
context = view.rootContext()
context.setContextProperty("nodeList", nodeList)
view.setSource(QtCore.QUrl("qml/main.qml"))
view.show()
app.exec()