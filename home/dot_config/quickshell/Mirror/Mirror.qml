import Quickshell
import Quickshell.Io
import Quickshell.Wayland


Scope{
	LazyLoader{
		id:root
		property string name:''
		FloatingWindow{
			title:'mirror'
			color:'#222'
			fullscreen:true
			onClosed:_=>root.activeAsync=false
			ScreencopyView{
				anchors.fill:parent
				live:true
				paintCursor:true
				captureSource:Quickshell.screens.find(x=>x.name.includes(root.name))
			}
		}
	}

	IpcHandler {
		target:"mirror"
		function exec(name:string):void{root.name=name;root.activeAsync=true}
	}
}
