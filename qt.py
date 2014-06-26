# noinspection PyUnresolvedReferences
from PyQt5 import QtCore


class QProperty:
    def __init__(self, property_type):
        self.t = property_type


class MagicQObject(QtCore.pyqtWrapperType):
    def __new__(cls, classname, baseclasses, attrs):
        attrs['_qt_property_data'] = {}
        for name, thing in list(attrs.items()):
            # only accept "Prop" objects
            if not isinstance(thing, QProperty):
                continue

            # initialize the data in a type-specific way
            if thing.t == int:
                attrs['_qt_property_data'][name] = 0
            elif thing.t == 'QString':
                attrs['_qt_property_data'][name] = ""
            elif thing.t == bool:
                attrs['_qt_property_data'][name] = False
            else:
                attrs['_qt_property_data'][name] = None

            changeSignal = QtCore.pyqtSignal(thing.t, name=name + 'Changed')

            def make_getter(n):
                def getter(self):
                    return self._qt_property_data[n]
                getter.__name__ = n
                return getter

            def make_setter(n):
                def setter(self, value):
                    self._qt_property_data[n] = value
                    getattr(self, n + 'Changed').emit(value)
                setter.__name__ = n
                return setter

            new_property = QtCore.pyqtProperty(
                thing.t, notify=changeSignal,
                fget=make_getter(name), fset=make_setter(name)
            )

            # Apply it to the class
            attrs[name + 'Changed'] = changeSignal
            attrs[name] = new_property

        # Let PyQt run its magic on the class
        return super().__new__(cls, classname, baseclasses, attrs)

    def __call__(self, *args, **kwargs):
        # Make sure the default property data is unique per instance
        instance = super().__call__(*args, **kwargs)
        instance._qt_property_data = instance._qt_property_data.copy()
        return instance


class QObjectModel(QtCore.QObject, metaclass=MagicQObject):
    """A very simple implementation of the MagicQObject metaclass."""
    def __init__(self, **kwargs):
        super().__init__()
        self._qt_property_data.update(kwargs)


class ListModel(QtCore.QAbstractListModel):
    def __init__(self, *args):
        super(ListModel, self).__init__()
        self._items = list(args)

    def __iter__(self):
        for i in self._items:
            yield i

    def __len__(self):
        return len(self._items)

    def __getitem__(self, index):
        return self._items[index]

    def __setitem__(self, index, value):
        self._items[index] = value

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
