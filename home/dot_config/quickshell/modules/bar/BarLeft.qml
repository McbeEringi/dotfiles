import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.WindowManager
import Quickshell.Wayland
import qs.config
import qs.components
import qs.components.zab

FlexboxLayout{
	id:root
	property real size:BarConf.height
	gap:ZabConf.gap
	alignItems:FlexboxLayout.AlignCenter
	Item{
		implicitHeight:root.size
		implicitWidth:children[0].contentWidth
		Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
		AnmListView{
			implicitHeight:parent.implicitHeight
			implicitWidth:root.width
			spacing:root.gap
			orientation:ListView.Horizontal
			model:ScriptModel{values:[...WindowManager.windowsets].sort((a,b)=>a.name.codePointAt(0)-b.name.codePointAt(0))}
			delegate:ZabText{
				required property var modelData
				implicitHeight:root.size
				text:modelData.name.replace(/^special:/,'')
				borderColor:modelData.active?ZabConf.barColor:ZabConf.borderColor
				onClicked:modelData.active?
					modelData.canDeactivate&&modelData.deactivate():
					modelData.canActivate&&modelData.activate()
				Behavior on borderColor{ColorAnimation{easing.type:Easing.OutCubic}}
			}
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

