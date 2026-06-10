pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton{
	id:root
	property real total:1
	property real available:1
	property real used:total-available
	property real value:used/total
	property real interval:2000

	Process{
		id:cat
		command:['cat','/proc/meminfo']
		stdout:StdioCollector{
			onStreamFinished:(
				total=text.match(/MemTotal:\s+(\d+)/)[1],
				available=text.match(/MemAvailable:\s+(\d+)/)[1]
			)
		}
	}
	Timer{
		interval:root.interval
		running:true
		repeat:true
		onTriggered:cat.running=true
	}
}
