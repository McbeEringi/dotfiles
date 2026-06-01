import QtQuick

Zabuton{
	id:root
	property string text:''
	property color textColor:'#fff'
	property real margin:3
	implicitWidth:Math.max(label.contentWidth+borderWidth*margin,height)

	Text{
		id:label
		anchors{
			top:parent.top
			bottom:parent.bottom
			horizontalCenter:parent.horizontalCenter
			margins:root.borderWidth*root.margin
		}
		text:root.text
		color:root.textColor
		horizontalAlignment:Text.AlignHCenter
		verticalAlignment:Text.AlignVCenter
		fontSizeMode:Text.Fit
		//elide:Text.ElideRight
		font.pixelSize:root.height // enough to fit
		font.family:'monospace'
		FadeBehavior on text{}
	}
}
