import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower

Scope{
	Variants{
		model:Quickshell.screens

		PanelWindow{
			property real size:32
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
				Text{
					text:Time.time
					color:"#6ca"
					font.family:"monospace"
				}
				Progress{
					id:pgr
					size:root.size
					value:UPower.displayDevice.percentage
					text:Math.round(UPower.displayDevice.percentage*100)
					// font.pixelSize:320
					MouseArea{
						anchors.fill:parent
						onClicked:{
							anmOffset[anmOffset.running?'stop':'start']()
						}
					}
					NumberAnimation{
						id:anmOffset
						target:pgr
						properties:"offset"
						duration:1000
						from:0
						to:1
						loops:Animation.Infinite
						// easing{type:Easing.OutBack}
					}
				}
			}
		}
	}
}
