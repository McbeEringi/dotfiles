import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Scope{
	LazyLoader{
		id:root
		property real gap:4
		FloatingWindow{
			title:'drun'
			implicitHeight:256
			implicitWidth:256
			color:'#222'
			FlexboxLayout{
				anchors{
					fill:parent
					margins:root.gap
					bottomMargin:0
				}
				direction:FlexboxLayout.Column
				// alignContent:FlexboxLayout.AlignStretch
				alignItems:FlexboxLayout.AlignCenter
				gap:root.gap
				TextInput{
					id:input
					focus:true
					color:'#fff'
					onAccepted:console.log('accepted')
					font.family:'monospace'
				}
				ListView{
					clip:true
					Layout.fillHeight:true
					width:parent.width
					// spacing:4
					model:DesktopEntries.applications.values.filter(x=>new RegExp(input.text,'i').test(x.name))
					delegate:FlexboxLayout{
						required property var modelData
						width:parent.width
						alignItems:FlexboxLayout.AlignCenter
						gap:root.gap
						IconImage{
							implicitSize:28
							source:Quickshell.iconPath(modelData.icon)
						}
						Text{
							text:modelData.name
							color:'#fff'
							font.family:'monospace'
						}
					}
					highlight:Rectangle{color:'#66aaaaaa';radius:12-4-root.gap}
				}
			}
			onClosed:_=>root.activeAsync=false
	  }
  }

	IpcHandler {
		target:"drun"
		function exec():void{root.activeAsync=true}
	}
}
