-- KEYBINDINGS
-- Hyprland 0.55+ Lua configuration

local mainMod = "SUPER"

-- Programs
local terminal = "kitty"
local atlterminal = "ghostty"
local fileManager = "thunar"
local menu = "wofi --show drun"
local menuCli = "wofi --show run"
local browser = "zen-browser"

-- Programs
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(atlterminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v kill >/dev/null 2>&1 && kill -9 -1"))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(menuCli))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + ALT + W", hl.dsp.exec_cmd("killall waybar && ~/.config/waybar/monitor-waybar.sh"))
hl.bind(mainMod .. " + ALT + H", hl.dsp.exec_cmd("killall hyprpaper && hyprpaper"))
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("hyprpaper"))
hl.bind("ALT + W", hl.dsp.exec_cmd("~/.config/waybar/monitor-waybar.sh"))
hl.bind(mainMod .. " + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("hyprsunset --temperature 2800"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("killall -9 hyprsunset"))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("wlogout"))

-- Screenshot
hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("CTRL + ALT + S", hl.dsp.exec_cmd("hyprshot -m output"))

-- Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind("ALT + H", hl.dsp.focus({ direction = "left" }))
hl.bind("ALT + E", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + K", hl.dsp.focus({ direction = "up" }))
hl.bind("ALT + J", hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-5
for i = 1, 6 do
	hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness
local volume = "~/.config/hypr/Scripts/volume"
local brightness = "~/.config/hypr/Scripts/brightness"

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(volume .. " --inc"), { locked = true, repeating = true })
hl.bind(mainMod .. " + CTRL + U", hl.dsp.exec_cmd(volume .. " --inc"), { repeating = true })

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(volume .. " --dec"), { locked = true, repeating = true })
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(volume .. " --dec"), { repeating = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd(volume .. " --toggle"), { locked = true, repeating = true })
hl.bind(mainMod .. " + CTRL + M", hl.dsp.exec_cmd(volume .. " --toggle"), { repeating = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(brightness .. " --inc"), { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.exec_cmd(brightness .. " --inc"), { repeating = true })

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(brightness .. " --dec"), { locked = true, repeating = true })
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(brightness .. " --dec"), { repeating = true })

-- Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("CTRL + ALT + N", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("CTRL + ALT + SPACE", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
