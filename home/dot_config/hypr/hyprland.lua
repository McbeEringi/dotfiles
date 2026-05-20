-- require("myColors")

hl.monitor({output="",mode="preferred",position="auto",scale="1"})

local fileManager = "thunar"
local menu        = "fuzzel"

hl.on("hyprland.start",function()
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("/usr/lib/xfce-polkit/xfce-polkit")
end)

hl.config({
    general={
        gaps_in=4,gaps_out=4,border_size=4,
        col={active_border="rgba(66ccaacc)",inactive_border="rgba(aaaaaacc)"},
        layout="dwindle"
    },
    decoration={
        rounding=8,
        active_opacity=1.,inactive_opacity=.9,
        blur={enabled=true,size=4},
        shadow={enabled=false}
    },
    misc = {
        -- disable_splash_rendering=true,
        font_family="monospace",
        force_default_wallpaper=0,
        vrr=1,
        mouse_move_enables_dpms=true,
        key_press_enables_dpms=true,
        focus_on_activate=true
    },
    binds={
        hide_special_on_workspace_change=true,
    },
    input={
        kb_layout="jp",
        follow_mouse=1,focus_on_close=1,
        touchpad={disable_while_typing=true,natural_scroll=true},
    },
    dwindle={preserve_split=true},
})


hl.animation({leaf="global",enabled=true,speed=5,bezier="default"})
hl.animation({leaf="windowsOut",enabled=true,speed=5,bezier="default",style="popin 80%"})
hl.animation({leaf="specialWorkspace",enabled=true,speed=5,bezier="default",style="slidefade 20%"})
hl.animation({leaf="monitorAdded",enabled=false})


hl.gesture({fingers=3,direction="horizontal",action="workspace"})
hl.gesture({fingers=3,direction="vertical",action="fullscreen"})


local mod="SUPER+"
local shift="SHIFT+"

hl.bind(mod.."Q",hl.dsp.exec_cmd("gnome-terminal"))
hl.bind(mod.."C",hl.dsp.window.close())
hl.bind(mod.."M",hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mod.."E",hl.dsp.exec_cmd(fileManager))
hl.bind(mod.."F",hl.dsp.window.float({action="toggle"}))
hl.bind(mod..shift.."F",hl.dsp.window.pseudo())
hl.bind(mod.."R",hl.dsp.exec_cmd(menu))
hl.bind(mod.."J",hl.dsp.layout("togglesplit"))

for i,x in ipairs({"left","right","up","down"}) do
    hl.bind(mod..x,hl.dsp.focus({direction=x}))
end

for i=1,10 do
    local key=i%10
    hl.bind(mod..key,hl.dsp.focus({workspace=i}))
    hl.bind(mod..shift..key,hl.dsp.window.move({workspace=i}))
end

hl.bind(mod.."S",hl.dsp.workspace.toggle_special("s"))
hl.bind(mod..shift.."S",hl.dsp.window.move({workspace="special:s"}))

hl.bind(mod.."mouse_down",hl.dsp.focus({workspace="e+1"}))
hl.bind(mod.."mouse_up",hl.dsp.focus({workspace="e-1"}))

hl.bind(mod.."mouse:272",hl.dsp.window.drag(),{mouse=true})
hl.bind(mod.."mouse:273",hl.dsp.window.resize(),{mouse=true})

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

hl.bind("XF86AudioNext",hl.dsp.exec_cmd("playerctl next"),{locked=true})
hl.bind("XF86AudioPause",hl.dsp.exec_cmd("playerctl pause"),{locked=true})
hl.bind("XF86AudioPlay",hl.dsp.exec_cmd("playerctl play-pause"),{locked=true})
hl.bind("XF86AudioPrev",hl.dsp.exec_cmd("playerctl previous"),{locked=true})

hl.window_rule({name="suppress-maximize-events",match={class=".*"},suppress_event="maximize"})
hl.window_rule({name="fix-xwayland-drags",match={class="^$",title="^$",xwayland=true,float=true,fullscreen=false,pin=false,},no_focus=true})
hl.window_rule({name="border-xwayland",match={xwayland=true},border_color="rgba(aaaaaacc)"})
hl.window_rule({name="move-hyprland-run",match={class="hyprland-run"},move="20 monitor_h-120",float=true})
hl.window_rule({name="float-xfce-polkit",match={class="xfce-polkit"},float=true})
