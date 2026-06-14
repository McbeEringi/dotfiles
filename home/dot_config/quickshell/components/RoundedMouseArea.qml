import QtQuick

Item{
	id:root
	property real radius:0
	property real topLeftRadius:radius
	property real topRightRadius:radius
	property real bottomLeftRadius:radius
	property real bottomRightRadius:radius

	property alias acceptedButtons:ma.acceptedButtons
	readonly property bool containsMouse:((
		//https://iquilezles.org/articles/distfunctions2d/
		b=[width/2,height/2],
		p=[mouseX-b[0],mouseY-b[1]],
		r=Math.min(...b,[
			topLeftRadius,topRightRadius,
			bottomLeftRadius,bottomRightRadius
		][(0<p[1])*2+(0<p[0])]),
		q=p.map((x,i)=>Math.abs(x)-b[i]+r),
		sd=Math.min(Math.max(...q),0)+Math.hypot(...q.map(x=>Math.max(x,0)))-r
	)=>(
		// console.log(r,sd.toFixed(2)),
		ma.containsMouse&&sd<0
	))()
	property alias cursorShape:ma.cursorShape
	property alias drag:ma.drag
	property alias enabled:ma.enabled
	property alias hoverEnabled:ma.hoverEnabled
	property alias mouseX:ma.mouseX
	property alias mouseY:ma.mouseY
	readonly property bool pressed:containsMouse&&ma.pressed
	property alias scrollGestureEnabled:ma.scrollGestureEnabled

	signal clicked(var e)
	signal wheel(var e)

	MouseArea{
		id:ma
		anchors.fill:parent
		propagateComposedEvents:true
		onClicked:e=>root.containsMouse?root.clicked(e):(e.accepted=false)
		onWheel:e=>root.containsMouse?root.wheel(e):(e.accepted=false)
	}
}
