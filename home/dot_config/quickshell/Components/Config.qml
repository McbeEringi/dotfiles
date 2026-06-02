pragma Singleton
import QtQml
import QtQuick
import Quickshell

Singleton{
	property real statusbarHeight:28
	
	property real radius:12
	property color bgColor:'#99222222'
	property real borderWidth:4
	property color borderColor:'#66aaaaaa'

	property color textColor:'#ffffffff'
	property color cursorColor:'#66ffffff'
	property real cursorWidth:2
	property real cursorBlink:1.2
	property real padding:borderWidth*1.5
	property color barColor:'#cc66ccaa'
	property string fontFamily:'monospace'
	property real fontSize:12

	function rgba(x,a=1){return Qt.rgba(x.r,x.g,x.b,a);}
}
