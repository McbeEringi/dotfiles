import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import qs.singletons

Scope{
	IdleMonitor{
		id:mon
		timeout:30
		property real min:.05
		property real mem:0
		onIsIdleChanged:_=>mon.isIdle?
			min<Brightness.value&&(mem=Brightness.value,Brightness.set(Math.max(mem-.1,min))):
			mem&&(Brightness.set(mem),mem=0)
	}
	IdleMonitor{id:lock;timeout:120}
	Process{running:lock.isIdle;command:`qs ipc call lock exec`.split(' ')}
	IdleMonitor{id:sleep;timeout:300}
	Process{
		running:sleep.isIdle
		command:`systemctl suspend`.split(' ')
		// command:[`dpms`]
	}
}
