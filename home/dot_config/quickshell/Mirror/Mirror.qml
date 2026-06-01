import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope{
	property var cli:new Set()
	Component{
		id:win
		FloatingWindow{
			id:self
			required property var name
			title:'mirror'
			color:'#222'
			// fullscreen:true
			onClosed:_=>cli.delete(self)
			ScreencopyView{
				anchors.fill:parent
				live:true
				paintCursor:true
				captureSource:Quickshell.screens.find(x=>x.name.includes(name))
			}
		}
	}
	IpcHandler{
		target:"mirror"
		function exec(name:string):void{cli.add(win.createObject(null,{name}));}
	}
}

