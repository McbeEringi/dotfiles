import QtQuick
import Quickshell
import Quickshell.Services.Mpris
import qs.components
import qs.components.prog

ListViewAuto{
	id:root
	property real itemHeight:64
	model:Mpris.players
	delegate:ProgText{
		required property var modelData
		property bool enProg:modelData.lengthSupported&&modelData.positionSupported
		anchors.horizontalCenter:root.orientation==ListView.Vertical?parent.horizontalCenter:undefined
		implicitHeight:root.itemHeight
		fadeEnabled:true
		onClicked:modelData.togglePlaying()
		value:enProg?
			modelData.position/modelData.length%1:
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

