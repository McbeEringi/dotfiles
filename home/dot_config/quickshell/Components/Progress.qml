import QtQuick
import QtQuick.Shapes

MouseArea{
	property real size:40
	property real radius:12
	property real borderWidth:4
	property real value:0
	property real offset:0
	property real num:1
	property string text:''
	property alias font:label.font
	property color barColor:'#6ca'
	property real barOpacity:0.8
	property color textColor:'#fff'
	property color bgColor:'#99222222'
	property color borderColor:'#66888888'
	property real thinness:10
	property real sharpness:3

	property real t:borderWidth
	property real w:size-t
	property real r:radius-t/2
	property real a:w-r*2
	property real l:(a*4+r*2*Math.PI)/t

	id:root
	implicitWidth:size
	implicitHeight:size
	clip:true
	Rectangle{
		anchors.fill:parent
		color:bgColor
		radius:r+t/2
		border{width:t;color:borderColor}
	}
	Shape{
		opacity:barOpacity
		layer{enabled:true;samples:4}
		ShapePath{
			strokeWidth:t
			strokeColor:barColor
			fillColor:'transparent'
			capStyle:ShapePath.RoundCap
			joinStyle:ShapePath.RoundJoin
			strokeStyle:ShapePath.DashLine
			dashOffset:l*(1-offset)
			dashPattern:[
				l*value/num,
				l*(1-value)/num
			]

			startX:size/2
			startY:t/2
			PathLine{relativeX:a/2;relativeY:0}
			PathArc{relativeX:r;relativeY:r;radiusX:r;radiusY:r}
			PathLine{relativeX:0;relativeY:a;}
			PathArc{relativeX:-r;relativeY:r;radiusX:r;radiusY:r}
			PathLine{relativeX:-a;relativeY:0}
			PathArc{relativeX:-r;relativeY:-r;radiusX:r;radiusY:r}
			PathLine{relativeX:0;relativeY:-a;}
			PathArc{relativeX:r;relativeY:-r;radiusX:r;radiusY:r}
			PathLine{relativeX:a/2;relativeY:0}
		}
	}
	Text{
		id:label
		anchors{
			fill:parent
			margins:t*1.5
		}
		text:root.text
		color:textColor
		horizontalAlignment:Text.AlignHCenter
		verticalAlignment:Text.AlignVCenter
		fontSizeMode:Text.Fit
		//elide:Text.ElideRight
		font.pixelSize:size // enough to fit
		font.family:'monospace'
	}
}
