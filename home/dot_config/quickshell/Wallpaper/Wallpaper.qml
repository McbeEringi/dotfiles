import QtQml
import QtQuick
import Quickshell
import Quickshell.Wayland

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			id:root
			required property var modelData
			screen:modelData
			WlrLayershell.layer: WlrLayer.Background
			exclusionMode:ExclusionMode.Ignore
			anchors{top:true;left:true;right:true;bottom:true}
			color:'transparent'
			Image{
				anchors.fill:parent
				fillMode:Image.PreserveAspectCrop
				source:Qt.resolvedUrl('./wp.jpg')
			}
		}
	}
}

