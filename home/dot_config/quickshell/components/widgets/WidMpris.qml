import QtQuick
import Quickshell
import Quickshell.Widgets
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
		// modelData.trackArtUrl?'':modelData.trackTitle
		// value.toFixed(5)
		disabled:!modelData.isPlaying

		ClippingWrapperRectangle{
			anchors{
				fill:parent
				margins:parent.borderWidth
			}
			z:-1
			radius:parent.radius-parent.borderWidth
			Image{
				anchors.fill:parent
				source:modelData.trackArtUrl
				fillMode:Image.PreserveAspectCrop
			}
		}
		
		// Image{
		// 	anchors{
		// 		fill:parent
		// 		margins:parent.padding
		// 	}
		// 	z:-1
		// 	fillMode:Image.PreserveAspectCrop
		// 	visible:source
		// 	source:modelData.trackArtUrl
		// }
		
		Timer{
			running:enProg&&modelData.isPlaying
			interval:Math.max(modelData.length/barLength*100,50)
			repeat:true
			onTriggered:modelData.positionChanged()
		}
	}
}

