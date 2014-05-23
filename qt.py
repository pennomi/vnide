# noinspection PyUnresolvedReferences
from PyQt5 import QtCore


class ListModel(QtCore.QAbstractListModel):
    def __init__(self, *args):
        super(ListModel, self).__init__()
        self._items = list(args)

    def __iter__(self):
        for i in self._items:
            yield i

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

    # simpler API than insertRows?
    def append(self, item):
        index = len(self._items)
        self.beginInsertRows(QtCore.QModelIndex(), index, index)
        self._items.append(item)
        self.endInsertRows()
