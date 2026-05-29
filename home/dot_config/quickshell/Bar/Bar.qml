import QtQuick
import Quickshell

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			property real size:28
			id:root
			required property var modelData
			screen:modelData
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
