import Quickshell
import Quickshell.Io
import qs.modules.menu

Scope{
	MenuWindow{
		id:root
		title:'drun'
		preventSortOnEmpty:false
		model:DesktopEntries.applications.values.map(x=>Object.assign(x.name,{x:{
			name:x.name,icon:x.icon,
			exec:_=>Quickshell.execDetached({
				command:x.runInTerminal?['gnome-terminal',...x.command]:x.command,
				workingDirectory:x.workingDirectory,
			})
		}})).sort().map(x=>x.x)
	}

	IpcHandler{
		target:'drun'
		function exec():void{root.show();}
	}
}
