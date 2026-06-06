import Quickshell
import Quickshell.Io
import qs.modules.menu

Scope{
	Process{id:proc}
	MenuWindow{
		id:root
		title:'exit'
		model:[
			{name:'lock',icon:'system-lock-screen-symbolic',exec:_=>proc.exec({command:'qs ipc call lock exec'.split(' ')})},
			{name:'dpms',icon:'display-brightness-symbolic',exec:_=>_},
			{name:'suspend',icon:'system-suspend-symbolic',exec:_=>proc.exec({command:'systemctl suspend'.split(' ')})},
			{name:'hibernate',icon:'system-hibernate-symbolic',exec:_=>_},
			{name:'exit',icon:'system-log-out-symbolic',exec:_=>proc.exec({command:'loginctl terminate-session self'.split(' ')})},
			{name:'kexec',icon:'system-reboot-symbolic',exec:_=>proc.exec({command:'pkexec systemctl kexec'.split(' ')})},
			{name:'reboot',icon:'system-reboot-symbolic',exec:_=>proc.exec({command:'reboot'.split(' ')})},
			{name:'poweroff',icon:'system-shutdown-symbolic',exec:_=>proc.exec({command:'systemctl poweroff'.split(' ')})}
		]
	}

	IpcHandler{
		target:'exit'
		function exec():void{root.show();}
	}
}
