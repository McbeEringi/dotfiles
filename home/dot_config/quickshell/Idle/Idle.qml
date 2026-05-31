import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Scope{
	IdleMonitor{id:mon;timeout:10}
	Process{running:mon.isIdle;command:`brightnessctl -s -e2 s 10%-`.split(' ')}
	Process{running:!mon.isIdle;command:`brightnessctl -r`.split(' ')}
	IdleMonitor{id:sleep;timeout:120}
	Process{running:sleep.isIdle;command:`systemctl suspend`.split(' ')}
}
