import sys

from PyQt5.QtCore import QUrl
from PyQt5.QtWidgets import QApplication
from PyQt5.QtQuick import QQuickView

app = QApplication(sys.argv)

view = QQuickView()
view.setSource(QUrl("qml/main.qml"))
view.show()

app.exec()