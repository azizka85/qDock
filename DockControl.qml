import QtQuick 2.12
import QtQuick.Controls 1.4

Item {
    default property alias contents: content.children

    property alias splitter: dockSplit
    property alias orientation: dockSplit.orientation

    property Item shareWith: null
    property Item shared: null
    property bool firstItem: false
    property real ratio: -1
    property bool titleVisible: true
    property string dockTitle: "Dock title"
    property real contentMargins: 1

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
            }

            Image {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 5 }
                source: "qrc:/close.svg"
                width: 16
                height: 16

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

    SplitView {
        property alias dock1: item1
        property alias dock2: item2

        id: dockSplit
        anchors.fill: parent
        visible: false
        orientation: Qt.Horizontal

        Item {
            id: item1
        }

        Item {
            id: item2
        }

        onResizingChanged: {
            if(!resizing) {
                ratio = Math.min(item1.width/dockSplit.width, item1.height/dockSplit.height);
                resizeItems();
            }
        }

        onWidthChanged: changeItemsWidth()

        onHeightChanged: changeItemsHeight()

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
    }

    onShareWithChanged: {
        if(shareWith != null) {
            var dock = shareWith;

            dockSplit.parent = shared != null ? parent : dock.parent;
            dockItem.parent = firstItem ? item1 : item2;
            if(dock.shareWith === null && dock.shared !== null) dock.parent = firstItem ? item2 : item1;
            else dock.splitter.parent = firstItem ? item2 : item1;
            dockSplit.visible = true;

            dock.shared = this;

            dockSplit.resizeItems();
        }
        else {
            dockItem.parent = dockSplit.parent;
            dockSplit.parent = dockItem;
            dockSplit.visible = false;
        }                
    }
}
