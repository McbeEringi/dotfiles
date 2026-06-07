import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.components.prog

Repeater{
	id:root
	property real implicitHeight
	model:Mpris.players
	ProgText{
		required property var modelData
		property bool enProg:modelData.lengthSupported&&modelData.positionSupported
		implicitHeight:root.implicitHeight
		fadeEnabled:true
		onClicked:modelData.togglePlaying()
		value:enProg?
			modelData.position/modelData.length:
			0
		text:modelData.trackTitle
		// text:value.toFixed(5)
		disabled:!modelData.isPlaying
		
		Timer{
			running:enProg&&modelData.isPlaying
			interval:Math.max(modelData.length/barLength*100,50)
			repeat:true
			onTriggered:modelData.positionChanged()
		}
	}
}

