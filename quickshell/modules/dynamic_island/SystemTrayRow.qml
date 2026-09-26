import QtQuick
import Quickshell.Services.SystemTray
import Quickshell.Widgets

// The real system tray: one chip per app that registers a StatusNotifierItem
// (Discord, Steam, Telegram, etc — anything that would normally sit in a
// taskbar tray). Left click runs the item's primary action, middle click its
// secondary action, and right click opens its native context menu.
Row {
    id: root

    // The PanelWindow this row is drawn in. Needed so a right-click menu can
    // be positioned relative to the correct surface — display() is a no-op
    // without it.
    property var parentWindow: null
    property int chipSize: 24
    property int iconSize: 14

    spacing: 6
    // Collapses to nothing (instead of an empty rounded rectangle) when no
    // app currently has a tray icon registered.
    visible: width > 0 && height > 0

    Repeater {
        model: SystemTray.items

        delegate: Rectangle {
            id: trayChip

            required property SystemTrayItem modelData

            width: root.chipSize
            height: root.chipSize
            radius: 8
            color: chipMouse.containsMouse ? "#161616" : "#000000"
            border.width: 1
            border.color: "#1a1a1a"

            IconImage {
                anchors.centerIn: parent
                implicitSize: root.iconSize
                asynchronous: true
                source: trayChip.modelData.icon
            }

            MouseArea {
                id: chipMouse

                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                onClicked: mouse => {
                    switch (mouse.button) {
                    case Qt.LeftButton:
                        trayChip.modelData.activate();
                        break;
                    case Qt.MiddleButton:
                        trayChip.modelData.secondaryActivate();
                        break;
                    case Qt.RightButton:
                        if (trayChip.modelData.hasMenu && root.parentWindow) {
                            const scenePos = chipMouse.mapToItem(null, mouse.x, mouse.y);
                            trayChip.modelData.display(root.parentWindow, scenePos.x, scenePos.y);
                        }
                        break;
                    }
                }
            }
        }
    }
}
