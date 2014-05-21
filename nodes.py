# noinspection PyUnresolvedReferences
from PyQt5 import QtCore
from uuid import uuid4
from qt import ListModel


class Node(QtCore.QObject):
    def __init__(self, **kwargs):
        super(Node, self).__init__()
        self._property_data = dict(
            nid=str(uuid4()), x=0, y=0, type="root", selected=False,
            exitConditions=ListModel()
        )
        self._property_data.update(kwargs)

    # nid
    nid_changed = QtCore.pyqtSignal('QString', name='nidChanged')

    @QtCore.pyqtProperty('QString', notify=nid_changed)
    def nid(self):
        return self._property_data["nid"]

    @nid.setter
    def nid(self, value):
        self._property_data["nid"] = value
        self.nid_changed.emit(value)

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

    # type
    type_changed = QtCore.pyqtSignal("QString", name='typeChanged')

    @QtCore.pyqtProperty("QString", notify=type_changed)
    def type(self):
        return self._property_data["type"]

    @type.setter
    def type(self, value):
        self._property_data["type"] = value
        self.type_changed.emit(value)

    # selected
    selected_changed = QtCore.pyqtSignal(bool, name='selectedChanged')

    @QtCore.pyqtProperty(bool, notify=selected_changed)
    def selected(self):
        return self._property_data["selected"]

    @selected.setter
    def selected(self, value):
        self._property_data["selected"] = value
        self.selected_changed.emit(value)

    # exitConditions
    exitConditions_changed = QtCore.pyqtSignal("QVariant",
                                               name='exitConditionsChanged')

    @QtCore.pyqtProperty("QVariant", notify=exitConditions_changed)
    def exitConditions(self):
        return self._property_data["exitConditions"]

    @exitConditions.setter
    def exitConditions(self, value):
        self._property_data["exitConditions"] = value
        self.exitConditions_changed.emit(value)


class ExitCondition(QtCore.QObject):
    def __init__(self, **kwargs):
        super(ExitCondition, self).__init__()
        self._property_data = dict(
            nextNode=None, condititon=None, text=None
        )
        self._property_data.update(kwargs)

    # nextNode
    nextNode_changed = QtCore.pyqtSignal('QString', name='nextNodeChanged')

    @QtCore.pyqtProperty('QString', notify=nextNode_changed)
    def nextNode(self):
        return self._property_data["nextNode"]

    @nextNode.setter
    def nextNode(self, value):
        self._property_data["nextNode"] = value
        self.nextNode_changed.emit(value)

    # condition
    condition_changed = QtCore.pyqtSignal('QString', name='conditionChanged')

    @QtCore.pyqtProperty('QString', notify=condition_changed)
    def condition(self):
        return self._property_data["condition"]

    @condition.setter
    def condition(self, value):
        self._property_data["condition"] = value
        self.condition_changed.emit(value)

    # text
    text_changed = QtCore.pyqtSignal('QString', name='textChanged')

    @QtCore.pyqtProperty('QString', notify=text_changed)
    def text(self):
        return self._property_data["text"]

    @text.setter
    def text(self, value):
        self._property_data["text"] = value
        self.text_changed.emit(value)


class NodeList(ListModel):
    @QtCore.pyqtSlot()
    def insertNode(self):
        print("SLOT!")