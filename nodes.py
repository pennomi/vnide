# noinspection PyUnresolvedReferences
from PyQt5 import QtCore
from uuid import uuid4
from qt import ListModel, QObjectModel, Prop


class Node(QtCore.QObject):
    def __init__(self, **kwargs):
        super(Node, self).__init__()

        # make exitConditions a ListModel if it's not already
        exits = kwargs.get("exitConditions", ListModel())
        if not isinstance(exits, ListModel):
            exits = [ExitCondition(**e) for e in exits]
            exits = ListModel(*exits)
        kwargs["exitConditions"] = exits

        # make sprites a ListModel if it's not already
        sprites = kwargs.get("sprites", ListModel())
        if not isinstance(sprites, ListModel):
            sprites = [SpritePosition(**s) for s in sprites]
            sprites = ListModel(*sprites)
        kwargs["sprites"] = sprites

        # Create defaults and override them with our specified data
        self._qt_property_data = dict(
            nid=str(uuid4()), x=0, y=0, selected=False,
            exitConditions=ListModel(),
            text="", filename="",
            type="",
            dataType="",
        )
        self._qt_property_data.update(kwargs)
        assert self._qt_property_data['type'] != "", "Specify a node type!"

        # connect the appropriate signals
        self.x_changed.connect(lambda i: self.moved.emit(self.nid))
        self.y_changed.connect(lambda i: self.moved.emit(self.nid))

    moved = QtCore.pyqtSignal("QString", name='moved')

    def hasChildNid(self, nid):
        for c in self.exitConditions:
            if c.nextNode == nid:
                return True
        return False

    # nid
    nid_changed = QtCore.pyqtSignal('QString', name='nidChanged')

    @QtCore.pyqtProperty('QString', notify=nid_changed)
    def nid(self):
        return self._qt_property_data["nid"]

    @nid.setter
    def nid(self, value):
        self._qt_property_data["nid"] = value
        self.nid_changed.emit(value)

    # x
    x_changed = QtCore.pyqtSignal(int, name='xChanged')

    @QtCore.pyqtProperty(int, notify=x_changed)
    def x(self):
        return self._qt_property_data["x"]

    @x.setter
    def x(self, value):
        self._qt_property_data["x"] = value
        self.x_changed.emit(value)

    # y
    y_changed = QtCore.pyqtSignal(int, name='yChanged')

    @QtCore.pyqtProperty(int, notify=y_changed)
    def y(self):
        return self._qt_property_data["y"]

    @y.setter
    def y(self, value):
        self._qt_property_data["y"] = value
        self.y_changed.emit(value)

    # type
    type_changed = QtCore.pyqtSignal("QString", name='typeChanged')

    @QtCore.pyqtProperty("QString", notify=type_changed)
    def type(self):
        return self._qt_property_data["type"]

    @type.setter
    def type(self, value):
        self._qt_property_data["type"] = value
        self.type_changed.emit(value)

    # selected
    selected_changed = QtCore.pyqtSignal(bool, name='selectedChanged')

    @QtCore.pyqtProperty(bool, notify=selected_changed)
    def selected(self):
        return self._qt_property_data["selected"]

    @selected.setter
    def selected(self, value):
        self._qt_property_data["selected"] = value
        self.selected_changed.emit(value)

    # exitConditions
    exitConditions_changed = QtCore.pyqtSignal("QVariant",
                                               name='exitConditionsChanged')

    @QtCore.pyqtProperty("QVariant", notify=exitConditions_changed)
    def exitConditions(self):
        return self._qt_property_data["exitConditions"]

    @exitConditions.setter
    def exitConditions(self, value):
        self._qt_property_data["exitConditions"] = value
        self.exitConditions_changed.emit(value)

    # sprites
    sprites_changed = QtCore.pyqtSignal("QVariant", name='spritesChanged')

    @QtCore.pyqtProperty("QVariant", notify=sprites_changed)
    def sprites(self):
        return self._qt_property_data["sprites"]

    @sprites.setter
    def sprites(self, value):
        self._qt_property_data["sprites"] = value
        self.sprites_changed.emit(value)

    # dataType
    dataType_changed = QtCore.pyqtSignal("QString", name='dataTypeChanged')

    @QtCore.pyqtProperty("QString", notify=dataType_changed)
    def dataType(self):
        return self._qt_property_data["dataType"]

    @dataType.setter
    def dataType(self, value):
        self._qt_property_data["dataType"] = value
        self.dataType_changed.emit(value)

    # text
    text_changed = QtCore.pyqtSignal("QString", name='textChanged')

    @QtCore.pyqtProperty("QString", notify=text_changed)
    def text(self):
        return self._qt_property_data["text"]

    @text.setter
    def text(self, value):
        self._qt_property_data["text"] = value
        self.text_changed.emit(value)

    # filename
    filename_changed = QtCore.pyqtSignal("QString", name='filenameChanged')

    @QtCore.pyqtProperty("QString", notify=filename_changed)
    def filename(self):
        return self._qt_property_data["filename"]

    @filename.setter
    def filename(self, value):
        self._qt_property_data["filename"] = value
        self.filename_changed.emit(value)


class ExitCondition(QObjectModel):
    condition = Prop('QString')
    nextNode = Prop('QString')
    text = Prop('QString')
    nextX = Prop(int)
    nextY = Prop(int)


