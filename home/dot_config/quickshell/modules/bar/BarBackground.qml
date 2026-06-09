import QtQml
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import qs.config

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			id:root
			required property var modelData
			screen:modelData
			WlrLayershell.layer:WlrLayer.Bottom
			WlrLayershell.namespace:'wrapper'
			exclusionMode:ExclusionMode.Ignore
			anchors{top:true;left:true;right:true;bottom:true}
			color:'transparent'
			Shape{
				width:root.width
				height:root.height
				id:s
				layer{enabled:true;samples:4}
				ShapePath{
					id:p
					property real m:.1
					property real w:root.width
					property real h:root.height
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
		}
	}
}
