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
	property color colorCritical:ZabConf.barColorCritical
	property bool disabled:false
	property bool critical:false
	property real offset:0
	property real value:0
	property bool valueBehaviorEnabled:true
	property real parts:1
	readonly property real length:p.l*thickness
	readonly property color currentColor:disabled?colorDisabled:critical?colorCritical:color
	opacity:currentColor.a
	anchors.fill:parent
	layer{enabled:true;samples:4}
	Behavior on value{enabled:valueBehaviorEnabled;NumberAnimation{easing.type:Easing.OutCubic}}
	Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
	ShapePath{
		id:p
		property real _r:Math.min(root.radius,root.width/2,root.height/2)
		property real aw:root.width-_r*2
		property real ah:root.height-_r*2
		property real r:_r-root.thickness/2
		property real l:(aw+ah+r*Math.PI)*2/root.thickness

		strokeWidth:root.thickness
		strokeColor:(x=>Qt.rgba(x.r,x.g,x.b,1))(currentColor)
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
