import QtQuick
import qs.components

ZabRect{
	id:root
	property alias containsMouse:mouse.containsMouse
	property alias pressed:mouse.pressed
	property alias acceptedButtons:mouse.acceptedButtons
	signal clicked(var e)
	signal wheel(var e)

	RoundedMouseArea{
		id:mouse
		anchors.fill:parent
		hoverEnabled:true
		radius:parent.radius
		onClicked:e=>root.clicked(e)
		onWheel:e=>root.wheel(e)
	}
}
