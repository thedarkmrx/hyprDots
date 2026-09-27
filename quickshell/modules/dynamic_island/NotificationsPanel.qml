import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

Item {
    id: root

    // Newest first: [{ id, appName, appIcon, summary, body, time }, ...]
    property var notifications: []
    property bool doNotDisturb: false
    property string fontFamily: "Noto Sans"
    property real morph: 0
    property int maxPanelHeight: 420

    readonly property color primaryText: "#f7f7f7"
    readonly property int panelPadding: 16
    readonly property int headerHeight: 32
    readonly property int sectionSpacing: 12
    readonly property int rowHeight: 56
    readonly property int rowSpacing: 6
    readonly property int placeholderHeight: 58
    readonly property real bodyHeight: root.notifications.length > 0 ? root.notifications.length * root.rowHeight + Math.max(0, root.notifications.length - 1) * root.rowSpacing : root.placeholderHeight
    readonly property real contentHeight: Math.min(root.maxPanelHeight, root.panelPadding * 2 + root.headerHeight + root.sectionSpacing + root.bodyHeight)
    readonly property real panelProgress: Math.max(0, Math.min(1, (root.morph - 0.22) / 0.78))

    signal closeRequested
    signal clearAllRequested
    signal clearRequested(var id)
    signal toggleDoNotDisturbRequested

    // A tick that only exists to re-evaluate the "time ago" labels every so
    // often while the panel is open — notifications themselves never change
    // once stored, so nothing else here depends on it.
    property int _clockTick: 0

    Timer {
        interval: 30000
        running: root.panelProgress > 0
        repeat: true
        onTriggered: root._clockTick += 1
    }

    function timeAgo(ts) {
        void root._clockTick;

        const diff = Math.max(0, Date.now() - ts);
        const minutes = Math.floor(diff / 60000);

        if (minutes < 1)
            return "now";
        if (minutes < 60)
            return minutes + "m";

        const hours = Math.floor(minutes / 60);

        if (hours < 24)
            return hours + "h";

        return Math.floor(hours / 24) + "d";
    }

    opacity: root.panelProgress
    visible: opacity > 0.001
    scale: 0.94 + 0.06 * root.panelProgress
    transformOrigin: Item.Top

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: root.panelPadding
        spacing: root.sectionSpacing

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: root.headerHeight
            spacing: 10

            Rectangle {
                Layout.preferredWidth: root.headerHeight
                Layout.preferredHeight: root.headerHeight
                radius: 11
                color: "#090909"
                border.width: 1
                border.color: "#232323"

                MIcon {
                    anchors.centerIn: parent
                    name: root.doNotDisturb ? "notifications_off" : "notifications"
                    size: 15
                    color: root.doNotDisturb ? "#555555" : root.primaryText
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Text {
                    Layout.fillWidth: true
                    text: "Notifications"
                    color: root.primaryText
                    elide: Text.ElideRight
                    font.family: root.fontFamily
                    font.pixelSize: 15
                    font.weight: Font.Bold
                }

                Text {
                    Layout.fillWidth: true
                    text: root.doNotDisturb ? "Silenced" : (root.notifications.length > 0 ? root.notifications.length + (root.notifications.length === 1 ? " notification" : " notifications") : "All caught up")
                    color: root.notifications.length > 0 && !root.doNotDisturb ? "#c8c8c8" : "#555555"
                    elide: Text.ElideRight
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                }
            }

            // Do Not Disturb — same switch style as the WiFi/Bluetooth radio
            // toggles, but "on" here means notifications are silenced, so the
            // glyph swaps instead of relying on the on/off color alone.
            Rectangle {
                Layout.preferredWidth: 40
                Layout.preferredHeight: 22
                radius: 11
                color: root.doNotDisturb ? "#f0f0f0" : "#0a0a0a"
                border.width: 1
                border.color: root.doNotDisturb ? "#f0f0f0" : "#232323"

                Behavior on color {
                    ColorAnimation { duration: 180; easing.type: Easing.OutCubic }
                }

                Rectangle {
                    width: 16
                    height: 16
                    radius: 8
                    y: 3
                    x: root.doNotDisturb ? parent.width - width - 3 : 3
                    color: root.doNotDisturb ? "#000000" : "#4b4b4b"

                    Behavior on x {
                        NumberAnimation { duration: 180; easing.type: Easing.OutCubic }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.toggleDoNotDisturbRequested()
                }
            }

            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                radius: 10
                color: clearAllMouse.containsMouse ? "#1a1a1a" : "#0a0a0a"
                border.width: 1
                border.color: "#232323"
                opacity: root.notifications.length > 0 ? 1 : 0.35

                MIcon {
                    anchors.centerIn: parent
                    name: "clear_all"
                    size: 12
                    color: "#999999"
                }

                MouseArea {
                    id: clearAllMouse

                    anchors.fill: parent
                    enabled: root.notifications.length > 0
                    hoverEnabled: true
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: root.clearAllRequested()
                }
            }

            Rectangle {
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
                radius: 10
                color: closeMouse.containsMouse ? "#1a1a1a" : "#0a0a0a"
                border.width: 1
                border.color: "#232323"

                MIcon {
                    anchors.centerIn: parent
                    name: "close"
                    size: 12
                    color: "#999999"
                }

                MouseArea {
                    id: closeMouse

                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.closeRequested()
                }
            }
        }

        Flickable {
            id: notifList

            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            interactive: contentHeight > height
            contentHeight: notifColumn.height
            boundsBehavior: Flickable.StopAtBounds
            visible: root.notifications.length > 0

            ColumnLayout {
                id: notifColumn

                width: notifList.width
                spacing: root.rowSpacing

                Repeater {
                    model: root.notifications

                    delegate: Rectangle {
                        id: notifRow

                        required property var modelData
                        required property int index

                        readonly property real appear: Math.max(0, Math.min(1, (root.morph - Math.min(index, 6) * 0.045) / 0.55))

                        Layout.fillWidth: true
                        Layout.preferredHeight: root.rowHeight
                        radius: 13
                        color: rowMouse.containsMouse ? "#101010" : "transparent"
                        opacity: appear

                        transform: Translate { y: (1 - notifRow.appear) * 12 }

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 9

                            Rectangle {
                                Layout.preferredWidth: 30
                                Layout.preferredHeight: 30
                                radius: 10
                                color: "#000000"
                                border.width: 1
                                border.color: "#202020"

                                IconImage {
                                    anchors.centerIn: parent
                                    implicitSize: 16
                                    asynchronous: true
                                    visible: notifRow.modelData.appIcon !== ""
                                    source: notifRow.modelData.appIcon
                                }

                                MIcon {
                                    anchors.centerIn: parent
                                    name: "notifications"
                                    size: 14
                                    color: "#777777"
                                    visible: notifRow.modelData.appIcon === ""
                                }
                            }

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 0

                                Text {
                                    Layout.fillWidth: true
                                    text: notifRow.modelData.appName
                                    color: "#8a8a8a"
                                    elide: Text.ElideRight
                                    font.family: root.fontFamily
                                    font.pixelSize: 10
                                    font.weight: Font.DemiBold
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: notifRow.modelData.summary
                                    color: root.primaryText
                                    elide: Text.ElideRight
                                    font.family: root.fontFamily
                                    font.pixelSize: 12
                                    font.weight: Font.DemiBold
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: notifRow.modelData.body
                                    color: "#999999"
                                    elide: Text.ElideRight
                                    font.family: root.fontFamily
                                    font.pixelSize: 10
                                    visible: text !== ""
                                }
                            }

                            Text {
                                text: root.timeAgo(notifRow.modelData.time)
                                color: "#666666"
                                font.family: root.fontFamily
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                            }

                            Rectangle {
                                Layout.preferredWidth: 20
                                Layout.preferredHeight: 20
                                radius: 10
                                color: rowCloseMouse.containsMouse ? "#1a1a1a" : "transparent"

                                MIcon {
                                    anchors.centerIn: parent
                                    name: "close"
                                    size: 11
                                    color: "#888888"
                                }

                                MouseArea {
                                    id: rowCloseMouse

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: root.clearRequested(notifRow.modelData.id)
                                }
                            }
                        }

                        MouseArea {
                            id: rowMouse

                            anchors.fill: parent
                            z: -1
                            hoverEnabled: true
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: root.notifications.length === 0

            Column {
                anchors.centerIn: parent
                spacing: 4

                MIcon {
                    anchors.horizontalCenter: parent.horizontalCenter
                    name: root.doNotDisturb ? "notifications_off" : "done_all"
                    size: 20
                    color: "#555555"
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: root.doNotDisturb ? "Notifications are silenced" : "No notifications"
                    color: "#666666"
                    font.family: root.fontFamily
                    font.pixelSize: 11
                    font.weight: Font.DemiBold
                }
            }
        }
    }
}
