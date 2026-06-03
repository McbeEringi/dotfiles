import QtQuick
import qs.config

Rectangle{
	id:root
	property color bgColor:ZabConf.bgColor
	property real borderWidth:ZabConf.borderWidth
	property color borderColor:ZabConf.borderColor

	implicitWidth:16
	implicitHeight:16
	color:root.bgColor
	radius:ZabConf.radius
	border{width:root.borderWidth;color:root.borderColor}
	Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
	Behavior on implicitHeight{NumberAnimation{easing.type:Easing.OutCubic}}
}
