import signal
import sys

# noinspection PyUnresolvedReferences
from OpenGL import GL  # HEADS UP! This is required to not segfault on Ubuntu
# noinspection PyUnresolvedReferences
from PyQt5 import QtCore, QtWidgets, QtQuick
from nodes import QMLObject, QMLProperty

# Make PyQt stop on a Ctrl-C... it's not a clean shutdown, BTW.
signal.signal(signal.SIGINT, signal.SIG_DFL)


class Node(QMLObject):
    nid = QMLProperty(int, 3)


app = QtWidgets.QApplication(sys.argv)

node = Node()
print(node.nid)

view = QtQuick.QQuickView()
context = view.rootContext()
context.setContextProperty("node", node)
view.setSource(QtCore.QUrl("qml/main.qml"))
view.show()

app.exec()