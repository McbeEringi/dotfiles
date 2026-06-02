import QtQuick

ZabMouse{
	id:root
	property string text:''
	property color textColor:Config.textColor
	property string fontFamily:Config.fontFamily
	property real fontSize:Config.fontSize
	property real padding:Config.padding
	property bool fadeEnabled:false
	property int elide:Text.ElideNone
	readonly property real contentWidth:text.implicitWidth+padding*2
	readonly property real contentHeight:text.implicitHeight+padding*2

	implicitWidth:Math.max(implicitHeight,contentWidth)
	implicitHeight:contentHeight
	Text{
		id:text
		anchors{
			fill:parent
			margins:root.padding
		}
		color:root.textColor
		font{
			family:root.fontFamily
			pointSize:root.fontSize
		}
		minimumPointSize:0
		horizontalAlignment:Text.AlignHCenter
		verticalAlignment:Text.AlignVCenter
		fontSizeMode:Text.Fit
		elide:root.elide
		text:root.text
		FadeBehavior on text{enabled:root.fadeEnabled}
	}
}
