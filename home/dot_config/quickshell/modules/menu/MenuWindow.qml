import QtQml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.components.zab

LazyLoader{
	id:root
	property real gap:ZabConf.borderWidth
	property real opacityFactor:.8
	property string title:''
	property real implicitWidth:640
	property real implicitHeight:480
	property color bgColor:ZabConf.bgColorOpaque
	property real innerRadius:ZabConf.radius-ZabConf.borderWidth-gap
	required property var model
	property real cellSize:80
	property bool preventSortOnEmpty:true

	function show(){root.activeAsync=true;}

	FloatingWindow{
		id:win
		title:'menu-'+root.title
		implicitHeight:root.implicitHeight
		implicitWidth:root.implicitWidth
		color:root.bgColor
		onClosed:root.activeAsync=false
		function exec(){list.currentItem?.modelData.exec?.();root.activeAsync=false;}
		FlexboxLayout{
			anchors{
				fill:parent
				margins:root.gap
			}
			direction:FlexboxLayout.Column
			gap:root.gap
			ZabInput{
				id:input
				placeholderText:root.title+'...'
				Layout.fillWidth:true
				radius:root.innerRadius
				z:1
				input{
					focus:true
					Keys.onPressed:e=>(f=>(
						f&&(f(),e.accepted=true)
					))({
						[Qt.Key_Down]:_=>list.currentIndex<list.count-1&&list.currentIndex++,
						[Qt.Key_Up]:_=>list.currentIndex&&list.currentIndex--,
						[Qt.Key_Escape]:_=>root.activeAsync=false,
						[Qt.Key_Return]:win.exec
					}[e.key])
				}
			}
			GridView{
				id:list
				displayMarginBeginning:parent.height-height+root.gap
				displayMarginEnd:root.gap
				ScrollBar.vertical:ScrollBar{}
				highlightMoveDuration:200
				// highlightMoveVelocity:-1
				cellHeight:width/Math.ceil(width/root.cellSize)
				cellWidth:cellHeight
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
				delegate:MouseArea{
					required property var modelData
					required property int index
					height:list.cellHeight
					width:list.cellWidth
					onPressed:list.currentIndex=index
					onDoubleClicked:_=>win.exec()
					FlexboxLayout{
						anchors.fill:parent
						alignItems:FlexboxLayout.AlignCenter
						justifyContent:FlexboxLayout.JustifySpaceAround
						direction:FlexboxLayout.Column
						gap:root.gap
						opacity:modelData.score*root.opacityFactor+(1-root.opacityFactor)
						IconImage{
							implicitSize:list.cellHeight*.5
							source:Quickshell.iconPath(modelData.icon,true)
						}
						Text{
							text:modelData.name
							verticalAlignment:Text.AlignVCenter
							horizontalAlignment:Text.AlignHCenter
							color:ZabConf.textColor
							font.family:ZabConf.fontFamily
							Layout.fillWidth:true
							elide:Text.ElideRight
						}
					}
				}
				highlight:Rectangle{color:ZabConf.borderColor;radius:root.innerRadius}
			}
		}
		ZabText{
			anchors{
				bottom:parent.bottom
				right:parent.right
				margins:root.gap
			}
			opacity:text?1:0
			Behavior on opacity{NumberAnimation{duration:500;easing.type:Easing.OutCubic}}
			text:list.currentItem?.modelData.name??''
			radius:root.innerRadius
		}
	}
}
