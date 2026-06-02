import QtQuick

ZabRect{
	id:root
	property alias containsMouse:mouse.containsMouse
	property alias pressed:mouse.pressed
	property alias acceptedButtons:mouse.acceptedButtons
	signal clicked(var e)
	signal wheel(var e)

	MouseArea{
		id:mouse
		anchors.fill:parent
		hoverEnabled:true
		onClicked:e=>root.clicked(e)
		onWheel:e=>root.wheel(e)
	}
}
