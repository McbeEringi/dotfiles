import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Polkit

Scope{
	LazyLoader{
		activeAsync:pka.isActive
		FloatingWindow{
			title:'polkit'
			implicitWidth:320
			color:'#222'
			onClosed:pka.flow.cancelAuthenticationRequest()
			FlexboxLayout{
				direction:FlexboxLayout.Column
				Text{text:pka.flow.message;color:'#fff'}
				Text{text:pka.flow.supplementaryMessage;color:'#fff'}
				Text{text:pka.flow.isCompleted;color:'#fff'}
				FlexboxLayout{
					Text{text:pka.flow.inputPrompt;color:'#fff'}
					TextInput{
						focus:true
						color:'#fff'
						echoMode:hov.containsMouse||pka.flow.responseVisible?TextInput.Normal:TextInput.Password
						inputMethodHints:Qt.ImhHiddenText
						onAccepted:pka.flow.submit(text)
						Keys.onPressed:e=>e.key==Qt.Key_Escape&&(text='',e.accepted=true)
						MouseArea{
							anchors.fill:parent
							id:hov
							hoverEnabled:true
						}
					}
				}
			}
		}
	}
	PolkitAgent{id:pka}
}
