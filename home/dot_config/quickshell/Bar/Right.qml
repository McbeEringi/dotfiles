import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import "Components"

FlexboxLayout{
	gap:4
	justifyContent:FlexboxLayout.JustifyEnd
	// Progress{
	// 	id:net
	// 	size:root.size
	// 	value:.5
	// 	text:Math.round(value*100)
	// 	hoverEnabled:true

	// 	Behavior on value{NumberAnimation{easing.type:Easing.OutCubic}}
	// }
	Repeater{
		model:SystemTray.items
		delegate:Progress{
			id:tray
			size:root.size
			required property var modelData
			text:''
			bgColor:'#88ffffff'

			Image{
				anchors{
					fill:parent
					margins:4*1.5
				}
				// visible:Quickshell.hasThemeIcon(modelData.icon)
				source:modelData.icon
			}
			acceptedButtons:Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
			onClicked:e=>({
				[Qt.LeftButton]:x=>x.activate(),
				[Qt.RightButton]:(x,p)=>x.display(root,p.x,p.y),
				[Qt.MiddleButton]:x=>x.secondaryActivate() 
			}[e.button])(modelData,tray.mapToGlobal(e.x,e.y))
			onWheel:e=>modelData.scroll(e.pixelDelta.y||e.pixelDelta.x,e.pixelDelta.x)
		}
	}
	Progress{
		id:vol
		property PwNode sink:Pipewire.defaultAudioSink
		size:root.size
		PwObjectTracker{objects:[vol.sink]}
		value:sink?.audio.volume??0
		barColor:sink?.audio.muted?'#aaa':'#6ca'
		// text:Pipewire.defaultAudioSink?.nickname
		Behavior on value{NumberAnimation{easing.type:Easing.OutCubic}}
		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
		onWheel:e=>(
			e.accepted=true,
			sink.audio.volume+=e.pixelDelta.y*.0005
		)
	}
	Progress{
		property bool chg:UPowerDeviceState.Charging==UPower.displayDevice.state
		id:batt
		size:root.size
		barColor:chg?'#e9b':'#6ca'
		value:UPower.displayDevice.percentage
		hoverEnabled:true

		Behavior on value{NumberAnimation{easing.type:Easing.OutCubic}}
		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
	}
	// Timer {
	// 	interval: 500
	// 	running: true
	// 	repeat: true

	// 	onTriggered:{
	// 		batt.barColor = '#'+Math.random().toString(16).slice(2,5)
	// 	}
	// }
	// Rectangle{
	// 	visible:batt.containsMouse
	// 	width:size
	// 	height:size
	// 	anchors.bottom:batt.verticalCenter
	// 	anchors.right:batt.horizontalCenter
	// 	color:"#f0f"
	// 	radius: 4
	// }
}
