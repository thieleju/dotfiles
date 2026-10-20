------------------
---- MONITORS ----
------------------
-- https://wiki.hypr.land/configuring/core/monitors/
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0", scale = 1, bitdepth = 10 })
hl.monitor({ output = "DP-3", mode = "2560x1440@144", position = "1920x0", scale = 1, bitdepth = 10 })
-- Example: cm = "hdr", sdrbrightness = 1.5, sdrsaturation = 1.2.
hl.monitor({ output = "DP-1", mode = "1920x1080@60", position = "4480x0", scale = 1, bitdepth = 10 })

-- hl.config({
--     render = {
--         direct_scanout = false,
--     },
-- })

---------------------
---- PROGRAMS ----
---------------------
local terminal    = "kitty"
local fileManager = "nemo"
local browser     = "brave"
local code        = "code"
local noctaliaIPC = "noctalia msg "

-------------------
---- AUTOSTART ----
-------------------
-- https://wiki.hypr.land/configuring/core/autostart/
hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- https://wiki.hypr.land/configuring/core/environment-variables/
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-----------------------
----- PERMISSIONS -----
-----------------------
-- https://wiki.hypr.land/configuring/advanced-and-cool/permissions/
-- Permission changes require a Hyprland restart and are not applied live.

-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = {
                colors = { "rgba(3584e4ff)", "rgba(3584e4ff)" },
                angle = 45
            },
            inactive_border = "rgba(070F2A94)",
        },
        -- resize_on_border = false,
        -- See https://wiki.hypr.land/configuring/extra/tearing/ before enabling tearing.
        -- allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 20,
        rounding_power = 2,

        -- active_opacity = 1.0,
        -- inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 4,
            -- Lua uses 0xAARRGGBB; this is equivalent to rgba(1a1a1aee).
            color = 0xee1a1a1a,
        },

        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

------------------
---- ANIMATIONS ----
------------------
-- https://wiki.hypr.land/configuring/advanced-and-cool/animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
hl.window_rule({ name = "no-gaps-f1", match = { float = false, workspace = "f[1]" }, border_size = 0, rounding = 0 })

-- https://wiki.hypr.land/configuring/layouts/dwindle/
hl.config({ dwindle = { preserve_split = true } })

-- https://wiki.hypr.land/configuring/layouts/master/
hl.config({ master = { new_status = "master" } })

----------------
---- MISC ----
----------------
hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
    },
})

---------------
---- INPUT ----
---------------
hl.config({
    input = {
        kb_layout = "de",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = -0.3,
        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Example per-device configuration.
-- https://wiki.hypr.land/configuring/advanced-and-cool/devices/
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

local mainMod = "SUPER"

-----------------------------
---- WINDOW MANAGEMENT ----
-----------------------------
-- https://wiki.hypr.land/configuring/core/binds/
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + W", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- Dwindle layout only.
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(noctaliaIPC .. "session lock"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle session"))

-- Cycle through windows in a group.
hl.bind(mainMod .. " + CTRL + H", hl.dsp.group.prev())
hl.bind(mainMod .. " + CTRL + L", hl.dsp.group.next())

-- Move focus between windows.
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind("ALT + Tab", hl.dsp.window.cycle_next())

-- Resize windows while holding the key.
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Move a floating window by pixels, or move a tiled window in the chosen direction.
local function move_window_in_direction(direction, dx, dy)
    return function()
        local window = hl.get_active_window()
        if window ~= nil and window.floating then
            hl.dispatch(hl.dsp.window.move({ x = dx, y = dy, relative = true }))
        else
            hl.dispatch(hl.dsp.window.move({ direction = direction }))
        end
    end
end
hl.bind(mainMod .. " + SHIFT + CTRL + left", move_window_in_direction("l", -30, 0), { repeating = true })
hl.bind(mainMod .. " + SHIFT + CTRL + right", move_window_in_direction("r", 30, 0), { repeating = true })
hl.bind(mainMod .. " + SHIFT + CTRL + up", move_window_in_direction("u", 0, -30), { repeating = true })
hl.bind(mainMod .. " + SHIFT + CTRL + down", move_window_in_direction("d", 0, 30), { repeating = true })

-- Move and resize windows with the mouse.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true })

-- open hyprland settings with super + A
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle michael-retunzew/hyprland-settings:panel"))

------------------------
---- APPLICATIONS ----
------------------------
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal, { float = true, center = true }))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(code))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
-- hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(terminal .. " -e btop")) -- Requires btop.

