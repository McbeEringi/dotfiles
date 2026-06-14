////@ pragma UseQApplication
//@ pragma AppId 6ca-shell
import Quickshell
import qs.modules.bar
import qs.modules.idle
import qs.modules.wallpaper
import qs.modules.menu.drun
import qs.modules.menu.exit
import qs.modules.mirror
import qs.modules.polkit
import qs.modules.lock
import qs.modules.notify

ShellRoot{
	Bar{}
	Idle{}
	Wallpaper{}
	Drun{}
	Exit{}
	Mirror{}
	Polkit{}
	Lock{}
	Notify{}
}
