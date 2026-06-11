import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets
import qs.config
import qs.components

Rectangle{
	id:root
	required property var player
	property real recordRadius:96

	implicitHeight:circle.implicitHeight
	implicitWidth:circle.implicitWidth
	radius:implicitHeight/2
	color:ZabConf.bgColor
	rotation:Math.random()*360
	FontMetrics{
		id:fm
		font{
			family:ZabConf.fontFamily
			pointSize:ZabConf.fontSize
		}
	}
	Rectangle{
		anchors.centerIn:parent
		implicitHeight:circle.innerRadius
		implicitWidth:implicitHeight
		color:ZabConf.bgColor
		radius:implicitHeight/2
	}
	Image{
		anchors.centerIn:parent
		height:circle.innerRadius/(2**.5)
		width:height
		visible:source
		source:root.player.trackArtUrl
		FadeBehavior on source{}
	}
	Circular{
		id:circle
		property string text:` ${root.player.trackTitle} `
		FadeBehavior on text{}
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
					// elide:Text.ElideMiddle
					// Layout.fillWidth:true
					renderType:Text.NativeRendering
					font:fm.font
				}
			}
		}
	}
	MouseArea{
		anchors.fill:parent
		onClicked:root.player.togglePlaying()
	}
	NumberAnimation on rotation{
		running:root.player.isPlaying;loops:Animation.Infinite
		to:(root.rotation-360)
		duration:root.recordRadius*250
	}
}
