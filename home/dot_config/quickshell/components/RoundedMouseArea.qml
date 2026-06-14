import QtQuick

Item{
	id:root
	property real radius:0
	property real topLeftRadius:radius
	property real topRightRadius:radius
	property real bottomLeftRadius:radius
	property real bottomRightRadius:radius
	function sdf(mx:real,my:real):bool{
		//https://iquilezles.org/articles/distfunctions2d/
		const
		b=[width/2,height/2],
		p=[mx-b[0],my-b[1]],
		r=Math.min(...b,[
			topLeftRadius,topRightRadius,
			bottomLeftRadius,bottomRightRadius
		][(0<p[1])*2+(0<p[0])]),
		q=p.map((x,i)=>Math.abs(x)-b[i]+r),
		sd=Math.min(Math.max(...q),0)+Math.hypot(...q.map(x=>Math.max(x,0)))-r;
		// console.log(r,sd.toFixed(2));
		return sd<0;
	}

	property alias acceptedButtons:ma.acceptedButtons
	readonly property bool containsMouse:ma.containsMouse&&sdf(mouseX,mouseY)
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
		function handle(e:var,n:string):void{root.sdf(e.x,e.y)?root[n](e):(e.accepted=false)}
		onClicked:e=>handle(e,'clicked')
		onWheel:e=>handle(e,'wheel')
	}
}
