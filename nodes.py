# noinspection PyUnresolvedReferences
from PyQt5 import QtCore
from uuid import uuid4
from qt import ListModel, QObjectModel, QProperty


class Node(QObjectModel):
    nid = QProperty('QString')
    x = QProperty(int)
    y = QProperty(int)
    type = QProperty('QString')
    selected = QProperty(bool)
    exitConditions = QProperty('QVariant')
    backgroundSprite = QProperty('QVariant')
    sprites = QProperty('QVariant')
    dataType = QProperty('QString')
    text = QProperty('QString')
    filename = QProperty('QString')

    moved = QtCore.pyqtSignal("QString", name='moved')

    def __init__(self, **kwargs):
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

        # backgroundSprite must be a sprite object
        background = kwargs.get('backgroundSprite')
        if background:
            kwargs['backgroundSprite'] = SpritePosition(**background)

        # ensure it has a nid
        if not kwargs.get('nid'):
            kwargs['nid'] = str(uuid4())

        # build the node
        super(Node, self).__init__(**kwargs)

        # connect the appropriate signals
        self.xChanged.connect(lambda i: self.moved.emit(self.nid))
        self.yChanged.connect(lambda i: self.moved.emit(self.nid))

    def hasChildNid(self, nid):
        # noinspection PyTypeChecker
        for c in self.exitConditions:
            if c.nextNode == nid:
                return True
        return False


class ExitCondition(QObjectModel):
    condition = QProperty('QString')
    nextNode = QProperty('QString')
    text = QProperty('QString')
    nextX = QProperty(int)
    nextY = QProperty(int)


class SpritePosition(QObjectModel):
    startX = QProperty(int)
    startY = QProperty(int)
    endX = QProperty(int)
    endY = QProperty(int)
    filename = QProperty('QString')


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
