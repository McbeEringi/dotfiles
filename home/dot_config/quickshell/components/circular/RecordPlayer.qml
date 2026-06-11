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
	property real artRatio:.8
	property string fontFamily:ZabConf.fontFamily
	property real fontSize:ZabConf.fontSize

	implicitHeight:recordRadius*2
	implicitWidth:implicitHeight
	radius:implicitHeight/2
	color:ZabConf.bgColor
	rotation:Math.random()*360
	FontMetrics{
		id:fm
		font{
			family:root.fontFamily
			pointSize:root.fontSize
		}
	}
	Rectangle{
		anchors.centerIn:parent
		implicitHeight:root.recordRadius*root.artRatio
		implicitWidth:implicitHeight
		color:root.color
		radius:implicitHeight/2
	}
	Image{
		anchors.centerIn:parent
		height:root.recordRadius*root.artRatio/(2**.5)
		width:height
		visible:source
		source:root.player?.trackArtUrl??''
		FadeBehavior on source{}
	}
	Circular{
		id:circle
		property string text:` ${root.player?.trackTitle??''} `
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
		acceptedButtons:Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
		onClicked:e=>({
			[Qt.LeftButton]:x=>x?.togglePlaying(),
			[Qt.RightButton]:x=>x?.next(),
			[Qt.MiddleButton]:x=>x?.previous() 
		}[e.button])(root.player)
		onWheel:e=>root.player?.seek(e.pixelDelta.y)
	}
	NumberAnimation on rotation{
		running:root.player?.isPlaying??false;loops:Animation.Infinite
		to:(root.rotation-360)
		duration:root.recordRadius*250
	}
}
