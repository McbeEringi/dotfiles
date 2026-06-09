import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			property real size:BarConf.height
			id:root
			required property var modelData
			screen:modelData
			WlrLayershell.namespace:'bar'
			anchors{top:true;left:true;right:true}
			implicitHeight:size+container.anchors.margins*2
			color:'transparent'

			Item{
				id:container
				anchors{fill:parent;margins:4}
				Left{anchors{left:parent.left;right:center.left}}
				Center{anchors.centerIn:parent;id:center}
				Right{anchors{left:center.right;right:parent.right}}
			}
		}
	}
}
