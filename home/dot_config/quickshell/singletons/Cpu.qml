pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
	id:root
	property real value:0
	property real interval:2000

	Process{
		property real prev_total:0
		property real prev_idle:0
		id:cat
		command:['cat','/proc/stat']
		stdout:StdioCollector{
			onStreamFinished:(w=>(
				// w=(text.match(/^.+$/mg)??[]).reduce((a,x)=>(x=x.match(/\S+/g),a[x[0]]=x.slice(1),a),{}),
				w={cpu:text.split('\n')[0].slice(5).split(/\s+/)},
				w={idle:+w.cpu[3],total:w.cpu.reduce((a,x)=>+x+a,0)},
				root.value=1-(w.idle-cat.prev_idle)/(w.total-cat.prev_total),
				{idle:cat.prev_idle,total:cat.prev_total}=w
			))()
		}
	}
	Timer{
		interval:root.interval
		running:true
		repeat:true
		onTriggered:cat.running=true
	}
}
