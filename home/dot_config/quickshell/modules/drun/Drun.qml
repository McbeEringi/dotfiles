import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.components

Scope{
	LazyLoader{
		id:root
		MenuWindow{
			window.title:'drun'
			model:DesktopEntries.applications.values.map(x=>Object.assign(x.name,{x})).sort().map(x=>x.x)
			onClosed:root.activeAsync=false
			onActivated:x=>(
				Quickshell.execDetached({
					command:x.runInTerminal?['gnome-terminal',...x.command]:x.command,
					workingDirectory:x.workingDirectory,
				}),
				root.activeAsync=false
			)
		}
	}

	IpcHandler {
		target:"drun"
		function exec():void{root.activeAsync=true}
	}
}
