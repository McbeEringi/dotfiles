import QtQuick
import QtQuick.Layouts
import qs.config
import qs.singletons

FlexboxLayout{
	Text{
		text:Time.time
		color:ZabConf.textColor
		font.family:ZabConf.fontFamily
	}
}
