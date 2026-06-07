import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.WindowManager
import Quickshell.Wayland
import qs.config
import qs.components
import qs.components.zab

FlexboxLayout{
	gap:4
	anchors.fill:parent
	alignItems:FlexboxLayout.AlignCenter
	ListViewAuto{
		model:ScriptModel{values:[...WindowManager.windowsets].sort((a,b)=>a.name.codePointAt(0)-b.name.codePointAt(0))}
		spacing:parent.gap
		delegate:ZabText{
			id:ws
			required property var modelData
			implicitHeight:root.size
			text:modelData.name.replace(/^special:/,'')
			borderColor:modelData.active?ZabConf.barColor:ZabConf.borderColor
			onClicked:modelData.active?
				modelData.canDeactivate&&modelData.deactivate():
				modelData.canActivate&&modelData.activate()
			Behavior on borderColor{ColorAnimation{duration:200;easing.type:Easing.OutCubic}}
		}
	}
	ZabText{
		implicitHeight:root.size
		text:ToplevelManager.activeToplevel?.appId??''
		fadeEnabled:true
		opacity:text.length?1:0
		scale:opacity*.5+.5
		Behavior on opacity{NumberAnimation{duration:500;easing.type:Easing.OutCubic}}
	}
}

