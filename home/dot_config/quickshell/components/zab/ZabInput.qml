import QtQuick
import qs.config

ZabMouse{
	id:root
	property alias input:input
	property alias text:input.text
	property string placeholderText:''
	property color textColor:ZabConf.textColor
	property color cursorColor:ZabConf.cursorColor
	property string fontFamily:ZabConf.fontFamily
	property real fontSize:ZabConf.fontSize
	property real cursorWidth:ZabConf.cursorWidth
	property real cursorBlink:ZabConf.cursorBlink
	property real padding:ZabConf.padding
	property int placeholderElide:Text.ElideNone
	readonly property real contentWidth:input.implicitWidth+borderWidth*2
	readonly property real contentHeight:input.implicitHeight+borderWidth*2
	readonly property real placeholderWidth:holder.implicitWidth+padding*2
	readonly property real placeholderHeight:holder.implicitHeight+padding*2
	readonly property bool placeholderVisible:holder.opacity

	implicitWidth:Math.max(contentWidth,placeholderWidth*placeholderVisible,implicitHeight)
	implicitHeight:Math.max(contentHeight,placeholderHeight*placeholderVisible)
	Text{
		id:holder
		anchors{
			fill:parent
			margins:root.padding
		}
		color:input.selectionColor
		clip:true
		opacity:!input.text
		font{
			family:input.font.family
			pointSize:input.font.pointSize
		}
		horizontalAlignment:TextInput.AlignHCenter
		verticalAlignment:TextInput.AlignVCenter
		elide:root.placeholderElide
		text:root.placeholderText
	}
	TextInput{
		id:input
		anchors{
			fill:parent
			margins:root.borderWidth
		}
		padding:root.padding-root.borderWidth
		clip:true
		color:root.textColor
		selectionColor:root.cursorColor
		cursorDelegate:Item{
			Rectangle{
				width:root.cursorWidth
				height:parent.height
				radius:width/2
				x:-width/2
				color:root.cursorColor
			}
			SequentialAnimation on opacity{
				loops:Animation.Infinite
				NumberAnimation{to:0;duration:root.cursorBlink*500;easing.type:Easing.OutCubic}
				NumberAnimation{to:1;duration:root.cursorBlink*500;easing.type:Easing.OutCubic}
			}
		}
		font{
			family:root.fontFamily
			pointSize:root.fontSize
		}
		horizontalAlignment:TextInput.AlignHCenter
		verticalAlignment:TextInput.AlignVCenter
	}
}
