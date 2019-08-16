import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    property bool isTitleVisible: true

    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World's")

    DockControl {
        id: world1
        visible: false
        dockTitle: "World 1"
        titleVisible: isTitleVisible

        Text {
            anchors.centerIn: parent
            text: qsTr("World 1")
        }
    }

    DockControl {
        id: world2
        visible: false
        dockTitle: "World 2"
        titleVisible: isTitleVisible

        Text {
            anchors.centerIn: parent
            text: qsTr("World 2")
        }
    }

    DockControl {
        id: world3
        visible: false
        dockTitle: "World 3"
        titleVisible: isTitleVisible

        Text {
            anchors.centerIn: parent
            text: qsTr("World 3")
        }
    }

    DockSpace {
        id: dockSpace
        root: world4

        DockControl {
            id: world4
            dockTitle: "World 4"
            titleVisible: isTitleVisible

            Text {
                anchors.centerIn: parent
                text: qsTr("Field")
            }
        }
    }

    Column {
        z: 2;

        Button {
            text: "Title visibility"
            onClicked: isTitleVisible = !isTitleVisible
        }

        Button {
            text: "world 1"
            onClicked: {
                dockSpace.insertDock(world1, world2, Qt.Vertical, 0.6, true);
            }
        }

        Button {
            text: "world 2"
            onClicked: {
                dockSpace.insertDock(world2, world1, Qt.Vertical, 0.6, false);
            }
        }

        Button {
            text: "world 3"
            onClicked: {
                dockSpace.insertDock(world3, world4, Qt.Vertical, 0.4, true);
            }
        }

        Button {
            text: "world 4"
            onClicked: {
                dockSpace.insertDock(world4, world3, Qt.Vertical, 0.4, false);
            }
        }
    }
}
