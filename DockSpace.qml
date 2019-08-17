import QtQuick 2.0

Item {   
    default property alias controls: dsPrivate.children

    id: dockSpace
    width: parent.width
    height: parent.height    

    Item {
        readonly property int typeId: 0

        id: spaceView
        anchors.fill: parent
    }

    Item {
        property var splitters: []

        id: dsPrivate
        visible: false
    }

    Component {
        id: splitter

        DockSplit { }
    }

    Component.onCompleted: {
        for(var i = 0; i < controls.length; i++) {
            if(i > 0) dsPrivate.splitters.push(splitter.createObject(dockSpace));
            controls[i].visible = false;
            controls[i].dockSpace = dockSpace;
        }
    }

    function hideDock(dock)
    {
        unSplit(dock);
        freeDock(dock);
    }

    function unSplit(dock)
    {
        if(dock.visible === true)
        {
            var typeId = dock.parent.typeId;

            if(typeId > 0)
            {
                var splitter = dock.parent.parent.parent;

                var share = typeId === 1 ? splitter.dock2.children[0] : splitter.dock1.children[0];

                share.parent = splitter.parent;
                splitter.parent = dockSpace;
                splitter.visible = false;

                dsPrivate.splitters.push(splitter);
            }
        }
    }

    function freeDock(dock)
    {
        dock.parent = dsPrivate;
        dock.visible = false;

        console.log(controls.length);
        console.log(spaceView.children.length);
        console.log(dsPrivate.splitters.length);
    }

    function insertFirst(dock, orientation, ratio, isFirst)
    {
        if(orientation === undefined) orientation = Qt.Horizontal;
        if(ratio === undefined) ratio = -1;
        if(isFirst === undefined) isFirst = false;

        if(dock.visible === false)
        {
            if(spaceView.children.length > 0)
            {
                var splitter = getSplitter(dock, spaceView.children[0], isFirst, ratio, orientation);

                splitter.parent = spaceView;
                splitter.visible = true;
            }
            else
            {
                dock.parent = spaceView;
            }

            dock.visible = true;
        }
    }

    function insertDock(dock, share, orientation, ratio, isFirst)
    {
        if(orientation === undefined) orientation = Qt.Horizontal;
        if(share === undefined) share = null;
        if(ratio === undefined) ratio = -1;
        if(isFirst === undefined) isFirst = false;

        if(dock.visible === false)
        {
            if(share !== null && share.visible !== false && share.dockWindow.visible === false)
            {
                var shareParent = share.parent;

                var splitter = getSplitter(dock, share, isFirst, ratio, orientation);

                splitter.parent = shareParent;
                splitter.visible = true;
                dock.visible = true;
            }
            else insertFirst(dock);
        }
    }

    function getSplitter(dock, share, isFirst, ratio, orientation)
    {
        var splitter = dsPrivate.splitters.pop();

        splitter.ratio = ratio;
        splitter.orientation = orientation;

        dock.parent = isFirst ? splitter.dock1 : splitter.dock2;
        share.parent = isFirst ? splitter.dock2 : splitter.dock1;

        return splitter;
    }
}
