import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications
import qs.config
import qs.components.prog

ProgMouse{
	id:root
	required property var notify
	implicitWidth:parent?.width??0
	implicitHeight:80
	onClicked:notify?.dismiss()
	valueBehaviorEnabled:false
	value:1
	disabled:notify?.urgency==NotificationUrgency.Low
	critical:notify?.urgency==NotificationUrgency.Critical
	NumberAnimation on value{
		id:anm
		running:duration
		duration:timer.interval
		to:0
	}
	FlexboxLayout{
		anchors{
			fill:parent
			margins:ZabConf.padding
		}
		clip:true
		FlexboxLayout{
			direction:FlexboxLayout.Column
			Layout.fillHeight:true
			Text{
				text:root.notify?.summary??''
				color:ZabConf.textColor
				font{
					bold:true
					family:ZabConf.fontFamily
					pointSize:ZabConf.fontSize
				}
			}
			Text{
				text:root.notify?.body??''
				color:ZabConf.textColor
				wrapMode:Text.Wrap
				Layout.fillWidth:true
				font{
					family:ZabConf.fontFamily
					pointSize:ZabConf.fontSize
				}
			}
		}
	}
	Timer{
		id:timer
		running:interval
		interval:(x=>~x?x:10000)(root.notify?.expireTimeout??0)
		onTriggered:root.notify?.expire()
	}
}
