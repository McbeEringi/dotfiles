import QtQuick
import QtQuick.Shapes

Zabuton{
	id:root
	property real value:0
	property real offset:0
	property real num:1
	property color barColor:'#6ca'
	property real barOpacity:.8
	property real barWidth:borderWidth
	
	Shape{
		opacity:root.barOpacity
		layer{enabled:true;samples:4}
		ShapePath{
			id:p
			property real aw:root.width-root.radius*2
			property real ah:root.height-root.radius*2
			property real r:root.radius-root.barWidth/2
			property real l:(aw+ah+r*Math.PI)*2/root.barWidth

			strokeWidth:root.barWidth
			strokeColor:root.barColor
			fillColor:'transparent'
			capStyle:ShapePath.RoundCap
			joinStyle:ShapePath.RoundJoin
			strokeStyle:ShapePath.DashLine
			dashOffset:p.l*(1-root.offset)
			dashPattern:[
				p.l*root.value/root.num,
				p.l*(1-root.value)/root.num
			]

			startX:root.width/2
			startY:root.barWidth/2
			PathLine{relativeX:p.aw/2;relativeY:0}
			PathArc{relativeX:p.r;relativeY:p.r;radiusX:p.r;radiusY:p.r}
			PathLine{relativeX:0;relativeY:p.ah;}
			PathArc{relativeX:-p.r;relativeY:p.r;radiusX:p.r;radiusY:p.r}
			PathLine{relativeX:-p.aw;relativeY:0}
			PathArc{relativeX:-p.r;relativeY:-p.r;radiusX:p.r;radiusY:p.r}
			PathLine{relativeX:0;relativeY:-p.ah;}
			PathArc{relativeX:p.r;relativeY:-p.r;radiusX:p.r;radiusY:p.r}
			PathLine{relativeX:p.aw/2;relativeY:0}
		}
	}
	
}
