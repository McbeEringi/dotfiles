import QtQuick

ZabText{
	id:root
	property color barColor:Config.rgba(Config.barColor)
	property real barOpacity:Config.barColor.a
	property real offset:0
	property real value:0
	property real parts:1
	text:Math.round(prog.value*100)

	Progress{
		id:prog
		radius:root.radius
		thickness:root.border.width
		color:root.barColor
		offset:root.offset
		value:root.value
		parts:root.parts
	}
}
