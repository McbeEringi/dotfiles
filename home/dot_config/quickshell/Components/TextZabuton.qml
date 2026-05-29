import QtQuick

Zabuton{
	id:root
	property string text:''
	property color textColor:'#fff'
	property real margin:1.5
	Text{
		id:label
		anchors{
			fill:parent
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
	}
}
