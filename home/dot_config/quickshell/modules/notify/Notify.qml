import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import qs.config
import qs.components

Scope{
	Variants{
		model:Quickshell.screens
		PanelWindow{
			required property var modelData
			screen:modelData
			WlrLayershell.namespace:'notify'
			anchors{top:true;right:true}
			implicitWidth:240//list.contentWidth
			implicitHeight:screen.height/2//list.contentHeight
			mask:Region{item:list.contentItem}
			color:'transparent'
			
			AnmListView{
				id:list
				anchors{
					fill:parent
					margins:ZabConf.gap
				}
				spacing:ZabConf.gap
				model:notify.trackedNotifications
				delegate:NotifyWidget{
					required property var modelData
					notify:modelData
				}
			}
		}
	}
	NotificationServer{
		id:notify
		// bodyImagesSupported:true
		imageSupported:true
		actionsSupported:true
		onNotification:e=>e.tracked=true
	}
}
