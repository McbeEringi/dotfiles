import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Services.Pam
import "Singletons"
import "Components"
import "../Bar"

Scope{
	id:root
	property string msg:''
	property bool focus:true
	WlSessionLock{
		id:lock
		WlSessionLockSurface{
			color:'#222'
			Image{
				anchors.fill:parent
				autoTransform:true
				fillMode:Image.PreserveAspectCrop
				source:Qt.resolvedUrl('../Wallpaper/wp')
			}
			Item{
				anchors{top:parent.top;left:parent.left;right:parent.right;margins:4}
				height:28
				Center{
					anchors.centerIn:parent
				}
			}
			FlexboxLayout{
				anchors.centerIn:parent
				direction:FlexboxLayout.Column
				alignItems:FlexboxLayout.AlignCenter
				TextZabuton{implicitHeight:28;text:msg}
				Text{visible:pam.messageIsError;text:pam.message;color:'#fff'}
				TextInput{
					focus:root.focus
					anchors.centerIn:parent
					activeFocusOnPress:false
					color:'#fff'
					echoMode:TextInput.Password
					inputMethodHints:Qt.ImhHiddenText
					onAccepted:pam.responseRequired&&(
						pam.respond(text),
						root.msg='...',
						root.focus=false
					)
					Keys.onPressed:e=>e.key==Qt.Key_Escape&&(text='',e.accepted=true)
				}
			}
		}
	}
	PamContext{
		id:pam
		onCompleted:e=>({
			[PamResult.Success]:_=>(root.msg='',lock.locked=false),
			[PamResult.Failed]:_=>(
				pam.start(),
				root.msg=':(',
				root.focus=true
			),
			[PamResult.MaxTries]:_=>msg='max reached',
			[PamResult.Error]:_=>_
		}[e])()
	}
	IpcHandler{
		target:'lock'
		function exec():void{lock.locked=true;pam.start();root.focus=true;}
	}
}
