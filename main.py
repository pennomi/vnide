import sys

# noinspection PyUnresolvedReferences
from OpenGL import GL  # HEADS UP! This is required to not segfault on Ubuntu
# noinspection PyUnresolvedReferences
from PyQt5 import QtCore, QtWidgets, QtQuick

app = QtWidgets.QApplication(sys.argv)

view = QtQuick.QQuickView()
view.setSource(QtCore.QUrl("qml/main.qml"))
view.show()

app.exec()