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

        # connect the appropriate signals
        self.x_changed.connect(self.emit_moved)
        self.y_changed.connect(self.emit_moved)

    moved = QtCore.pyqtSignal("QString", name='moved')

    def emit_moved(self):
        self.moved.emit(self.nid)

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
            nextNode=None, condititon=None, text=None, nextX=0, nextY=0,
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

    # nextX
    nextX_changed = QtCore.pyqtSignal(int, name='nextXChanged')

    @QtCore.pyqtProperty(int, notify=nextX_changed)
    def nextX(self):
        return self._property_data["nextX"]

    @nextX.setter
    def nextX(self, value):
        self._property_data["nextX"] = value
        self.nextX_changed.emit(value)

    # nextY
    nextY_changed = QtCore.pyqtSignal(int, name='nextYChanged')

    @QtCore.pyqtProperty(int, notify=nextY_changed)
    def nextY(self):
        return self._property_data["nextY"]

    @nextY.setter
    def nextY(self, value):
        self._property_data["nextY"] = value
        self.nextY_changed.emit(value)


class NodeList(ListModel):
    # noinspection PyProtectedMember
    def __init__(self, *args):
        super(NodeList, self).__init__(*args)
        for node in args:
            node.moved.connect(self.nodeMovedHandler)
            self.nodeMovedHandler(node.nid)

    def append(self, item):
        super(NodeList, self).append(item)
        item.moved.connect(self.nodeMovedHandler)

    node_moved = QtCore.pyqtSignal('QString', name='nodeMoved')

    def nodeMovedHandler(self, nid):
        movingNode = self.get_by_nid(nid)
        for node in self:
            for condition in node.exitConditions:
                if condition.nextNode == nid:
                    # calculate nextX & nextY for the condition
                    condition.nextX = movingNode.x
                    condition.nextY = movingNode.y
        self.node_moved.emit(nid)

    def get_by_nid(self, nid):
        # TODO: Wouldn't this be cooler as a dict access?
        # TODO: And if you put in an int it's a list access?
        for node in self._items:
            if node.nid == nid:
                return node

    @QtCore.pyqtSlot('QString', int, 'QVariant')
    def insertNodeAfterParent(self, nid, conditionIndex, dropData):
        # TODO: one arg is the dropped thingy? (to get x, y, etc.)
        # TODO: one arg should be condition index
        print("Insert Node: {}:{} with data {} ({})".format(
            nid, conditionIndex, dropData, dropData.property('title')))
        # Fetch the parent
        parent = self.get_by_nid(nid)
        exitPoint = parent.exitConditions._items[conditionIndex]
        # Generate the new node
        new = Node(
            type=dropData.property('title'),
            x=parent.x + 150, y=parent.y, selected=False,
            exitConditions=ListModel(
                ExitCondition(nextNode=exitPoint.nextNode,
                              # these may be populated for some node types
                              condition=None, text=None),
            ))
        self.append(new)

        # Update the parent to have this as a child instead
        exitPoint.nextNode = new.nid

        # Send off any necessary signals
        self.nodeMovedHandler(exitPoint.nextNode)

        for condition in new.exitConditions:
            # calculate nextX & nextY for the condition
            child = self.get_by_nid(condition.nextNode)
            condition.nextX = child.x
            condition.nextY = child.y
