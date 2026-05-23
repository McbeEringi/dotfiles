import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland

Scope{
	Variants{
		model:Quickshell.screens

		PanelWindow{
			property real size:28
			id:root
			required property var modelData
			screen:modelData
			margins{
				top:4
				left:4
				right:4
			}
			anchors{
				top:true
				left:true
				right:true
			}
			implicitHeight:size
			color:"transparent"

			FlexboxLayout{
				anchors.fill:parent
				justifyContent:FlexboxLayout.JustifySpaceBetween
				FlexboxLayout{
					gap:4
					Repeater{
						model:Hyprland.workspaces
						delegate:Progress{
							id:ws
							size:root.size
							required property var modelData
							text:modelData.name
							value:1
							barOpacity:ws.modelData.active
							onClicked:modelData.activate()
							Behavior on barOpacity{NumberAnimation{duration:200;easing.type:Easing.OutCubic}}
						}
					}
				}
				Text{
					text:Time.time
					color:"#fff"
					font.family:"monospace"
				}
				Text{
					id:uuid
					text:""
					color:"#fff"
					font.family:"monospace"
				}
				Item{
					implicitWidth:batt.implicitWidth
					implicitHeight:batt.implicitHeight
					Progress{
						property bool chg:UPowerDeviceState.Charging==UPower.displayDevice.state
						id:batt
						size:root.size
						barColor:chg?'#e9b':'#6ca'
						value:UPower.displayDevice.percentage
						text:Math.round(value*100)
						hoverEnabled:true

						Behavior on value{NumberAnimation{duration:200;easing.type:Easing.OutCubic}}
					}
					// Timer {
					// 	interval: 100
					// 	running: true
					// 	repeat: true

					// 	onTriggered:{
					// 		batt.value = Math.random()
					// 		uuid.text=Array.from('00000000-0000-4000-1000-000000000000',x=>([_=>(Math.random()*16|0).toString(16),_=>'89ab'[Math.random()*4|0]][x]||(_=>x))()).join('')
					// 	}
					// }
					Rectangle{
						visible:batt.containsMouse
						width:size
						height:size
						anchors.bottom:batt.verticalCenter
						anchors.right:batt.horizontalCenter
						color:"#f0f"
						radius: 4
					}
				}
			}
		}
	}
}
