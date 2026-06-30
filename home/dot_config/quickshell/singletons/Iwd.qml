pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
	id:root
	property var log
	property bool up:log?.new=='connected'
	function iwctl(){Quickshell.execDetached({command:'gnome-terminal iwctl'.split(' ')});}

	Process{
		running:true
		command:'journalctl -f -b -g event -u iwd'.split(' ')
		stdout:SplitParser{
			onRead:e=>root.log=Object.assign(
				{},root.log,
				e.match(/iwd\[\d+\]:\s*(.*)$/)?.[1].split(/,\s*/).reduce((a,x)=>(x=x.split(/:\s*/,2),a[x[0]]=x[1],a),{})
			)
		}
	}
}
