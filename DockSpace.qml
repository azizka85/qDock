import QtQuick 2.0

Item {
    property DockControl root: null

    id: dockSpace
    width: parent.width
    height: parent.height

    function insertFirst(dockControl)
    {
        if(dockControl.visible === false) {
            dockControl.parent = dockSpace;
            dockControl.shared = dockSpace;
            dockControl.shareWith = root;
            dockControl.visible = true;

            root = dockControl;
        }
    }

    function insertDock(dock, shareWith, orientation, ratio, firstItem)
    {
        if(orientation === undefined) orientation = Qt.Horizontal;
        if(shareWith === undefined) shareWith = null;
        if(ratio === undefined) ratio = -1;
        if(firstItem === undefined) firstItem = false;

        if(dock.visible === false)
        {
            if(shareWith !== null && shareWith.visible !== false)
            {
                dock.firstItem = firstItem;
                dock.ratio = ratio;
                dock.orientation = orientation;

                dock.shareWith = shareWith;
                dock.visible = true;

                if(shareWith === root) root = dock;
            }
            else insertFirst(dock);
        }
    }
}
