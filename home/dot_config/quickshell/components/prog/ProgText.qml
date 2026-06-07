import QtQuick
import qs.config
import qs.components.zab

ZabText{
	id:root
	property color barColor:ZabConf.barColor
	property color barColorDisabled:ZabConf.barColorDisabled
	property bool disabled:false
	property real offset:0
	property real value:0
	property real parts:1
	readonly property alias barLength:prog.length
	text:Math.round(prog.value*100)

	Progress{
		id:prog
		radius:root.radius
		thickness:root.border.width
		color:root.barColor
		colorDisabled:root.barColorDisabled
		disabled:root.disabled
		offset:root.offset
		value:root.value
		parts:root.parts
	}
}
