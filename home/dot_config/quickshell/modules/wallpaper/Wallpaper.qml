import QtQml
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			id:root
			required property var modelData
			screen:modelData
			WlrLayershell.layer:WlrLayer.Background
			WlrLayershell.namespace:'wallpaper'
			exclusionMode:ExclusionMode.Ignore
			anchors{top:true;left:true;right:true;bottom:true}
			color:'transparent'
			WallpaperImage{}
		}
	}
}

