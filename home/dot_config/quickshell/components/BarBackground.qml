import QtQml
import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import qs.config
import qs.components

Shape{
	id:s
	width:parent.width
	height:parent.height
	layer{enabled:true;samples:4}
	ShapePath{
		id:p
		property real m:.1
		property real w:s.width
		property real h:s.height
		property real c:ZabConf.radius+ZabConf.borderWidth
		property real l:0
		property real r:0
		property real t:BarConf.height+4*2
		property real b:0
		strokeWidth:0
		fillColor:ZabConf.bgColor

		PathMove{x:p.w*-p.m;y:p.h*-p.m}
		PathLine{x:p.w*(1+p.m);y:p.h*-p.m}
		PathLine{x:p.w*(1+p.m);y:p.h*(1+p.m)}
		PathLine{x:p.w*-p.m;y:p.h*(1+p.m)}
		PathLine{x:p.w*-p.m;y:p.h*-p.m}

		PathMove{x:p.c+p.l;y:p.t}
		PathLine{x:p.w-p.r-p.c;y:p.t}
		PathArc{relativeX:p.c;relativeY:p.c;radiusX:p.c;radiusY:p.c}
		PathLine{x:p.w-p.r;y:p.h-p.b-p.c}
		PathArc{relativeX:-p.c;relativeY:p.c;radiusX:p.c;radiusY:p.c}
		PathLine{x:p.l+p.c;y:p.h-p.b}
		PathArc{relativeX:-p.c;relativeY:-p.c;radiusX:p.c;radiusY:p.c}
		PathLine{x:p.l;y:p.t+p.c}
		PathArc{relativeX:p.c;relativeY:-p.c;radiusX:p.c;radiusY:p.c}
	}
}
