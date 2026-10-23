------------------
---- MONITORS ----
------------------

local notebookMonitor = "eDP-1"
local externalMonitor = "HDMI-A-1"

hl.monitor({
    output   = notebookMonitor,
    mode     = "2880x1800@60",
    position = "auto",
    scale    = 1.33,
    bitdepth = 8,
    cm       = "srgb",
})

hl.monitor({
    output   = externalMonitor,
    mode     = "preferred",
    position = "auto",
    scale    = 1,
    bitdepth = 8,
    cm       = "auto",
})

hl.config({
    render = {
      cm_enabled  = true,
      cm_auto_hdr = 1,
    },
    xwayland = {
      force_zero_scaling = true,
    },
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local editor      = "emacsclient -c"
local fileManager = "dolphin"
local menu        = "noctalia msg panel-toggle launcher"
local tidalHiFi   = "tidal-hifi --enable-features=UseOzonePlatform --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations"

local musicWorkspace = "Music"
local musicSpecialWorkspace = "special:" .. musicWorkspace

local systemdSessionEnv = "WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP HYPRLAND_INSTANCE_SIGNATURE HYPRCURSOR_SIZE XCURSOR_SIZE"
local systemdSessionUnit = table.concat({
        "systemd-run --user",
        "--unit=hyprland-session",
        "--collect",
        "--property=Type=oneshot",
        "--property=RemainAfterExit=yes",
        "--property=BindsTo=graphical-session.target",
        "--property=After=graphical-session.target",
        "/usr/bin/true",
}, " ")


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
        -- This used to break evil-paste on emacs:
        -- hl.exec_cmd("wl-clip-persist --clipboard regular")

        hl.exec_cmd("dbus-update-activation-environment --systemd " .. systemdSessionEnv)
        hl.exec_cmd("systemctl --user stop hyprland-session.service >/dev/null 2>&1 || true")
        hl.exec_cmd(systemdSessionUnit)
        hl.exec_cmd("systemctl --user start xdg-desktop-portal.service")

        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("noctalia")
        hl.exec_cmd("udiskie")
        hl.exec_cmd("hypridle")
        hl.exec_cmd("hyprsunset")
        hl.exec_cmd("hyprpm reload -n")
        hl.exec_cmd("kbuildsycoca6 --noincremental")

        -- hl.exec_cmd("emacs --bg-daemon")
        hl.dispatch(hl.dsp.exec_raw("env -u DESKTOP_STARTUP_ID -u XDG_ACTIVATION_TOKEN emacs --bg-daemon"))

        hl.exec_cmd(tidalHiFi, { workspace = musicSpecialWorkspace .. " silent" })
end)

hl.on("hyprland.shutdown", function()
        hl.exec_cmd("systemctl --user stop hyprland-session.service")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("GDK_SCALE", "2")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("EDITOR", editor)

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_MENU_PREFIX", "gnome-")


-----------------------
----- PERMISSIONS -----
-----------------------

-- Permission changes require a Hyprland restart and are not applied on-the-fly.
--
-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })
--
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
      gaps_in  = 5,
      gaps_out = 10,

      border_size = 0,

      resize_on_border = true,
      allow_tearing    = false,

      layout = "dwindle",
    },

    decoration = {
      rounding       = 5,
      rounding_power = 3,

      active_opacity   = 1.0,
      inactive_opacity = 1.0,

      shadow = {
        enabled      = true,
        range        = 4,
        render_power = 3,
        color        = "rgba(1a1a1aee)",
      },

      blur = {
        enabled  = true,
        size     = 3,
        passes   = 2,
        vibrancy = 0.1696,
      },
    },

    animations = {
      enabled = false,
    },
})

hl.layer_rule({
    name  = "noctalia",
    match = { namespace = "noctalia-background-.*$" },

    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint",   style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",         style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint",   style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",         style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear",   style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- Smart gaps examples:
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name        = "no-gaps-wtv1",
--     match       = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name        = "no-gaps-f1",
--     match       = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

for i = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(i),
        monitor   = i <= 5 and notebookMonitor or externalMonitor,
    })
end

hl.workspace_rule({
    workspace = "special:magic",
    gaps_in   = 12,
    gaps_out  = 80,
})

hl.workspace_rule({
    workspace = musicSpecialWorkspace,
    gaps_in   = 12,
    gaps_out  = 80,
})

hl.window_rule({
    match = { class = "waydroid.*" },
    float = true,
})

hl.config({
    dwindle = {
      preserve_split = true,
    },

    master = {
      new_status = "master",
    },

    misc = {
      force_default_wallpaper = -1,
      disable_hyprland_logo   = false,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
      kb_layout  = "us,br",
      kb_variant = "",
      kb_model   = "",
      kb_options = "grp:win_space_toggle,caps:escape",
      kb_rules   = "",

      repeat_rate  = 80,
      repeat_delay = 300,

      follow_mouse = 1,

      sensitivity = 0,

      touchpad = {
        natural_scroll = true,
      },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special(musicWorkspace))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
  hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

local toggleMagicWindow = os.getenv("HOME") .. "/.config/hypr/scripts/toggle-magic-window.sh"

hl.bind(mainMod .. " + MINUS",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + MINUS", hl.dsp.exec_cmd("sh " .. toggleMagicWindow))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher /emo"),           { locked = true })
hl.bind("CTRL + SHIFT + K",     hl.dsp.exec_cmd("loginctl lock-session"),                                  { locked = true })
hl.bind("CTRL + SHIFT + L",     hl.dsp.exec_cmd("noctalia msg session lock-and-suspend"), { locked = true })

hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of the region taken" -t 100]]))
hl.bind("Print",         hl.dsp.exec_cmd([[grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify "Screenshot of whole screen taken" -t 100]]))


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
      class      = "^$",
      title      = "^$",
      xwayland   = true,
      float      = true,
      fullscreen = false,
      pin        = false,
    },

    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name  = "tidal-hifi-music-workspace",
    match = { class = "^tidal-hifi$" },

    workspace = musicSpecialWorkspace,
})

hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "^org\\.pulseaudio\\.pavucontrol$" },

    float = true,
    size  = "1165 716",
})

require("noctalia.colors")

-- hy3 is using its defaults. Add plugin-specific options here if needed:
--
-- hl.config({
--     plugin = {
--         hy3 = {
--             -- no_gaps_when_only = 0,
--             -- node_collapse_policy = 2,
--         },
--     },
-- })
--

-- For Noctalia Color templates
local has_noctalia, noctalia = pcall(require, "noctalia")
if has_noctalia then
    noctalia.apply_theme()
end
