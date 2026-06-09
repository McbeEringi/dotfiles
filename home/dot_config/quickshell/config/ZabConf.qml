pragma Singleton
import QtQml
import QtQuick
import Quickshell
import qs.plte

Singleton{
	property real radius:12
	property real gap:4
	property color bgColor:Plte.dark_6
	property color bgColorOpaque:Util.alpha(bgColor,1)
	property real borderWidth:4
	property color borderColor:Plte.gray_4

	property color textColor:Plte.light
	property color cursorColor:Plte.light_4
	property real cursorWidth:2
	property real cursorBlink:1.2
	property real padding:borderWidth*1.5
	property color barColor:Plte.ac0_8
	property color barColorDisabled:Plte.gray_8
	property string fontFamily:'monospace'
	property real fontSize:12
}
