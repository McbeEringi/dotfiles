import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config

FlexboxLayout{
	Text{
		text:Qt.formatDateTime(clk.date,'yyyy-MM-dd hh:mm')
		color:ZabConf.textColor
		font.family:ZabConf.fontFamily
	}
	SystemClock{id:clk;precision:SystemClock.Minutes}
}
