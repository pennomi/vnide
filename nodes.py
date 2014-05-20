# noinspection PyUnresolvedReferences
from PyQt5 import QtCore


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


class SimpleListModel(QtCore.QAbstractListModel):
    def __init__(self, initial_list):
        super(SimpleListModel, self).__init__()
        self._items = initial_list

    data_changed = QtCore.pyqtSignal(
        QtCore.QModelIndex, QtCore.QModelIndex, name='dataChanged')

    def rowCount(self, parent=QtCore.QModelIndex()):
        return len(self._items)

    def data(self, index, role=QtCore.Qt.DisplayRole):
        return self._items[index.row()]

    def setData(self, index, value, role=QtCore.Qt.EditRole):
        print("set data ", index, value, role)
        if role == QtCore.Qt.EditRole:
            self._items[index.row()] = value
            self.data_changed.emit(index, index)
            return True
        # unhandled change.
        return False

    def flags(self, index):
        return (QtCore.Qt.ItemIsSelectable |
                QtCore.Qt.ItemIsEditable |
                QtCore.Qt.ItemIsEnabled)

    def removeRows(self, row, count, parent=QtCore.QModelIndex()):
        if row < 0 or row > len(self._items):
            return
        self.beginRemoveRows(parent, row, row + count - 1)
        while count != 0:
            del self._items[row]
            count -= 1
        self.endRemoveRows()

    # simpler API than insertRows
    def append(self, item):
        index = len(self._items)
        self.beginInsertRows(QtCore.QModelIndex(), index, index)
        self._items.append(item)
        self.endInsertRows()

    @QtCore.pyqtSlot()
    def insertNode(self):
        print("SLOT!")
