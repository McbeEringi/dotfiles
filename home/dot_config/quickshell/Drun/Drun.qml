import QtQuick
import Quickshell
import Quickshell.Io

Scope{
	LazyLoader{
		id:drun
		FloatingWindow{
			title:'drun'
			TextInput{
				id:input
				anchors{
					left:parent.left
					right:parent.right
					top:parent.top
				}
				focus:true
			}
			ListView{
				clip:true
				anchors{
					left:parent.left
					right:parent.right
					top:input.bottom
					bottom:parent.bottom
				}
				model:DesktopEntries.applications.values.filter(x=>new RegExp(input.text,'i').test(x.name))
				delegate:Text{
					required property var modelData
					width:parent.width
					text:modelData.name
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
