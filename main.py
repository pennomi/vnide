import sys

# noinspection PyUnresolvedReferences
from OpenGL import GL  # HEADS UP! This is required to not segfault on Ubuntu
# noinspection PyUnresolvedReferences
from PyQt5 import QtCore, QtWidgets, QtQuick
from nodes import Node, SimpleListModel

# Make PyQt stop on a Ctrl-C... it's not a clean shutdown, BTW.
import signal
signal.signal(signal.SIGINT, signal.SIG_DFL)


# Generate the data
nodeList = SimpleListModel([Node(), Node(), Node()])
#nodeList.append(node)

# Show the window
app = QtWidgets.QApplication(sys.argv)
view = QtQuick.QQuickView()
context = view.rootContext()
context.setContextProperty("nodeList", nodeList)
view.setSource(QtCore.QUrl("qml/main.qml"))
view.show()
app.exec()