import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pam
import Quickshell.Services.Mpris
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
			color:ZabConf.bgColorOpaque
			MultiEffect{
				id:effect
				anchors.fill:parent
				blurEnabled:true
				blur:1
				source:WallpaperImage{width:effect.width;height:effect.height}
			}
			Loader{
				anchors.fill:parent
				active:BarConf.backgroundEnabled
				sourceComponent:BarBackground{}
			}
			Item{
				anchors{top:parent.top;left:parent.left;right:parent.right;margins:ZabConf.gap}
				height:BarConf.height
				BarCenter{id:barcenter;anchors.centerIn:parent}
				BarRight{anchors{left:barcenter.right;right:parent.right}isLockScreen:true}
			}
			FlexboxLayout{
				id:center
				anchors.centerIn:parent
				direction:FlexboxLayout.Column
				alignItems:FlexboxLayout.AlignCenter
				gap:ZabConf.gap
					
				ClippingWrapperRectangle{
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
			ListView{
				anchors{
					top:center.bottom
					horizontalCenter:center.horizontalCenter
					margins:center.gap
				}
				width:parent.width
				model:Mpris.players
				delegate:ProgText{
					required property var modelData
					anchors.horizontalCenter:parent.horizontalCenter
					text:modelData.trackTitle
					implicitHeight:inp.implicitHeight
					implicitWidth:Math.min(Math.max(contentWidth,implicitHeight),implicitHeight*4)
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