class SpritePosition(QtCore.QObject):
    def __init__(self, **kwargs):
        super(SpritePosition, self).__init__()
        self._qt_property_data = dict(
            startX=0, startY=0, endX=0, endY=0, filename="",
        )
        self._qt_property_data.update(kwargs)

    # startX
    startX_changed = QtCore.pyqtSignal(int, name='startXChanged')

    @QtCore.pyqtProperty(int, notify=startX_changed)
    def startX(self):
        return self._qt_property_data["startX"]

    @startX.setter
    def startX(self, value):
        self._qt_property_data["startX"] = value
        self.startX_changed.emit(value)

    # startY
    startY_changed = QtCore.pyqtSignal(int, name='startYChanged')

    @QtCore.pyqtProperty(int, notify=startY_changed)
    def startY(self):
        return self._qt_property_data["startY"]

    @startY.setter
    def startY(self, value):
        self._qt_property_data["startY"] = value
        self.startY_changed.emit(value)

    # endX
    endX_changed = QtCore.pyqtSignal(int, name='endXChanged')

    @QtCore.pyqtProperty(int, notify=endX_changed)
    def endX(self):
        return self._qt_property_data["endX"]

    @endX.setter
    def endX(self, value):
        self._qt_property_data["endX"] = value
        self.endX_changed.emit(value)

    # endY
    endY_changed = QtCore.pyqtSignal(int, name='endYChanged')

    @QtCore.pyqtProperty(int, notify=endY_changed)
    def endY(self):
        return self._qt_property_data["endY"]

    @endY.setter
    def endY(self, value):
        self._qt_property_data["endY"] = value
        self.endY_changed.emit(value)

    # filename
    filename_changed = QtCore.pyqtSignal('QString', name='filenameChanged')

    @QtCore.pyqtProperty('QString', notify=filename_changed)
    def filename(self):
        return self._qt_property_data["filename"]

    @filename.setter
    def filename(self, value):
        self._qt_property_data["filename"] = value
        self.filename_changed.emit(value)


class NodeList(ListModel):
    # noinspection PyProtectedMember
    def __init__(self, *args):
        super(NodeList, self).__init__(*args)
        for node in args:
            node.moved.connect(self.nodeMovedHandler)
            self.nodeMovedHandler(node.nid)

    def append(self, node):
        super(NodeList, self).append(node)
        node.moved.connect(self.nodeMovedHandler)

    node_moved = QtCore.pyqtSignal('QString', name='nodeMoved')

    def nodeMovedHandler(self, nid):
        movingNode = self.get_by_nid(nid)
        for condition in self.all_exit_conditions():
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

    def all_exit_conditions(self):
        for node in self:
            for c in node.exitConditions:
                yield c

    @QtCore.pyqtSlot('QString', int, 'QVariant')
    def insertNodeAfterParent(self, nid, conditionIndex, dropData):
        # TODO: reposition all child nodes recursively
        # TODO: one arg is the dropped thingy? (to get x, y, etc.)
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

    @QtCore.pyqtSlot('QString')
    def addCondition(self, nid):
        node = self.get_by_nid(nid)
        newEnd = Node(type="end", dataType="return")
        self.append(newEnd)
        condition = ExitCondition(nextNode=newEnd.nid, condition="")
        node.exitConditions.append(condition)

    @QtCore.pyqtSlot('QString', int)
    def removeCondition(self, nid, index):
        node = self.get_by_nid(nid)
        condition = node.exitConditions[index]
        node.exitConditions.removeRows(index, 1)
        # TODO: If this causes an orphaned exit node, delete it too

    @QtCore.pyqtSlot('QString', 'QString')
    def mergeNodes(self, source_nid, target_nid):
        # Check that all is well
        source = self.get_by_nid(source_nid)
        assert source.type == 'end', "Merge source must be an end node!"

        # Update the parents
        for condition in self.all_exit_conditions():
            if condition.nextNode == source_nid:
                condition.nextNode = target_nid

        # Remove the source node
        source_index = self._items.index(source)
        self.removeRows(source_index, 1)

        # Send off signals
        self.nodeMovedHandler(target_nid)

    @QtCore.pyqtSlot('QString')
    def removeNode(self, nid):
        node = self.get_by_nid(nid)
        assert node.type not in ['root', 'end'], \
            "Can't delete root or end nodes!"

        # Calculate the parents
        parents = [n for n in self if n.hasChildNid(nid)]

        # If there's only one exitCondition, we reconnect the nodes
        if len(node.exitConditions) == 1:
            for c in self.all_exit_conditions():
                if c.nextNode == nid:
                    c.nextNode = node.exitConditions[0].nextNode
                    self.nodeMovedHandler(c.nextNode)
        # Otherwise, it sucks, but they're orphaned. Cap off the parents with
        # end nodes.
        else:
            # TODO: Detect orphaned end nodes and kill them
            for p in parents:
                newEnd = Node(type="end", dataType="return")
                self.append(newEnd)
                for c in p.exitConditions:
                    if c.nextNode == nid:
                        c.nextNode = newEnd.nid
                self.nodeMovedHandler(newEnd.nid)

        # Remove the node
        index = self._items.index(node)
        self.removeRows(index, 1)
