pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
	id:root
	property var log
	property bool up:false
	function iwctl(){Quickshell.execDetached({command:'gnome-terminal iwctl'.split(' ')});}

	Process{
		id:nctl
		stdout:StdioCollector{
			id:nctlo
			onStreamFinished:_=>root.log=JSON.parse(nctlo.text)
		}
	}
	Process{
		id:ip
		command:'ip -json route show default'.split(' ')
		stdout:StdioCollector{
			id:ipo
			onStreamFinished:x=>(
				x=JSON.parse(ipo.text)[0],
				root.up=!!x,
				x?
					nctl.exec(`networkctl --json=short status ${x.dev}`.split(' ')):
					(root.log=null)
			)
		}
	}
	Process{
		running:true
		command:'journalctl -f -n1 -g DHCP -u systemd-networkd'.split(' ')
		stdout:SplitParser{onRead:e=>ip.running=true}
	}
}
