import QtQuick
import qs.config
import qs.components

ZabMouse{
	id:root
	property string text:''
	property color textColor:ZabConf.textColor
	property string fontFamily:ZabConf.fontFamily
	property real fontSize:ZabConf.fontSize
	property real padding:ZabConf.padding
	property bool fadeEnabled:false
	property int elide:Text.ElideRight
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
		minimumPointSize:root.fontSize/2
		horizontalAlignment:Text.AlignHCenter
		verticalAlignment:Text.AlignVCenter
		fontSizeMode:Text.Fit
		elide:root.elide
		text:root.text
		FadeBehavior on text{enabled:root.fadeEnabled}
	}
}
