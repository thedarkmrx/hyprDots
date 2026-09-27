//@ pragma UseQApplication
//@ pragma IconTheme MacTahoe-dark
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import "modules/dynamic_island"

ShellRoot {
    id: root

    DynamicIsland {
    }

}
