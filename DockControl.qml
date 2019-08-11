import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

SplitView {
    default property alias contents: content.children
    property var dockWindow: null

    property bool titleVisible: true
    property string dockTitle: "Dock title"
    property real contentMargins: 1

    property Item shareWith: null
    property Item shared: null
    property bool firstItem: false
    property real ratio: -1

    id: dockSplit
    width: parent.width
    height: parent.height
    orientation: Qt.Horizontal   

    Item {
        id: item1        

        Item {
            id: dockItem
            width: parent.width
            height: parent.height

            Rectangle {
                anchors { fill: parent; margins: contentMargins }

                Rectangle {
                    id: headerPanel
                    anchors { left: parent.left; right: parent.right; top: parent.top; }
                    border { width: 1; color: "gray" }
                    height: titleVisible ? 20 : 0
                    visible: titleVisible

                    Text {
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: dockTitle

                        MouseArea {
                            anchors.fill: parent

                            onDoubleClicked: {
                                if(dockWindow.visible === false) windowDock();
                            }
                        }
                    }

                    Image {
                        anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 5 }
                        source: "qrc:/close.svg"
                        width: 16
                        height: 16
                        visible: !dockWindow.visible

                        MouseArea {
                            anchors.fill: parent

                            onClicked: hide()
                        }
                    }
                }

                Rectangle {
                    id: content
                    anchors { left: parent.left; right: parent.right; top: headerPanel.bottom; bottom: parent.bottom }
                    border { width: 1; color: "lightgray" }
                }
            }
        }
    }

    Item {
        id: item2
        visible: shareWith !== null
    }   

    onShareWithChanged: {
        if(shareWith !== null) {
            shareWith.shared = this;
            dockItem.parent = firstItem ? item1 : item2;
            shareWith.parent = firstItem ? item2 : item1;
        }
        else dockItem.parent = item1;

        resizeItems();
    }

    onResizingChanged: {
        if(!resizing) {
            ratio = Math.min(item1.width/dockSplit.width, item1.height/dockSplit.height);
            resizeItems();
        }
    }

    onWidthChanged: changeItemsWidth()

    onHeightChanged: changeItemsHeight()

    Component.onCompleted: {
        dockWindow = dockComponent.createObject(Window.window, { title: dockTitle });
        dockWindow.width = 640;
        dockWindow.height = 480;
    }

    Component {
        id: dockComponent

        Window {
            property alias space: dockSpace

            visible: false

            DockSpace {
                id: dockSpace
                anchors.fill: parent
            }

            onVisibleChanged: {
                if(!visible) dockSpace.hideAll();
            }
        }
    }

    function changeItemsWidth() {
        item1.width = shareWith != null && orientation == Qt.Horizontal ? ratio >= 0 && ratio <= 1 ? ratio*parent.width : parent.width/2 : parent.width;
        item2.width = shareWith != null && orientation == Qt.Horizontal ? ratio >= 0 && ratio <= 1 ? (1-ratio)*parent.width : parent.width/2 : parent.width;
    }

    function changeItemsHeight() {
        item1.height = shareWith != null && orientation == Qt.Vertical ? ratio >= 0 && ratio <= 1 ? ratio*parent.height : parent.height/2 : parent.height;
        item2.height = shareWith != null && orientation == Qt.Vertical ? ratio >= 0 && ratio <= 1 ? (1-ratio)*parent.height : parent.height/2 : parent.height;
    }

    function resizeItems() {
        changeItemsWidth();
        changeItemsHeight();
    }

    function unSplit() {
        if(shared !== null) {
            shared.shareWith = shareWith;
            shared = null;
        }
        else if(shareWith !== null) {
            shareWith.shared = null;
            shareWith.parent = dockSplit.parent;
        }

        shareWith = null;
    }

    function hide() {
        if(dockWindow.visible === true) dockWindow.visible = false;
        else {
            unSplit();

            visible = false;
            parent = Window.window.contentItem;
        }
    }

    function windowDock() {
        unSplit();

        visible = false;

        dockWindow.space.insertFirst(dockSplit);
        dockWindow.show();
    }
}
