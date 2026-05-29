import QtQuick
import QtQuick.Layouts
import "Singletons"

FlexboxLayout{
	Text{
		text:Time.time
		color:"#fff"
		font.family:"monospace"
	}
}
