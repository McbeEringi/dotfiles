import QtQuick

Rectangle{
	id:root
	property color bgColor:Config.bgColor
	property real borderWidth:Config.borderWidth
	property color borderColor:Config.borderColor

	implicitWidth:16
	implicitHeight:16
	color:root.bgColor
	radius:Config.radius
	border{width:root.borderWidth;color:root.borderColor}
	Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
	Behavior on implicitHeight{NumberAnimation{easing.type:Easing.OutCubic}}
}
