import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pam
import qs.config
import qs.singletons
import qs.components
import qs.components.widgets
import qs.components.prog
import qs.modules.bar

Scope{
	id:root
	property string msg:''
	property bool focus:true
	property var inp:[]
	WlSessionLock{
		id:lock
		WlSessionLockSurface{
			color:'#222'
			WallpaperImage{}
			Item{
				anchors{top:parent.top;left:parent.left;right:parent.right;margins:4}
				height:BarConf.height
				Center{
					anchors.centerIn:parent
				}
			}
			FlexboxLayout{
				id:center
				anchors.centerIn:parent
				direction:FlexboxLayout.Column
				alignItems:FlexboxLayout.AlignCenter
				gap:4
					
				ClippingWrapperRectangle {
					implicitHeight:128
					implicitWidth:implicitHeight
					radius:implicitHeight/3
					Image{
						anchors.fill:parent
						source:Quickshell.env('HOME')+'/.face'
					}
				}
				ProgInput{
					id:inp
					placeholderText:root.msg
					value:input.focus
					input{
						focus:root.focus
						activeFocusOnPress:false
						opacity:root.focus?1:.5
						echoMode:TextInput.Password
						inputMethodHints:Qt.ImhHiddenText
						onAccepted:pam.responseRequired&&(
							pam.respond(input.text),
							root.msg='...',
							root.focus=false
						)
						Keys.onPressed:e=>e.key==Qt.Key_Escape&&(input.clear(),e.accepted=true)
						Component.onCompleted:root.inp.push(input)
						Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
					}
				}
			}
			FlexboxLayout{
				direction:FlexboxLayout.Column
				alignItems:FlexboxLayout.AlignCenter
				gap:center.gap
				anchors{
					top:center.bottom
					horizontalCenter:center.horizontalCenter
					margins:center.gap
				}
				WidMpris{
					implicitHeight:inp.implicitHeight
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
				root.focus=true,
				root.msg=':(',
				root.inp.forEach(x=>x.clear())
			),
			[PamResult.MaxTries]:_=>root.msg='max reached',
			[PamResult.Error]:_=>_
		}[e])()
	}
	IpcHandler{
		target:'lock'
		function exec():void{lock.locked=true;pam.start();root.focus=true;root.msg=Quickshell.env('USER');}
	}
}
