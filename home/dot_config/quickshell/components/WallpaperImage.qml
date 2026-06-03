import QtQml
import QtQuick
import Quickshell

// ShaderEffect{
// 	id:shader
// 	anchors.fill:parent
// 	property real time:0
// 	property vector2d cursor:Qt.vector2d(srcMouse.mouseX,srcMouse.mouseY)
// 	property real button:srcMouse.pressed//Buttons
// 	// property vector2d obj_pos:Qt.vector2d(obj.x,obj.y)
// 	// property real obj_rotate:obj.rotation
// 	// property real obj_scale:obj.scale
// 	property vector2d res:Qt.vector2d(width,height)
// 	property var img:ShaderEffectSource{
// 		hideSource:true
// 		sourceItem:srcImg
// 	}
// 	fragmentShader:Qt.resolvedUrl('wp.frag.qsb')
// 	Behavior on time{NumberAnimation{duration:1000}}
// 	Behavior on button{NumberAnimation{easing.type:Easing.OutCubic}}
	Image{
		id:srcImg
		anchors.fill:parent
		autoTransform:true
		fillMode:Image.PreserveAspectCrop
		source:Quickshell.env('HOME')+'/.wallpaper'
	}
// 	Timer{
// 		interval:1000;running:true;repeat:true
// 		onTriggered:shader.time+=interval/1000
// 	}
// 	MouseArea{
// 		id:srcMouse
// 		anchors.fill:parent
// 		hoverEnabled:true
// 		acceptedButtons:Qt.AllButtons
// 		// onWheel:e=>(
// 		// 	obj.x=Math.max(0,Math.min(width,obj.x+e.pixelDelta.x)),
// 		// 	obj.y=Math.max(0,Math.min(height,obj.y+e.pixelDelta.y))
// 		// )
// 	}
// 	// PinchArea{
// 	// 	anchors.fill:parent
// 	// 	pinch{
// 	// 		minimumScale:.1;maximumScale:10
// 	// 		minimumRotation:-1/0;maximumRotation:1/0
// 	// 		minimumX:0;maximumX:width
// 	// 		minimumY:0;maximumY:height
// 	// 		dragAxis:Pinch.XAndYAxis
// 	// 		target:obj
// 	// 	}
// 	// }
// 	// Rectangle{
// 	// 	id:obj
// 	// 	x:parent.width/2;y:parent.height/2
// 	// 	width:10;height:10;color:'#f0f'
// 	// }
// }
