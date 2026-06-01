import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Pam
import "Singletons"
import "Components"
import "../Bar"

Scope{
	id:root
	property string msg:''
	property bool focus:true
	property var inp:[]
	WlSessionLock{
		id:lock
		WlSessionLockSurface{
			color:'#222'
			Image{
				anchors.fill:parent
				autoTransform:true
				fillMode:Image.PreserveAspectCrop
				source:Quickshell.env('HOME')+'/.wallpaper'
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
				gap:4
					
				ClippingWrapperRectangle {
					implicitHeight:128
					implicitWidth:implicitHeight
					radius:implicitHeight/3
					Image{
						// implicitSize:64
						anchors.fill:parent
						source:Quickshell.env('HOME')+'/.face'
					}
				}
				Rectangle{
					implicitWidth:Math.max(
						(ph.contentWidth+ph.contentHeight)*!inp.text,
						inp.contentWidth+inp.contentHeight
					)+12
					implicitHeight:inp.contentHeight+12
					color:'#99222222'
					border{
						color:inp.focus?'#cc66ccaa':'#66aaaaaa'
						width:4
					}
					radius:12
					Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}
					Behavior on border.color{ColorAnimation{easing.type:Easing.OutCubic}}
					Item{
						anchors.fill:parent
						opacity:!inp.text*.5
						Text{
							id:ph
							anchors.centerIn:parent
							text:pam.messageIsError?pam.message:root.msg
							color:'#fff'
							font.family:'monospace'
							FadeBehavior on text{}
						}
					}
					TextInput{
						id:inp
						anchors.centerIn:parent
						focus:root.focus
						activeFocusOnPress:false
						color:'#fff'
						opacity:focus?1:.5
						echoMode:TextInput.Password
						inputMethodHints:Qt.ImhHiddenText
						onAccepted:pam.responseRequired&&(
							pam.respond(text),
							root.msg='...',
							root.focus=false
						)
						Keys.onPressed:e=>e.key==Qt.Key_Escape&&(clear(),e.accepted=true)
						Component.onCompleted:root.inp.push(inp)
						Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
					}
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
