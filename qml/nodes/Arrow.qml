import QtQuick 2.0

BorderImage {
    id: l
    property alias weight: l.height
    property alias x1: l.x
    property alias y1: l.y

    property real x2: l.x
    property real y2: l.y

    signal dropped(variant source)

    smooth: true

    border { left: 2; top: 0; right: 8; bottom: 0 }
    horizontalTileMode: BorderImage.Repeat
    verticalTileMode: BorderImage.Stretch
    source: dropper.containsDrag ? "icons/arrow_highlighted.svg" : "icons/arrow.svg"

    transformOrigin: Item.Left;
    width: getWidth(x1, y1, x2, y2 - weight/2);
    rotation: getSlope(x1, y1, x2, y2 - weight/2);

    DropArea {
        id: dropper
        x: 0
        y: -10
        keys: ["InsertNodeType"]
        width: parent.width
        height: parent.height + 20
        onDropped: { l.dropped(drag.source) }
    }

    function getWidth(sx1,sy1,sx2,sy2) {
        return Math.sqrt(Math.pow((sx2-sx1),2)+Math.pow((sy2-sy1),2));
    }

    function getSlope(sx1,sy1,sx2,sy2) {
        var a,m,d;
        var b=sx2-sx1;
        if (b===0)
            return 0;
        a=sy2-sy1;
        m=a/b;
        d=Math.atan(m)*180/Math.PI;

        if (a<0 && b<0)
            return d+180;
        else if (a>=0 && b>=0)
            return d;
        else if (a<0 && b>=0)
            return d;
        else if (a>=0 && b<0)
            return d+180;
        else
            return 0;
    }
}
