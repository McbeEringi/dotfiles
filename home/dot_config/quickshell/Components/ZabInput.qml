import QtQuick

ZabMouse{
	id:root
	property alias input:input
	property string placeholderText:''
	property color textColor:Config.textColor
	property color cursorColor:Config.cursorColor
	property string fontFamily:Config.fontFamily
	property real fontSize:Config.fontSize
	property real cursorWidth:Config.cursorWidth
	property real cursorBlink:Config.cursorBlink
	property real padding:Config.padding
	property int placeholderElide:Text.ElideNone
	readonly property real contentWidth:input.implicitWidth+borderWidth*2
	readonly property real contentHeight:input.implicitHeight+borderWidth*2
	readonly property real placeholderWidth:holder.implicitWidth+padding*2
	readonly property real placeholderHeight:holder.implicitHeight+padding*2

	implicitWidth:Math.max(contentWidth,placeholderWidth*holder.opacity,implicitHeight)
	implicitHeight:Math.max(contentHeight,placeholderHeight*holder.opacity)
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
