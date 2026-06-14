pragma Singleton
import QtQml
import QtQuick
import Quickshell

Singleton{
	property color dark:'#222'
	property color dark_6:Util.alpha(dark,.6)
	property color gray:'#aaa'
	property color gray_4:Util.alpha(gray,.4)
	property color gray_8:Util.alpha(gray,.8)
	property color light:'#fff'
	property color light_6:Util.alpha(light,.6)
	property color light_4:Util.alpha(light,.4)
	property color light_2:Util.alpha(light,.2)
	property color ac0_8:Util.alpha('#6ca',.8)
	property color ac3_8:Util.alpha('#e9b',.8)
	property color ac5_8:Util.alpha('#bb6',.8)
}
