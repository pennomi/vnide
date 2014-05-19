# noinspection PyUnresolvedReferences
from PyQt5.QtCore import QObject, pyqtProperty


class QMLProperty():
    def __init__(self, type, value):
        self.t = type
        self.value = value

    # TODO: def for private and public names, etc.


class QMLObject(QObject):
    foobie = QMLProperty(int, 1)

    def __new__(cls):
        print("__new__")

        for attr_name in [a for a in dir(cls) if not a.startswith("_")]:
            attr = getattr(cls, attr_name)
            if isinstance(attr, QMLProperty):
                print("Found property to wrap:", attr_name)
                private_attr_name = "__{}".format(attr_name)

                # define getters and setters
                def getter(self):
                    return getattr(self, private_attr_name)

                def setter(self, value):
                    return setattr(self, private_attr_name, value)

                # copy the data to the new location
                setattr(cls, private_attr_name, attr.value)

                # override the old property with the new shiny one
                setattr(cls, attr_name, pyqtProperty(attr.t, getter, setter))

        return super(QMLObject, cls).__new__(cls)


if __name__ == "__main__":
    q = QMLObject()
    print(q.foobie)
