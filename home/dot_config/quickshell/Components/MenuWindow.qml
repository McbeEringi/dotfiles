import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Scope{
		id:root
		property real gap:4
		property real opacityFactor:.8
		property alias window:win
		required property var model
		property real iconSize:28

		signal closed()
		signal activated(var x)
		FloatingWindow{
			id:win
			title:'menu'
			implicitHeight:320
			implicitWidth:320
			color:'#222'
			onClosed:root.closed()
			FlexboxLayout{
				anchors{
					fill:parent
					margins:root.gap
					bottomMargin:0
				}
				direction:FlexboxLayout.Column
				gap:root.gap
				TextInput{
					id:input
					focus:true
					Layout.fillWidth:true
					horizontalAlignment:TextInput.AlignHCenter
					color:'#fff'
					font.family:'monospace'
					Keys.onPressed:e=>(f=>(
						f&&(f(),e.accepted=true)
					))({
						[Qt.Key_Down]:_=>list.currentIndex<list.count-1&&list.currentIndex++,
						[Qt.Key_Up]:_=>list.currentIndex&&list.currentIndex--,
						[Qt.Key_Escape]:_=>root.closed(),
						[Qt.Key_Return]:_=>root.activated(list.currentItem.modelData)
					}[e.key])
				}
				ListView{
					id:list
					clip:true
					Layout.fillHeight:true
					Layout.fillWidth:true
					// spacing:root.gap
					model:root.model.map(x=>Object.assign(x,{score:(
						x.name.toLowerCase().split(/[-_:;,.\/\s]+/).reduce((a,x,i,{length:l})=>(
							a+input.text.toLowerCase().split(/\s+/).reduce((b,y,j,{length:l})=>(
								b+(x.startsWith(y)?1:x.includes(y)?.5:0)*(l-j)/l
							),0)/(i+1)/l
						),0)
					)})).filter(x=>x.score).sort((a,b)=>b.score-a.score)//.filter(x=>x.name.toLowerCase().includes(input.text.toLowerCase()))
					delegate:FlexboxLayout{
						required property var modelData
						width:list.width
						alignItems:FlexboxLayout.AlignCenter
						gap:root.gap
						opacity:modelData.score*root.opacityFactor+(1-root.opacityFactor)
						IconImage{
							implicitSize:root.iconSize
							source:Quickshell.iconPath(modelData.icon)
						}
						Text{
							text:modelData.name
							color:'#fff'
							font.family:'monospace'
							Layout.fillWidth:true
							elide:Text.ElideRight
						}
					}
					highlight:Rectangle{color:'#66aaaaaa';radius:12-4-root.gap}
				}
			}
		}
}
