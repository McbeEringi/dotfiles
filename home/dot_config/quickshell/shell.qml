import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Hyprland

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
				FlexboxLayout{
					// Hyprland.workspaces
				}
				Text{
					text:Time.time
					color:"#6ca"
					font.family:"monospace"
				}
				Item{
					implicitWidth:batt.implicitWidth
					implicitHeight:batt.implicitHeight
					Progress{
						id:batt
						size:root.size
						value:UPower.displayDevice.percentage
						text:Math.round(UPower.displayDevice.percentage*100)
						hoverEnabled:true
					}
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
