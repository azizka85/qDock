import QtQuick 2.0

Item {
    id: dockSpace
    width: parent.width
    height: parent.height

    function appendDock(dockControl)
    {
        if(dockControl.visible === false) {
            if(dockSpace.children.length > 0) {

                var dock = dockSpace.children[0];

                while(dock.shareWith !== null) dock = dock.shareWith;

                dock.shareWith = dockControl;
                dockControl.visible = true;
            }
            else {
                dockControl.parent = dockSpace;
                dockControl.visible = true;
            }
        }
    }

    function insertFirst(dockControl)
    {
        if(dockControl.visible === false) {
            var dock = null;

            if(dockSpace.children.length > 0) dock = dockSpace.children[0];

            dockControl.shareWith = dock;
            dockControl.parent = dockSpace;
            dockControl.visible = true;
        }
    }

    function hideAll() {
        if(dockSpace.children.length > 0) {

            var dock = dockSpace.children[0];

            while(dock.shareWith !== null) dock = dock.shareWith;

            var shared = null;

            do {
                shared = dock.shared;
                dock.hide();
                dock = shared;
            }
            while(shared !== null);
        }
    }

    function insertDock(dock, shareWith) {
        if(dock.visible === false) {
            if(shareWith !== null && shareWith.visible !== false) {
                if(shareWith.shared !== null) {
                    shareWith.shared.shareWith = dock;
                }
                else dock.parent = dockSpace;

                dock.shareWith = shareWith;
                dock.visible = true;
            }
            else appendDock(dock);
        }
    }
}
