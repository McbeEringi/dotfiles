import QtQuick
import Quickshell
import qs.config
import qs.components.zab

LazyLoader{
	id:root
	activeAsync:opacity
	required property Item parent
	property real opacity:parent.containsMouse
	property string text:''
	Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
	PopupWindow{
		color:'transparent'
		visible:root.opacity
		anchor{
			item:root.parent
			edges:Edges.Bottom
			gravity:Edges.Bottom
		}
		ZabRect{
			anchors.fill:parent
			opacity:root.opacity
			Text{
				anchors.centerIn:parent
				horizontalAlignment:Text.AlignHCenter
				text:root.text
				color:ZabConf.textColor
				font.family:ZabConf.fontFamily
			}
		}
	}
}
