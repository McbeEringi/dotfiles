import QtQuick

Progress{
	id:root
	property string text:Math.round(value*100)
	property color textColor:'#fff'
	property real margin:1.5
	width:label.contentWidth+borderWidth*margin

	Text{
		id:label
		anchors{
			fill:parent
			margins:root.barWidth*root.margin
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
