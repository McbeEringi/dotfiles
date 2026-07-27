import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import qs.plte
import qs.config
import qs.components
import qs.components.zab
import qs.components.prog
import qs.singletons

FlexboxLayout{
	id:root
	property real size:BarConf.height
	property bool isLockScreen:false
	gap:ZabConf.gap
	alignItems:FlexboxLayout.AlignCenter
	justifyContent:FlexboxLayout.JustifyEnd
	// direction:FlexboxLayout.RowReverse

	Item{
		implicitHeight:root.size;implicitWidth:children[0].contentWidth;visible:implicitWidth&&!root.isLockScreen
		Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
		AnmListView{
			implicitHeight:parent.implicitHeight;implicitWidth:root.width;spacing:root.gap;orientation:ListView.Horizontal;interactive:false
			model:Mpris.players
			delegate:ProgText{
				id:media
				implicitHeight:root.size
				implicitWidth:Math.min(Math.max(contentWidth,implicitHeight),implicitHeight*3)
	
				required property var modelData
				property bool enProg:(modelData?.lengthSupported&&modelData?.positionSupported)??false
				property bool posTrg
				fadeEnabled:true
				acceptedButtons:Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
				onClicked:e=>({
					[Qt.LeftButton]:x=>x?.togglePlaying(),
					[Qt.RightButton]:x=>x?.next(),
					[Qt.MiddleButton]:x=>x?.previous() 
				}[e.button])(modelData)
				onWheel:e=>modelData?.seek(e.pixelDelta.y)
				value:enProg?
					(media.posTrg,modelData?.position??0)/(modelData?.length??1)%1:
					0
				text:modelData?.trackArtUrl?'':(modelData?.trackTitle??'')//.slice(0,4)
				disabled:!modelData?.isPlaying

				ZabPop{
					parent:media
					text:`${modelData?.trackTitle??''}\n${modelData?.trackAlbum??''}\n${modelData?.trackArtist??''}\n${modelData?.trackArtists??''}`
				}

				ClippingWrapperRectangle{
					visible:artwork.source
					color:'transparent'
					anchors{
						fill:parent
						margins:parent.borderWidth
					}
					radius:parent.radius-parent.borderWidth
					Image{
						id:artwork
						anchors.fill:parent
						source:modelData?.trackArtUrl??''
						fillMode:Image.PreserveAspectCrop
						mipmap:true
						FadeBehavior on source{}
					}
				}
				Timer{
					running:enProg&&modelData?.isPlaying
					interval:Math.max((modelData?.length??0)/barLength*1000,50)
					repeat:true
					onTriggered:media.posTrg=!media.posTrg//modelData?.positionChanged()
				}
			}
		}
	}
	Item{
		implicitHeight:root.size;implicitWidth:children[0].contentWidth;visible:implicitWidth&&!root.isLockScreen
		Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
		AnmListView{
			implicitHeight:parent.implicitHeight;implicitWidth:root.width;spacing:root.gap;orientation:ListView.Horizontal;interactive:false
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
				QsMenuOpener{id:menu;menu:modelData.menu}
				ZabPop{
					parent:tray
					text:menu.children.values.map(x=>x.text).join('\n')
				}
				acceptedButtons:Qt.LeftButton|Qt.RightButton|Qt.MiddleButton
				onClicked:e=>({
					[Qt.LeftButton]:x=>x.activate(),
					[Qt.RightButton]:_=>_,//(x,p)=>x.display(root,p.x,p.y),
					[Qt.MiddleButton]:x=>x.secondaryActivate() 
				}[e.button])(modelData,tray.mapToGlobal(e.x,e.y))
				onWheel:e=>modelData.scroll(e.pixelDelta.y||e.pixelDelta.x,e.pixelDelta.x)
			}
		}
	}
	Item{
		implicitHeight:root.size;implicitWidth:children[0].contentWidth;visible:implicitWidth&&!root.isLockScreen
		Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
		AnmListView{
			implicitHeight:parent.implicitHeight;implicitWidth:root.width;spacing:root.gap;orientation:ListView.Horizontal;interactive:false
			model:ScriptModel{values:Bluetooth.devices.values.filter(x=>x.connected)}
			delegate:ProgMouse{
				id:dev
				implicitHeight:root.size
				implicitWidth:root.size
				value:modelData.battery
	
				required property var modelData
				Image{
					anchors{
						fill:parent
						margins:ZabConf.padding
					}
					source:Quickshell.iconPath(modelData.icon)
				}
				ZabPop{
					parent:dev
					text:[
						modelData.name,
						...(modelData.batteryAvailable?[Math.round(modelData.battery*100)]:[])
					].join('\n')
				}
			}
		}
	}
	ZabText{
		id:net
		implicitHeight:root.size
		borderColor:Networkd.up?ZabConf.barColor:ZabConf.borderColor
		text:Networkd.log?.SSID??Networkd.log?.Name??'NC'
		fadeEnabled:true
		onClicked:Networkd.iwctl()
		ZabPop{
			parent:net
			text:(x=>x?`${x.AddressString}/${x.PrefixLength}`:'NC')(Networkd.log?.Addresses.find(x=>x.ConfigSource=='DHCPv4'))
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
	// ProgText{
	// 	id:ram
	// 	implicitHeight:root.size
	// 	value:Ram.value
	// }
	// ProgText{
	// 	id:cpu
	// 	implicitHeight:root.size
	// 	value:Cpu.value
	// }
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
