pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
	id:root
	property real value:0
	property string device:''
	property string args:'-e2'

	Process{id:proc}
	Process{
		id:getbri
		running:true
		command:`brightnessctl -m ${root.args}`.split(' ')
		stdout:StdioCollector{
			onStreamFinished:(a=>(
				root.device||(root.device=a[0]),
				!watcher.path&&root.device&&(
					watcher.path=`/sys/class/backlight/${root.device}/brightness`
				),
				root.value=(+(a[3]?.slice(0,-1)??-1))/100
			))(text.split(','))
		}
	}
	FileView{id:watcher;watchChanges:true;onFileChanged:getbri.running=true}

	property var set:d=>d&&proc.exec({
		command:`brightnessctl ${root.args} s ${Math.abs(d)}%${0<Math.sign(d)?'+':'-'}`.split(' ')
	})
}
