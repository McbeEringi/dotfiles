import QtQuick
import qs.config
import qs.components.zab

ZabMouse{
	id:root
	property color barColor:ZabConf.barColor
	property color barColorDisabled:ZabConf.barColorDisabled
	property bool disabled:false
	property bool critical:false
	property real offset:0
	property real value:0
	property bool valueBehaviorEnabled:true
	property real parts:1
	readonly property alias barLength:prog.length

	Progress{
		id:prog
		radius:root.radius
		thickness:root.border.width
		color:root.barColor
		colorDisabled:root.barColorDisabled
		disabled:root.disabled
		critical:root.critical
		offset:root.offset
		value:root.value
		valueBehaviorEnabled:root.valueBehaviorEnabled
		parts:root.parts
	}
}
