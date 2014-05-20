# noinspection PyUnresolvedReferences
from PyQt5 import QtCore
from qt import SimpleListModel


class Node(QtCore.QObject):
    def __init__(self):
        super(Node, self).__init__()
        self._property_data = dict(
            id="12ab52be98c0",
            x=0,
            y=0
        )

    # id
    id_changed = QtCore.pyqtSignal('QString', name='idChanged')

    @QtCore.pyqtProperty('QString', notify=id_changed)
    def id(self):
        return self._property_data["id"]

    @id.setter
    def id(self, value):
        self._property_data["id"] = value
        self.id_changed.emit(value)

    # x
    x_changed = QtCore.pyqtSignal(int, name='xChanged')

    @QtCore.pyqtProperty(int, notify=x_changed)
    def x(self):
        return self._property_data["x"]

    @x.setter
    def x(self, value):
        self._property_data["x"] = value
        self.x_changed.emit(value)

    # y
    y_changed = QtCore.pyqtSignal(int, name='yChanged')

    @QtCore.pyqtProperty(int, notify=y_changed)
    def y(self):
        return self._property_data["y"]

    @y.setter
    def y(self, value):
        self._property_data["y"] = value
        self.y_changed.emit(value)


class NodeList(SimpleListModel):
    @QtCore.pyqtSlot()
    def insertNode(self):
        print("SLOT!")