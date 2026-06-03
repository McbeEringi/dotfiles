import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import qs.config
import qs.components.zab
import qs.components.prog
import qs.singletons

FlexboxLayout{
	gap:4
	anchors.fill:parent
	alignItems:FlexboxLayout.AlignCenter
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
		ZabMouse{
			id:tray
			implicitHeight:root.size
			implicitWidth:root.size
	
			required property var modelData
			bgColor:'#88ffffff'

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
		barColor:sink?.audio.muted?'#aaa':'#6ca'
		// text:Pipewire.defaultAudioSink?.nickname
		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
		onWheel:e=>(
			e.accepted=true,
			sink.audio.volume+=e.pixelDelta.y*.0005
		)
		PopupWindow{
			color:'transparent'
			anchor{
				item:vol
				edges:Edges.Bottom
				gravity:Edges.Bottom
			}
			visible:children[0].opacity
			ZabRect{
				anchors.fill:parent
				opacity:vol.containsMouse
				Text{
					anchors.centerIn:parent
					horizontalAlignment:Text.AlignHCenter
					text:vol.sink?.nickname??''
					color:ZabConf.textColor
					font.family:ZabConf.fontFamily
				}
				Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
			}
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
		// barColor:chg?'#e9b':'#6ca'
		// borderColor:chg?'#8866bbee':'#88aaaaaa'
		textColor:chg?'#66bbee':ZabConf.textColor
		value:UPower.displayDevice.percentage

		Behavior on barColor{ColorAnimation{easing.type:Easing.OutCubic}}
		PopupWindow{
			color:'transparent'
			anchor{
				item:batt
				edges:Edges.Bottom
				gravity:Edges.Bottom
			}
			visible:children[0].opacity
			ZabRect{
				anchors.fill:parent
				opacity:batt.containsMouse
				Text{
					anchors.centerIn:parent
					horizontalAlignment:Text.AlignHCenter
					text:(x=>[
						`${x.changeRate.toFixed(1)}W`,
						(x=>`${((x/60|0)+'').padStart(2,0)}:${(x%60+'').padStart(2,0)}`)((x.timeToEmpty||x.timeToFull)/60|0)
					].join('\n'))(UPower.displayDevice)
					color:ZabConf.textColor
					font.family:ZabConf.fontFamily
				}
				Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
			}
		}
	}
}
