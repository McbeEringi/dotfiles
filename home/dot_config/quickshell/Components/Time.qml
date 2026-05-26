pragma Singleton

import Quickshell

Singleton{
	id:root
	readonly property string time:Qt.formatDateTime(clock.date,"yyyy-MM-dd hh:mm")
	SystemClock{
		id:clock
		precision:SystemClock.Minutes
	}
}
