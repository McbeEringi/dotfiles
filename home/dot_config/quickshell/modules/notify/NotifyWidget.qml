import QtQuick
import QtQuick.Layouts
import qs.config
import qs.components.prog

ProgMouse{
	id:root
	required property var notify
	implicitWidth:parent?.width??0
	implicitHeight:80
	onClicked:notify?.dismiss()
	FlexboxLayout{
		anchors{
			fill:parent
			margins:ZabConf.padding
		}
		FlexboxLayout{
			direction:FlexboxLayout.Column
			Text{
				text:root.notify?.summary??''
				color:ZabConf.textColor
				font{
					family:ZabConf.fontFamily
					pointSize:ZabConf.fontSize*1.5
				}
			}
			Text{
				text:root.notify?.body??''
				color:ZabConf.textColor
				font{
					family:ZabConf.fontFamily
					pointSize:ZabConf.fontSize
				}
			}
		}

	}
}
