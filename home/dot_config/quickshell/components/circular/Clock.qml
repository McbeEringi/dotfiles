import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import qs.config
import qs.components
import qs.singletons

Rectangle{
	id:root
	radius:96
	
	implicitHeight:radius*2
	implicitWidth:implicitHeight
	color:ZabConf.bgColor

	layer{enabled:true;samples:4}
	readonly property var locale:Qt.locale()
	SystemClock{id:clk}
	Shape{
		x:parent.width/2
		y:parent.height/2
		height:0;width:0
		ShapePath{
			id:p
			property real ts:clk.date.getSeconds()/30*Math.PI
			property real tm:clk.date.getMinutes()/30*Math.PI+ts/60
			property real th:clk.date.getHours()/6*Math.PI+tm/12
			property real rs:circle.innerRadius-strokeWidth/2
			property real rm:rs-strokeWidth
			property real rh:rm*2/3
			strokeWidth:ZabConf.borderWidth
			strokeColor:ZabConf.barColor
			capStyle:ShapePath.RoundCap
			joinStyle:ShapePath.RoundJoin
			PathMove{x:0;y:0}
			PathLine{x:p.rh*Math.sin(p.th);y:p.rh*-Math.cos(p.th)}
			PathMove{x:0;y:0}
			PathLine{x:p.rm*Math.sin(p.tm);y:p.rm*-Math.cos(p.tm)}
			PathMove{x:p.rs*Math.sin(p.ts);y:p.rs*-Math.cos(p.ts)}
			PathLine{relativeX:0;relativeY:.001}
		}
	}
	Circular{
		id:circle
		rotation:-90
		srcItem:FlexboxLayout{
			width:root.radius*2*Math.PI
			alignItems:FlexboxLayout.AlignCenter
			Text{
				text:locale.toString(clk.date,locale.dateFormat())
				color:ZabConf.textColor
				horizontalAlignment:Text.AlignHCenter
				Layout.preferredWidth:parent.width/2
				renderType:Text.NativeRendering
				font{family:ZabConf.fontFamily;pointSize:ZabConf.fontSize}
				FadeBehavior on text{}
			}
			Text{
				text:locale.toString(clk.date,locale.timeFormat(Locale.ShortFormat))
				color:ZabConf.textColor
				rotation:180;
				horizontalAlignment:Text.AlignHCenter
				Layout.preferredWidth:parent.width/2
				renderType:Text.NativeRendering
				font{family:ZabConf.fontFamily;pointSize:ZabConf.fontSize}
				FadeBehavior on text{}
			}
		}
	}
}
