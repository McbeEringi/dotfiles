import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.config

Rectangle{
	id:root
	required property var player
	property real recordRadius:96

	implicitHeight:circle.implicitHeight
	implicitWidth:circle.implicitWidth
	radius:implicitHeight/2
	color:ZabConf.bgColor
	FontMetrics{
		id:fm
		font{
			family:ZabConf.fontFamily
			pointSize:ZabConf.fontSize
		}
	}
	// ClippingWrapperRectangle
	Rectangle{
		anchors.centerIn:parent
		implicitHeight:circle.innerRadius
		implicitWidth:implicitHeight
		color:ZabConf.bgColor
		// radius:implicitHeight/2
		Image{
			visible:source
			anchors.fill:parent
			source:root.player.trackArtUrl
		}
	}
	Circular{
		id:circle
		property string text:`${root.player.trackTitle} `
		anchors.centerIn:parent
		srcItem:FlexboxLayout{
			width:root.recordRadius*2*Math.PI
			justifyContent:FlexboxLayout.JustifySpaceAround
			Repeater{
				model:(fm.xHeight,root.recordRadius*2*Math.PI/fm.advanceWidth(circle.text)|0)
				Text{
					id:label
					text:circle.text
					color:ZabConf.textColor
					elide:Text.ElideMiddle
					Layout.fillWidth:true
					renderType:Text.NativeRendering
					font:fm.font
				}
			}
		}
		NumberAnimation on rotation{
			running:root.player.isPlaying;loops:Animation.Infinite
			to:(circle.rotation-360)
			duration:root.recordRadius*250
		}
	}
	MouseArea{
		anchors.fill:parent
		onClicked:root.player.togglePlaying()
	}
}
