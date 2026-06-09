import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.components

Scope{
	Variants{
		model:Quickshell.screens
		Item{
			required property var modelData
			Loader{
				active:BarConf.backgroundEnabled
				sourceComponent:PanelWindow{
					screen:screen
					id:barbg
					WlrLayershell.layer:WlrLayer.Bottom
					WlrLayershell.namespace:'wrapper'
					exclusionMode:ExclusionMode.Ignore
					anchors{top:true;left:true;right:true;bottom:true}
					color:'transparent'
					BarBackground{}
				}
			}

			PanelWindow{
				property real size:BarConf.height
				screen:modelData
				WlrLayershell.namespace:'bar'
				anchors{top:true;left:true;right:true}
				implicitHeight:size+container.anchors.topMargin+container.anchors.bottomMargin
				color:'transparent'

				Item{
					id:container
					anchors{fill:parent;margins:ZabConf.gap;bottomMargin:BarConf.backgroundEnabled?undefined:0}
					Left{anchors{left:parent.left;right:center.left}}
					Center{anchors.centerIn:parent;id:center}
					Right{anchors{left:center.right;right:parent.right}}
				}
			}
		}
	}
}
