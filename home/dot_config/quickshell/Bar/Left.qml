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
		delegate:TextProgress{
			id:ws
			// size:root.size
			height:root.size
			width:root.size
			required property var modelData
			text:modelData.name
			value:1//modelData.active
			barOpacity:modelData.active?.8:0
			onClicked:modelData.activate()
			Behavior on barOpacity{NumberAnimation{duration:200;easing.type:Easing.OutCubic}}
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

