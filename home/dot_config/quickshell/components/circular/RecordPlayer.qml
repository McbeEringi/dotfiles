import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Widgets
import qs.plte
import qs.config
import qs.components

Rectangle{
	id:root
	required property var player
	property real recordRadius:96
	property real artRatio:.8
	property string fontFamily:ZabConf.fontFamily
	property real fontSize:ZabConf.fontSize
	property color rayColor:Plte.light_2
	property real rayRot:60
	property real rayWidth:ZabConf.borderWidth

	implicitHeight:recordRadius*2
	implicitWidth:implicitHeight
	radius:implicitHeight/2
	color:ZabConf.bgColor
	FontMetrics{
		id:fm
		font{
			family:root.fontFamily
			pointSize:root.fontSize
		}
	}
	Item{
		anchors.fill:parent
		layer{enabled:true;samples:4}
		visible:root.player?.positionSupported&&root.player?.lengthSupported
		opacity:root.rayColor.a
		Shape{
			x:parent.width/2
			y:parent.height/2
			height:0;width:0
			rotation:root.rayRot*(1-2*p.prog)
			ShapePath{
				id:p
				property real r:circle.innerRadius-root.rayWidth/2
				property bool posTrg
				property real prog:(posTrg,root.player?.position/root.player?.length)
				property real x:r*Math.sin(prog*Math.PI)
				property real y:r*-Math.cos(prog*Math.PI)
				strokeWidth:root.rayWidth
				strokeColor:(x=>Qt.rgba(x.r,x.g,x.b,1))(root.rayColor)
				capStyle:ShapePath.RoundCap
				joinStyle:ShapePath.RoundJoin
				Behavior on r{NumberAnimation{easing.type:Easing.OutCubic}}
				Behavior on prog{NumberAnimation{easing.type:Easing.OutCubic}}

				fillColor:'transparent'
				startX:0;startY:-r
				PathArc{x:p.x;y:p.y;radiusX:p.r;radiusY:p.r}
				PathLine{x:-p.x;y:-p.y}
				PathArc{x:0;y:p.r;radiusX:p.r;radiusY:p.r;direction:PathArc.Counterclockwise}
				PathLine{x:0;y:-p.r}
			}
		}
		Timer{
			running:visible&&root.player?.isPlaying
			interval:Math.max((root.player?.length??0)/(p.r*Math.PI)*1000,50)
			repeat:true
			onTriggered:p.posTrg=!p.posTrg
		}
	}
	Item{
		id:rot
		anchors.fill:parent
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
			property int num:(fm.xHeight,root.recordRadius*2*Math.PI/fm.advanceWidth(circle.text)|0)
			FadeBehavior on text{}
			anchors.centerIn:parent
			rotation:-180/num
			srcItem:FlexboxLayout{
				width:root.recordRadius*2*Math.PI
				justifyContent:FlexboxLayout.JustifySpaceAround
				Repeater{
					model:circle.num
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
		NumberAnimation on rotation{
			running:root.player?.isPlaying??false;loops:Animation.Infinite
			to:(rot.rotation-360)
			duration:root.recordRadius*250
		}
	}
	RoundedMouseArea{
		anchors.fill:parent
		radius:parent.radius
		acceptedButtons:Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
		onClicked:e=>({
			[Qt.LeftButton]:x=>x?.togglePlaying(),
			[Qt.RightButton]:x=>x?.next(),
			[Qt.MiddleButton]:x=>x?.previous() 
		}[e.button])(root.player)
		onWheel:e=>root.player?.seek(e.pixelDelta.y)
	}
}
