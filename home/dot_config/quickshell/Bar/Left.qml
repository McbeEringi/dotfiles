import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.WindowManager
import Quickshell.Wayland
import "Components"

FlexboxLayout{
	gap:4
	alignItems:FlexboxLayout.AlignCenter
	Repeater{
		model:WindowManager.windowsets
		delegate:TextZabuton{
			id:ws
			required property var modelData
			// size:root.size
			height:root.size
			width:height
			text:modelData.name
			borderColor:modelData.active?'#cc66ccaa':'#66aaaaaa'
			// value:modelData.active
			// barOpacity:modelData.active?.8:0
			onClicked:modelData.active?
				modelData.canDeactivate&&modelData.deactivate():
				modelData.canActivate&&modelData.activate()
			Behavior on borderColor{ColorAnimation{duration:200;easing.type:Easing.OutCubic}}
		}
	}
	TextZabuton{
		height:root.size
		// anchors.verticalCenter:parent.verticalCenter
		text:ToplevelManager.activeToplevel?.appId??''
		opacity:text.length?1:0
		Behavior on width{NumberAnimation{duration:200;easing.type:Easing.OutCubic}}
		Behavior on opacity{NumberAnimation{duration:500;easing.type:Easing.OutCubic}}
	}
}

