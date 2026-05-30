import QtQuick
MouseArea{
	id:root
	property real radius:12
	property color bgColor:'#99222222'
	property real borderWidth:4
	property color borderColor:'#66aaaaaa'
	
	Rectangle{
		anchors.fill:parent
		color:root.bgColor
		radius:root.radius
		border{width:root.borderWidth;color:root.borderColor}
	}
}
