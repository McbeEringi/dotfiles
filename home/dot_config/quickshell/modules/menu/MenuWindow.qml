import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config

LazyLoader{
	id:root
	property real gap:ZabConf.borderWidth
	property real opacityFactor:.8
	property string title:''
	property real implicitWidth:320
	property real implicitHeight:320
	property color bgColor:ZabConf.bgColorOpaque
	required property var model
	property real iconSize:28
	property bool preventSortOnEmpty:true

	function show(){root.activeAsync=true;}

	FloatingWindow{
		id:win
		title:'menu-'+root.title
		implicitHeight:root.implicitHeight
		implicitWidth:root.implicitWidth
		color:root.bgColor
		onClosed:root.activeAsync=false
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
				color:ZabConf.textColor
				font.family:ZabConf.fontFamily
				Keys.onPressed:e=>(f=>(
					f&&(f(),e.accepted=true)
				))({
					[Qt.Key_Down]:_=>list.currentIndex<list.count-1&&list.currentIndex++,
					[Qt.Key_Up]:_=>list.currentIndex&&list.currentIndex--,
					[Qt.Key_Escape]:_=>root.activeAsync=false,
					[Qt.Key_Return]:_=>(list.currentItem.modelData.exec?.(),root.activeAsync=false)
				}[e.key])
			}
			ListView{
				id:list
				clip:true
				Layout.fillHeight:true
				Layout.fillWidth:true
				model:!input.text&&root.preventSortOnEmpty?
				root.model.map(x=>Object.assign(x,{score:1})):
				root.model.map(x=>Object.assign(x,{score:(
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
						source:Quickshell.iconPath(modelData.icon,true)
					}
					Text{
						text:modelData.name
						color:ZabConf.textColor
						font.family:ZabConf.fontFamily
						Layout.fillWidth:true
						elide:Text.ElideRight
					}
				}
				highlight:Rectangle{color:ZabConf.borderColor;radius:ZabConf.radius-ZabConf.borderWidth-root.gap}
			}
		}
	}
}
