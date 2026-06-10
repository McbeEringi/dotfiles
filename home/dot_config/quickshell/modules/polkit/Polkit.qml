import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Polkit
import qs.config
import qs.components.prog

Scope{
	LazyLoader{
		activeAsync:pka.isActive
		FloatingWindow{
			title:'polkit'
			implicitWidth:p.implicitWidth
			implicitHeight:p.implicitHeight
			color:ZabConf.bgColorOpaque
			onClosed:pka.flow.cancelAuthenticationRequest()
			// Item{
			// 	id:wrap
				// gap:4
				// alignItems:FlexboxLayout.AlignCenter
				// justifyContent:FlexboxLayout.JustifyCenter
				// direction:FlexboxLayout.Column
				// Text{
				// 	Layout.fillWidth:true
				// 	text:pka.flow?.message??''
				// 	color:ZabConf.textColor
				// 	wrapMode:Text.Wrap
				// 	horizontalAlignment:Text.AlignHCenter
				// 	font{
				// 		family:ZabConf.fontFamily
				// 		pointSize:ZabConf.fontSize
				// 	}
				// }
				// Text{
				// 	Layout.fillWidth:true
				// 	visible:pka.flow?.supplementaryMessage.trim()??false
				// 	text:pka.flow?.supplementaryMessage??''
				// 	color:ZabConf.textColor
				// 	wrapMode:Text.Wrap
				// 	horizontalAlignment:Text.AlignHCenter
				// 	font{
				// 		family:ZabConf.fontFamily
				// 		pointSize:ZabConf.fontSize
				// 	}
				// }
			Item{
				id:p
				implicitHeight:c*2
				implicitWidth:implicitHeight
				anchors.centerIn:parent
				FontMetrics{
					id:fm
					font{
						family:ZabConf.fontFamily
						pointSize:ZabConf.fontSize
					}
				}
				property var msg:[...(pka.flow?.message??'')+'    '].reduce((a,x,i,{length:l})=>(
					x={char:x,width:fm.advanceWidth(a.prev+x)-fm.advanceWidth(a.prev),position:a.width},
					a.values.push(x),
					a.prev=x.char,
					a.width+=x.width,
					a
				),{width:0,values:[],prev:''})
				property real r:msg.width/Math.PI/2+fm.font.pointSize
				property real c:r+fm.font.pointSize*2
				Repeater{
					model:p.msg.values
					Text{
						required property var modelData
						property real t:modelData.position/p.msg.width*Math.PI*2
						text:modelData.char
						x:p.r*Math.cos(t)+p.c-width/2
						y:p.r*Math.sin(t)+p.c-height/2
						rotation:t/Math.PI*180+90
						color:ZabConf.textColor
						font:fm.font
					}
				}
				NumberAnimation on rotation{
					running:true
					loops:Animation.Infinite
					from:0;to:-360
					duration:p.width*100
				}
			}
			ProgInput{
				anchors.centerIn:parent
				implicitWidth:Math.min(Math.max(contentWidth,placeholderWidth*placeholderVisible),(p.r-fm.font.pointSize)*2)
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
