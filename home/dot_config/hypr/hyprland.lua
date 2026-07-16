-- require("myColors")

hl.monitor({output="",mode="preferred",position="auto",scale="1"})

local terminal="foot"
local fileManager = "thunar"
local menu        = "fuzzel"

hl.on("hyprland.start",function()
	hl.exec_cmd("fcitx5 -d")
	hl.exec_cmd("qs -d")
	hl.exec_cmd("wlsunset -l35.7 -L139.8")
end)

hl.env("HYPRCURSOR_THEME","Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE","20")
hl.env("XCURSOR_THEME","Bibata-Modern-Ice")
hl.env("XCURSOR_SIZE","20")

hl.config({
	general={
		gaps_in=2,gaps_out=4,border_size=4,
		col={active_border="rgba(66ccaacc)",inactive_border="rgba(aaaaaa66)"},
		layout="dwindle"
	},
	decoration={
		rounding=8,
		active_opacity=1.,inactive_opacity=.9,
		dim_special=.5,
		blur={enabled=true},
		shadow={enabled=false}
	},
	group={
		col={
			border_active="rgba(bbbb66cc)",
			border_inactive="rgba(aaaaaa66)",
			border_locked_active="rgba(ee9977cc)",
			border_locked_inactive="rgba(aaaaaa66)"
		},
		groupbar={
			gradients=true,
			font_size=12,
			height=28,
			indicator_height=0,
			gradient_rounding=12,
			gradient_round_only_edges=false,
			text_color="rgba(ffffffff)",
			col={
				active="rgba(bbbb6666)",
				inactive="rgba(aaaaaa66)",
				locked_active="rgba(ee997766)",
				locked_inactive="rgba(aaaaaa66)"
			},
			gaps_in=4,
			gaps_out=4
		}
	},
	misc={
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
hl.gesture({fingers=4,direction="swipe",action="move"})
hl.gesture({fingers=4,direction="pinchout",action=function()hl.dispatch(hl.dsp.exec_cmd("qs ipc call drun exec"))end})

hl.window_rule({name="border-xwayland",match={xwayland=true},border_color="rgba(aaaaaa99)"})
hl.window_rule({name="float",match={title="float"},float=true})
hl.window_rule({name="opacity",match={class=table.concat({fileManager,terminal},"|")},opacity=".9 .8 override"})
hl.window_rule({name="mpv",match={class="mpv"},pseudo=true,workspace="special:s"})
hl.window_rule({name="mpv-shallow",match={class="mpv-shallow"},pseudo=true,workspace="special:s silent",size={256,256}})
hl.window_rule({name="suppress-maximize-events",match={class=".*"},suppress_event="maximize"})
hl.window_rule({name="fix-xwayland-drags",match={class="^$",title="^$",xwayland=true,float=true,fullscreen=false,pin=false},no_focus=true})
hl.window_rule({name="move-hyprland-run",match={class="hyprland-run"},move="20 monitor_h-120",float=true})
hl.window_rule({name="opacity-qs",match={class="6ca-shell"},opacity=".9 .8 override"})
hl.window_rule({name="float-qs-menu",match={class="6ca-shell",title="menu-.*"},float=true,pin=true,stay_focused=true,dim_around=true})
hl.window_rule({name="float-qs-mirror",match={class="6ca-shell",title="mirror"},opacity="1 override"})
hl.window_rule({name="float-qs-polkit",match={class="6ca-shell",title="polkit"},float=true,pin=true,stay_focused=true,dim_around=true})

hl.layer_rule({name="blur-bar",match={namespace="bar"},blur_popups=true,ignore_alpha=.05})
hl.layer_rule({name="blur-bar-bg",match={namespace="bar-bg"},blur=true,ignore_alpha=.05})
hl.layer_rule({name="noanim-notify",match={namespace="notify"},no_anim=true,blur=true,ignore_alpha=.05})

local mod="SUPER+"
local shift="SHIFT+"
local ctrl="CTRL+"

hl.bind(mod.."C",hl.dsp.window.close())
hl.bind(mod.."Q",hl.dsp.exec_cmd("gnome-terminal"))
hl.bind(mod.."SPACE",hl.dsp.exec_cmd("gnome-terminal node",{float=true}))
hl.bind(mod.."W",hl.dsp.exec_cmd("gnome-terminal iwctl"))
hl.bind(mod.."E",hl.dsp.exec_cmd(fileManager))
hl.bind(mod..shift.."R",hl.dsp.exec_cmd(menu))
hl.bind(mod.."R",hl.dsp.exec_cmd("qs ipc call drun exec"))
-- hl.bind(mod.."M",hl.dsp.exec_cmd("hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mod.."M",hl.dsp.exec_cmd("qs ipc call exit exec"))
hl.bind(mod.."P",hl.dsp.exec_cmd("qs ipc call mirror exec e"))

for _,x in ipairs({"left","right","up","down"}) do
	hl.bind(mod..x,hl.dsp.focus({direction=x}))
	hl.bind(mod..shift..x,hl.dsp.window.swap({direction=x}))
end
hl.bind(mod.."next",hl.dsp.focus({window="tiled"}))
hl.bind(mod.."prior",hl.dsp.focus({window="floating"}))
hl.bind(mod.."J",hl.dsp.layout("togglesplit"))
hl.bind(mod.."K",hl.dsp.layout("swapsplit"))
hl.bind(mod.."F",hl.dsp.window.float({action="toggle"}))
hl.bind(mod..shift.."F",hl.dsp.window.pseudo())
hl.bind(mod.."G",hl.dsp.group.toggle())
hl.bind(mod..shift.."G",hl.dsp.window.move({out_of_group=true}))
hl.bind(mod.."Home",hl.dsp.group.prev())
hl.bind(mod.."End",hl.dsp.group.next())
hl.bind(mod..shift.."Home",hl.dsp.group.move_window({forward=false}))
hl.bind(mod..shift.."End",hl.dsp.group.move_window({forward=true}))
hl.bind("F11",hl.dsp.window.fullscreen({action="toggle"}))

hl.bind(mod.."mouse:272",hl.dsp.window.drag(),{mouse=true})
hl.bind(mod.."mouse:273",hl.dsp.window.resize(),{mouse=true})

local swapws=function(dst)
	local mv=function(src,dst)
		for i,x in ipairs(hl.get_workspace_windows(src)) do
			hl.dispatch(hl.dsp.window.move({window=x,workspace=dst,follow=false}))
		end
	end
	return function()
		local src=hl.get_active_workspace()
		local tmp="special:swaptmp"
		mv(dst,tmp)
		mv(src,dst)
		mv(tmp,src)
		if 0<#hl.get_workspace_windows(dst) then
			hl.dispatch(hl.dsp.focus({workspace=dst}))
		end
	end
end

for i=1,10 do
	local x=i%10
	hl.bind(mod..x,hl.dsp.focus({workspace=i}))
	hl.bind(mod..shift..x,hl.dsp.window.move({workspace=i}))
	hl.bind(mod..ctrl..x,swapws(i))
end

for _,x in ipairs({"S","D"}) do
	local i="special:"..string.lower(x)
	hl.bind(mod..x,hl.dsp.workspace.toggle_special(string.lower(x)))
	hl.bind(mod..shift..x,function()
		local asw=hl.get_active_special_workspace()
		local w=hl.get_workspace(i)
		if asw and w and asw.id==w.id then
			hl.dispatch(hl.dsp.window.move({workspace=hl.get_active_workspace()}))
		else
			hl.dispatch(hl.dsp.window.move({workspace=i}))
		end
	end)
	hl.bind(mod..ctrl..x,swapws(i))
end

hl.bind(mod..ctrl.."F",hl.dsp.window.move({workspace="emptynm"}))

hl.bind(mod..ctrl.."right",hl.dsp.focus{workspace="e+1"})
hl.bind(mod..ctrl.."left",hl.dsp.focus{workspace="e-1"})
hl.bind(mod..shift..ctrl.."right",hl.dsp.window.move{workspace="e+1"})
hl.bind(mod..shift..ctrl.."left",hl.dsp.window.move{workspace="e-1"})

hl.bind(mod.."mouse_down",hl.dsp.focus({workspace="e+1"}))
hl.bind(mod.."mouse_up",hl.dsp.focus({workspace="e-1"}))


hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e2 set 5%-"),                  { locked = true, repeating = true })
hl.bind("Print",hl.dsp.exec_cmd("grimblast copy"),{locked=true})
hl.bind(mod.."Zenkaku_Hankaku",hl.dsp.exec_cmd("grimblast copy"),{locked=true})

hl.bind("XF86AudioNext",hl.dsp.exec_cmd("playerctl next"),{locked=true})
hl.bind("XF86AudioPause",hl.dsp.exec_cmd("playerctl pause"),{locked=true})
hl.bind("XF86AudioPlay",hl.dsp.exec_cmd("playerctl play-pause"),{locked=true})
hl.bind("XF86AudioPrev",hl.dsp.exec_cmd("playerctl previous"),{locked=true})

