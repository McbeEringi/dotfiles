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
			anchors.centerIn:parent
			rotation:root.rayRot*(1-2*p.prog)
			ShapePath{
				id:p
				property real r:circle.innerRadius-root.rayWidth
				property real prog:root.player?.position/root.player?.length
				property real x:r*Math.sin(prog*Math.PI)
				property real y:r*-Math.cos(prog*Math.PI)
				property real ox:0<y?r:x
				property real oy:r
				strokeWidth:rayWidth
				strokeColor:(x=>Qt.rgba(x.r,x.g,x.b,1))(root.rayColor)
				capStyle:ShapePath.RoundCap
				joinStyle:ShapePath.RoundJoin
				Behavior on r{NumberAnimation{easing.type:Easing.OutCubic}}
				Behavior on prog{NumberAnimation{easing.type:Easing.OutCubic}}

				fillColor:'transparent'
				startX:ox;startY:oy-r
				PathArc{x:p.ox+p.x;y:p.oy+p.y;radiusX:p.r;radiusY:p.r}
				PathLine{x:p.ox-p.x;y:p.oy-p.y}
				PathArc{x:p.ox;y:p.oy+p.r;radiusX:p.r;radiusY:p.r;direction:PathArc.Counterclockwise}
				PathLine{x:p.ox;y:p.oy-p.r}
			}
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
		NumberAnimation on rotation{
			running:root.player?.isPlaying??false;loops:Animation.Infinite
			to:(rot.rotation-360)
			duration:root.recordRadius*250
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
}
