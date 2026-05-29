import Quickshell
import Quickshell.Wayland
import Quickshell.Io

Scope{
	IdleMonitor{id:mon;timeout:5}
	Process{running:mon.isIdle;command:`brightnessctl -s -e2 s 10%-`.split(' ')}
	Process{running:!mon.isIdle;command:`brightnessctl -r`.split(' ')}
}
