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
import qs.components.prog
import qs.components.circular
import qs.modules.bar

Scope{
	id:root
	property string msg:''
	property bool focus:true
	property var inp:[]
	property real radius:96
	Timer{id:msgclr;interval:2000;onTriggered:root.msg=''}
	onMsgChanged:msgclr.stop()

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
				id:bar
				anchors{top:parent.top;left:parent.left;right:parent.right;margins:ZabConf.gap}
				height:BarConf.height
				BarCenter{id:barcenter;anchors.centerIn:parent}
				BarRight{anchors{left:barcenter.right;right:parent.right}isLockScreen:true}
			}
			// MouseArea{
			// 	anchors.fill:parent
			// 	onClicked:lock.locked=false
			// }

			FlexboxLayout{
				id:center
				anchors{
					left:parent.left
					right:parent.right
					verticalCenter:parent.verticalCenter
				}
				justifyContent:FlexboxLayout.JustifyCenter
				alignItems:FlexboxLayout.AlignCenter
				wrap:FlexboxLayout.Wrap
				gap:ZabConf.gap
					
				Clock{radius:root.radius}
				Rectangle{
					radius:root.radius
					implicitHeight:radius*2
					implicitWidth:implicitHeight
					color:ZabConf.bgColor
					ClippingWrapperRectangle{
						anchors.centerIn:parent
						radius:circle.innerRadius
						implicitHeight:radius*2
						implicitWidth:implicitHeight
						Image{
							anchors.fill:parent
							mipmap:true
							source:Quickshell.env('HOME')+'/.face'
						}
					}
					FlexboxLayout{
						id:circleSrc
						visible:false
						width:root.radius*2*Math.PI
						alignItems:FlexboxLayout.AlignCenter
						Text{
							text:root.msg||Quickshell.env('USER')
							color:ZabConf.textColor
							horizontalAlignment:Text.AlignHCenter
							Layout.preferredWidth:parent.width/2
							renderType:Text.NativeRendering
							font{family:ZabConf.fontFamily;pointSize:ZabConf.fontSize}
							FadeBehavior on text{}
						}
						TextInput{
							id:inp
							rotation:180
							opacity:root.focus?1:.5
							focus:root.focus
							color:ZabConf.textColor
							echoMode:TextInput.Password
							horizontalAlignment:Text.AlignHCenter
							Layout.preferredWidth:parent.width/2
							renderType:Text.NativeRendering
							activeFocusOnPress:false
							inputMethodHints:Qt.ImhHiddenText
							onAccepted:pam.responseRequired&&(
								pam.respond(inp.text),
								root.msg='...',
								root.focus=false
							)
							Keys.onPressed:e=>e.key==Qt.Key_Escape&&(inp.clear(),e.accepted=true)
							Component.onCompleted:root.inp.push(inp)
							selectionColor:ZabConf.cursorColor
							padding:ZabConf.cursorWidth
							clip:true
							cursorDelegate:Item{
								Rectangle{
									width:ZabConf.cursorWidth
									height:parent.height
									radius:width/2
									x:-width/2
									color:ZabConf.cursorColor
								}
								SequentialAnimation on opacity{
									loops:Animation.Infinite
									NumberAnimation{to:0;duration:ZabConf.cursorBlink*500;easing.type:Easing.OutCubic}
									NumberAnimation{to:1;duration:ZabConf.cursorBlink*500;easing.type:Easing.OutCubic}
								}
							}
							font{family:ZabConf.fontFamily;pointSize:ZabConf.fontSize}

							Behavior on opacity{NumberAnimation{easing.type:Easing.OutCubic}}
						}
					}
					Circular{id:circle;srcItem:circleSrc;rotation:-90}
				}
				Repeater{
					model:Mpris.players
					delegate:RecordPlayer{
						required property var modelData
						player:modelData
						radius:root.radius
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
				root.msg=':(',msgclr.start(),
				root.inp.forEach(x=>x.clear())
			),
			[PamResult.MaxTries]:_=>root.msg='max reached',
			[PamResult.Error]:_=>_
		}[e])()
	}
	IpcHandler{
		target:'lock'
		function exec():void{lock.locked=true;pam.start();root.focus=true;root.msg='';}
	}
}
