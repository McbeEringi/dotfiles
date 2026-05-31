import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope{
	LazyLoader{
		id:drun
		FloatingWindow{
			title:'drun'
			implicitHeight:256
			implicitWidth:256
			color:'#222'
			FlexboxLayout{
				anchors{
					fill:parent
					margins:4
					bottomMargin:0
				}
				direction:FlexboxLayout.Column
				// alignContent:FlexboxLayout.AlignStretch
				alignItems:FlexboxLayout.AlignCenter
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
					model:DesktopEntries.applications.values.filter(x=>new RegExp(input.text,'i').test(x.name))
					delegate:Text{
						required property var modelData
						width:parent.width
						text:modelData.name
						color:'#fff'
						font.family:'monospace'
					}
					highlight:Rectangle{
						color:'#66aaaaaa'
					}
				}
			}
			onClosed:_=>drun.activeAsync=false
	  }
  }

	IpcHandler {
		target:"drun"
		function exec():void{drun.activeAsync=true}
	}
}
