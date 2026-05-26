import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import Quickshell.Services.SystemTray
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

			Image{
				anchors{
					fill:parent
					margins:4*1.5
				}
				// visible:Quickshell.hasThemeIcon(modelData.icon)
				source:modelData.icon
			}
		}
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
