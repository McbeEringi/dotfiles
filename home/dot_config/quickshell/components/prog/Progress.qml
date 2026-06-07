import QtQml
import QtQuick
import QtQuick.Shapes
import qs.config

Shape{
	id:root
	property real radius:0
	property real thickness:ZabConf.borderWidth
	property color color:ZabConf.barColor
	property color colorDisabled:ZabConf.barColorDisabled
	property bool disabled:false
	property real offset:0
	property real value:0
	property real parts:1
	readonly property alias length:p.l
	opacity:disabled?colorDisabled.a:color.a
	anchors.fill:parent
	layer{enabled:true;samples:4}
	Behavior on value{NumberAnimation{easing.type:Easing.OutCubic}}
	Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
	ShapePath{
		id:p
		property real _r:Math.min(root.radius,root.width/2,root.height/2)
		property real aw:root.width-_r*2
		property real ah:root.height-_r*2
		property real r:_r-root.thickness/2
		property real l:(aw+ah+r*Math.PI)*2/root.thickness

		strokeWidth:root.thickness
		strokeColor:root.disabled?Qt.rgba(root.colorDisabled.r,root.colorDisabled.g,root.colorDisabled.b,1):Qt.rgba(root.color.r,root.color.g,root.color.b,1)
		fillColor:'transparent'
		capStyle:ShapePath.RoundCap
		joinStyle:ShapePath.RoundJoin
		strokeStyle:ShapePath.DashLine
		dashOffset:p.l*(1-root.offset)
		dashPattern:(root.value,[
			p.l*root.value/root.parts,
			p.l*(1-root.value)/root.parts
		])
		Behavior on strokeColor{ColorAnimation{easing.type:Easing.OutCubic}}

		startX:root.width/2
		startY:strokeWidth/2
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
