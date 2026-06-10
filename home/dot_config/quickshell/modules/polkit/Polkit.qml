import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Polkit
import qs.config
import qs.components.prog
import qs.components.circular

Scope{
	LazyLoader{
		activeAsync:pka.isActive
		FloatingWindow{
			title:'polkit'
			implicitWidth:p.implicitWidth+ZabConf.gap*2
			implicitHeight:p.implicitHeight+ZabConf.gap*2
			color:ZabConf.bgColorOpaque
			onClosed:pka.flow.cancelAuthenticationRequest()
			Circular{
				id:p
				anchors.centerIn:parent
				text:(pka.flow?.message??'')+' '.repeat(8)
				NumberAnimation on rotation{
					running:true;loops:Animation.Infinite
					from:0;to:-360
					duration:Math.max(p.implicitHeight*100,1)
				}
			}
			ProgInput{
				anchors.centerIn:parent
				implicitWidth:Math.min(Math.max(contentWidth,placeholderWidth*placeholderVisible),p.innerRadius*2)
				placeholderText:pka.flow?.inputPrompt.trim()??''
				fontSize:ZabConf.fontSize*1.5
				value:1//(input.text,Math.random()*.8+.1)
				// offset:(input.text,Math.random())
				// parts:(input.text,[2,3,4][Math.random()*3|0])
				// Behavior on offset{NumberAnimation{easing.type:Easing.OutCubic}}
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
	PolkitAgent{id:pka}
}
