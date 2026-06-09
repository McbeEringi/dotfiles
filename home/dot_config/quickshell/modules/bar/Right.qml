import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import qs.plte
import qs.config
import qs.components
import qs.components.widgets
import qs.components.zab
import qs.components.prog
import qs.singletons

FlexboxLayout{
	gap:ZabConf.gap
	anchors.fill:parent
	alignItems:FlexboxLayout.AlignCenter
	justifyContent:FlexboxLayout.JustifyEnd
	id:root
	property real size:BarConf.height

	// Progress{
	// 	id:net
	// 	size:root.size
	// 	value:.5
	// 	text:Math.round(value*100)
	// 	hoverEnabled:true

	// 	Behavior on value{NumberAnimation{easing.type:Easing.OutCubic}}
	// }
	WidMpris{
		itemHeight:root.size
		orientation:ListView.Horizontal
		spacing:parent.gap
	}
	ListViewAuto{
		model:SystemTray.items
		delegate:ZabMouse{
			id:tray
			implicitHeight:root.size
			implicitWidth:root.size
	
			required property var modelData
			bgColor:Plte.light_6

			Image{
				anchors{
					fill:parent
					margins:ZabConf.padding
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
	ProgText{
		id:vol
		property PwNode sink:Pipewire.defaultAudioSink
		implicitHeight:root.size
		// visible:sink
		PwObjectTracker{objects:[vol.sink]}
		value:sink?.audio.volume??0
		disabled:sink?.audio.muted??true
		// text:Pipewire.defaultAudioSink?.nickname
		onWheel:e=>(
			e.accepted=true,
			sink.audio.volume+=e.pixelDelta.y*.0005
		)
		ZabPop{
			parent:vol
			text:vol.sink?.nickname??''
		}
	}
	ProgText{
		id:bri
		implicitHeight:root.size
		// visible:Brightness.device
		value:Brightness.value
		onWheel:e=>(e.accepted=true,Brightness.set(e.pixelDelta.y))
	}
	ProgText{
		id:ram
		implicitHeight:root.size
		value:Ram.value
	}
	ProgText{
		id:cpu
		implicitHeight:root.size
		value:Cpu.value
	}
	ProgText{
		property bool chg:UPowerDeviceState.Charging==UPower.displayDevice.state
		id:batt
		implicitHeight:root.size
		barColor:chg?Plte.ac5_8:value<.2?Plte.ac3_8:ZabConf.barColor
		value:UPower.displayDevice.percentage

		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
		ZabPop{
			parent:batt
			text:(x=>[
				`${x.changeRate.toFixed(1)}W`,
				(x=>`${((x/60|0)+'').padStart(2,0)}:${(x%60+'').padStart(2,0)}`)((x.timeToEmpty||x.timeToFull)/60|0)
			].join('\n'))(UPower.displayDevice)
		}
	}
}