------------------------
---- NOCTALIA IPC ----
------------------------
-- Use `noctalia msg --help` to check the commands supported by your installed version.
-- These commands use the documented Noctalia v5 IPC names.
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle launcher"))
-- hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle launcher"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle clipboard"))
-- The launcher uses /emo as its emoji-search prefix.
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle launcher /emo"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle session"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle control-center"))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(noctaliaIPC .. "settings-toggle"))

-- Print has no modifier. In Lua, use the keysym name directly; the old leading comma
-- was part of the legacy hyprlang bind syntax and must not be included here.
local screenshotCommand =
[[mkdir -p "$HOME/Pictures/Screenshots" && hyprcap shot region -A --freeze -r | swappy -f - -o "$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"]]
hl.bind("Print", hl.dsp.exec_cmd(screenshotCommand))

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(noctaliaIPC .. "panel-toggle wallpaper"))
hl.bind(mainMod .. " + ALT + right", hl.dsp.exec_cmd(noctaliaIPC .. "wallpaper-random"))
hl.bind(mainMod .. " + ALT + left", hl.dsp.exec_cmd(noctaliaIPC .. "wallpaper-random"))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd(noctaliaIPC .. "theme-mode-toggle"))

-- Switch to workspaces 1-10 with SUPER + [0-9].
for i = 1, 10 do
    local key = tostring(i % 10) -- Workspace 10 is bound to the 0 key.
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Navigate between workspaces.
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.focus({ workspace = "empty" }))
hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind(mainMod .. " + CTRL + ALT + left", hl.dsp.window.move({ workspace = "r-1" }))

-- Scratchpad workspace.
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic", follow = false }))

-- Scroll through existing workspaces.
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Volume and microphone controls. Mute binds intentionally do not repeat while held.
hl.bind("F10", hl.dsp.exec_cmd(noctaliaIPC .. "volume-mute"), { locked = true })
hl.bind("F11", hl.dsp.exec_cmd(noctaliaIPC .. "volume-down"), { locked = true, repeating = true })
hl.bind("F12", hl.dsp.exec_cmd(noctaliaIPC .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(noctaliaIPC .. "volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(noctaliaIPC .. "mic-mute"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(noctaliaIPC .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(noctaliaIPC .. "volume-up"), { locked = true, repeating = true })

-- Media playback controls.
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Monitor brightness controls.
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(noctaliaIPC .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(noctaliaIPC .. "brightness-down"), { locked = true, repeating = true })

---------------------
---- WINDOW RULES ----
---------------------
-- https://wiki.hypr.land/configuring/core/rules/window-rules/
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move = "20 monitor_h-120",
    float = true,
})

-- Prevent media players, Spotify, and browsers from idling while fullscreen.
hl.window_rule({ match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" }, idle_inhibit = "fullscreen" })
hl.window_rule({ match = { class = "^(.*[Ss]potify.*)$" }, idle_inhibit = "fullscreen" })
hl.window_rule({
    match = { class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$" },
    idle_inhibit = "fullscreen",
})

-- Picture-in-picture windows.
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, tag = "+picture-in-picture" })
hl.window_rule({
    match = { tag = "picture-in-picture" },
    float = true,
    keep_aspect_ratio = true,
    -- Use monitor-relative expressions instead of percentage literals.
    move = { "monitor_w * 0.73", "monitor_h * 0.72" },
    size = { "monitor_w * 0.25", "monitor_h * 0.25" },
    pin = true,
})

-- Opacity rules: active, inactive, and fullscreen opacity multipliers.
hl.window_rule({ match = { class = "^(brave-browser)$" }, opacity = "1.00 0.90 1" })
hl.window_rule({ match = { class = "^([Cc]ode)$" }, opacity = "0.90 0.85 1" })
hl.window_rule({ match = { class = "^(code-url-handler)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(code-insiders-url-handler)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.90 0.90 1" })
hl.window_rule({ match = { class = "^(nemo)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(nwg-look)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(qt5ct)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(qt6ct)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(kvantummanager)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(nm-applet)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^([Ss]team)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ match = { class = "^(steamwebhelper)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ match = { class = "^(vesktop)$" }, opacity = "0.95 0.90 1" })
hl.window_rule({ match = { class = "^(com.chatterino.chatterino)$" }, opacity = "0.85 0.80 1" })

---------------------------------------
---- ENVIRONMENT / PORTAL HELPERS ----
---------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

-- For Noctalia Color templates
require("noctalia").apply_theme()


require("hyprland-settings")
