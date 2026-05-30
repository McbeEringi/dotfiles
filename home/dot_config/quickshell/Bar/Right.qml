import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import "Components"
import "Singletons"

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
		delegate:Zabuton{
			id:tray
			width:root.size
			height:width
			required property var modelData
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
	TextProgress{
		id:vol
		property PwNode sink:Pipewire.defaultAudioSink
		width:root.size
		height:width
		visible:sink
		PwObjectTracker{objects:[vol.sink]}
		value:sink?.audio.volume??0
		barColor:sink?.audio.muted?'#aaa':'#6ca'
		// text:Pipewire.defaultAudioSink?.nickname
		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
		onWheel:e=>(
			e.accepted=true,
			sink.audio.volume+=e.pixelDelta.y*.0005
		)
	}
	TextProgress{
		id:bri
		width:root.size
		height:width
		visible:Brightness.device
		value:Brightness.value
		onWheel:e=>(e.accepted=true,Brightness.set(e.pixelDelta.y))
	}
	TextProgress{
		id:ram
		width:root.size
		height:width
		value:Ram.value
	}
	TextProgress{
		id:cpu
		width:root.size
		height:width
		value:Cpu.value
	}
	TextProgress{
		property bool chg:UPowerDeviceState.Charging==UPower.displayDevice.state
		id:batt
		width:root.size
		height:width
		// barColor:chg?'#e9b':'#6ca'
		// borderColor:chg?'#8866bbee':'#88aaaaaa'
		textColor:chg?'#66bbee':'#fff'
		value:UPower.displayDevice.percentage
		hoverEnabled:true

		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
	}
	PopupWindow{
		anchor.item:batt
		visible:batt.containsMouse
		Text{
			text:"hello"
		}
	}
}
