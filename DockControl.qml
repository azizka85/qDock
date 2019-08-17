import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.4

Item {
    default property alias contents: content.children

    property var dockWindow: null
    property Item dockSpace: null

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
            height: !dockWindow.visible && titleVisible ? 20 : 0
            visible: !dockWindow.visible && titleVisible

            Text {
                anchors { left: parent.left; right: closeImage.left; top: parent.top; bottom: parent.bottom }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: dockTitle

                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: unDock()
                }
            }

            Image {
                id: closeImage
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

    Component {
        id: dockComponent

        Window {
            title: dockTitle
            width: 300
            height: 200
            visible: false

            onVisibleChanged:
            {
                if(!visible) dockSpace.freeDock(dockItem);
            }
        }
    }

    Component.onCompleted: dockWindow = dockComponent.createObject(dockItem);

    function hide()
    {
        if(dockSpace != null) dockSpace.hideDock(dockItem);
    }

    function unDock()
    {
        if(dockSpace != null)
        {
            dockSpace.unSplit(dockItem);

            dockItem.parent = dockWindow.contentItem;

            dockWindow.show();
        }
    }
}
