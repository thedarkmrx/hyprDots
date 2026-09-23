-- AUTOSTART
-- Hyprland 0.55+ Lua configuration

hl.on("hyprland.start", function()
	hl.exec_cmd("~/.config/waybar/monitor-waybar.sh")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("dunst")
	hl.exec_cmd("nm-applet")
	hl.exec_cmd("udiskie -t")
	hl.exec_cmd("hyprctl setcursor WhiteSur-Cursors 24")
	hl.exec_cmd("powermode-indicator")
	hl.exec_cmd("unclutter --timeout 5")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)
