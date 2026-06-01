import QtQuick
import QtQuick.Layouts
import Quickshell.WindowManager
import Quickshell.Wayland
import "Components"

FlexboxLayout{
	gap:4
	anchors.fill:parent
	alignItems:FlexboxLayout.AlignCenter
	Repeater{
		model:[...WindowManager.windowsets].sort((a,b)=>a.name.codePointAt(0)-b.name.codePointAt(0))
		delegate:TextZabuton{
			id:ws
			required property var modelData
			implicitHeight:root.size
			text:modelData.name.replace(/^special:/,'')
			borderColor:modelData.active?'#cc66ccaa':'#66aaaaaa'
			onClicked:modelData.active?
				modelData.canDeactivate&&modelData.deactivate():
				modelData.canActivate&&modelData.activate()
			Behavior on borderColor{ColorAnimation{duration:200;easing.type:Easing.OutCubic}}
		}
	}
	TextZabuton{
		implicitHeight:root.size
		// anchors.verticalCenter:parent.verticalCenter
		text:ToplevelManager.activeToplevel?.appId??''
		opacity:text.length?1:0
		scale:opacity*.5+.5
		Behavior on opacity{NumberAnimation{duration:500;easing.type:Easing.OutCubic}}
	}
}

