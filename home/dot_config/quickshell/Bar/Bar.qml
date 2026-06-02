import QtQuick
import Quickshell
import Quickshell.Wayland
import "Components"

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			property real size:Config.statusbarHeight
			id:root
			required property var modelData
			screen:modelData
			WlrLayershell.namespace:'bar'
			margins{top:4;left:4;right:4}
			anchors{top:true;left:true;right:true}
			implicitHeight:size
			color:'transparent'

			Left{anchors{left:parent.left;right:center.left}}
			Center{anchors.centerIn:parent;id:center}
			Right{anchors{left:center.right;right:parent.right}}
		}
	}
}
