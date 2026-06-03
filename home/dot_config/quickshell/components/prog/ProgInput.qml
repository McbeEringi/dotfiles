import QtQuick
import qs.config
import qs.components.zab

ZabInput{
	id:root
	property color barColor:ZabConf.barColor
	property real offset:0
	property real value:0
	property real parts:1

	Progress{
		radius:root.radius
		thickness:root.border.width
		color:root.barColor
		offset:root.offset
		value:root.value
		parts:root.parts
	}
}
