import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Polkit
import "Components"

Scope{
	LazyLoader{
		activeAsync:pka.isActive
		FloatingWindow{
			title:'polkit'
			implicitWidth:480
			implicitHeight:wrap.implicitHeight+4*2
			color:'#222'
			onClosed:pka.flow.cancelAuthenticationRequest()
			FlexboxLayout{
				id:wrap
				anchors{
					fill:parent
					margins:4
				}
				gap:4
				alignItems:FlexboxLayout.AlignCenter
				justifyContent:FlexboxLayout.JustifyCenter
				direction:FlexboxLayout.Column
				Text{
					Layout.fillWidth:true
					text:pka.flow?.message??''
					color:Config.textColor
					wrapMode:Text.Wrap
					horizontalAlignment:Text.AlignHCenter
					font{
						family:Config.fontFamily
						pointSize:Config.fontSize
					}
				}
				Text{
					Layout.fillWidth:true
					visible:pka.flow?.supplementaryMessage.trim()??false
					text:pka.flow?.supplementaryMessage??''
					color:Config.textColor
					wrapMode:Text.Wrap
					horizontalAlignment:Text.AlignHCenter
					font{
						family:Config.fontFamily
						pointSize:Config.fontSize
					}
				}
				ProgInput{
					placeholderText:pka.flow?.inputPrompt??''
					fontSize:Config.fontSize*1.5
					value:(input.text,Math.random()*.8+.1)
					offset:(input.text,Math.random())
					parts:(input.text,[2,3,4][Math.random()*3|0])
					Behavior on offset{NumberAnimation{easing.type:Easing.OutCubic}}
					input{
						focus:true
						echoMode:TextInput[pka.flow?.responseVisible?'Normal':'Password']
						inputMethodHints:Qt.ImhHiddenText
						onAccepted:pka.flow.submit(input.text)
						Keys.onPressed:e=>e.key==Qt.Key_Escape&&(input.text='',e.accepted=true)
					}
				}
			}
		}
	}
	PolkitAgent{id:pka}
}
