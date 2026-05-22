import QtQuick
import QtQuick.Shapes

Item{
	property real size:40
	property real value:0
	property real offset:0
	property string text:"xx"
	property color color:"#6ca"
	property color textColor:"#fff"
	property real thinness:10
	property real sharpness:3

	property real t:size/thinness
	property real w:t*(thinness-1)
	property real r:w/sharpness
	property real a:w-r*2
	property real l:(a*4+r*2*Math.PI)/t

	id:root
	width:size
	height:size
	Shape{
		layer{enabled:true;samples:4}
		ShapePath{
			strokeWidth:t
			strokeColor:color
			fillColor:"transparent"
			capStyle:ShapePath.RoundCap
			joinStyle:ShapePath.RoundJoin
			strokeStyle:ShapePath.DashLine
			dashOffset:l*(1-offset)
			dashPattern:[
				l*value,
				l*(1-value)
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
		anchors.centerIn:parent
		text:root.text
		color:textColor
		font.family:"monospace"
	}
}
