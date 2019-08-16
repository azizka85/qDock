import QtQuick 2.0

Item {
    property Item root: null

    id: dockSpace
    width: parent.width
    height: parent.height

    function insertFirst(dockControl)
    {
        if(dockControl.visible === false)
        {
            if(root == null)
            {
                dockControl.parent = dockSpace;

                root = dockControl;
            }
            else dockControl.shareWith = root;

            dockControl.visible = true;
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
            }
            else insertFirst(dock);
        }
    }
}
