import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import "Components"

FlexboxLayout{
	gap:4
	alignItems:FlexboxLayout.AlignCenter
	Repeater{
		model:Hyprland.workspaces
		delegate:Progress{
			id:ws
			size:root.size
			required property var modelData
			text:modelData.name
			value:modelData.active
			offset:modelData.active?-1/6:0
			num:3
			// barOpacity:modelData.active
			onClicked:modelData.activate()
			Behavior on value{NumberAnimation{easing.type:Easing.OutCubic}}
			Behavior on offset{NumberAnimation{easing.type:Easing.OutCubic}}
			// Behavior on barOpacity{NumberAnimation{duration:200;easing.type:Easing.OutCubic}}
		}
	}
	Text{
		// anchors.verticalCenter:parent.verticalCenter
		text:ToplevelManager.activeToplevel?.appId??''
		color:'#fff'
		font.family:"monospace"
		FadeBehavior on text{}
	}
}

