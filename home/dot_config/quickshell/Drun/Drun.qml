import QtQml
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

Scope{
	LazyLoader{
		id:root
		property real gap:4
		FloatingWindow{
			title:'drun'
			implicitHeight:320
			implicitWidth:320
			color:'#222'
			FlexboxLayout{
				anchors{
					fill:parent
					margins:root.gap
					bottomMargin:0
				}
				direction:FlexboxLayout.Column
				// alignContent:FlexboxLayout.AlignStretch
				alignItems:FlexboxLayout.AlignCenter
				gap:root.gap
				TextInput{
					id:input
					focus:true
					color:'#fff'
					font.family:'monospace'
					Keys.onPressed:e=>(f=>(
						f&&(f(),e.accepted=true)
					))({
						[Qt.Key_Down]:_=>list.currentIndex<list.count-1&&list.currentIndex++,
						[Qt.Key_Up]:_=>list.currentIndex&&list.currentIndex--,
						[Qt.Key_Escape]:_=>root.activeAsync=false,
						[Qt.Key_Return]:x=>(
							x=list.currentItem.modelData,
							Quickshell.execDetached({
								command:x.runInTerminal?['gnome-terminal',...x.command]:x.command,
								workingDirectory:x.workingDirectory,
							}),
							root.activeAsync=false
						)
					}[e.key])
				}
				ListView{
					id:list
					clip:true
					Layout.fillHeight:true
					width:parent.width
					// spacing:4
					model:DesktopEntries.applications.values.filter(x=>x.name.toLowerCase().includes(input.text.toLowerCase()))
					delegate:FlexboxLayout{
						required property var modelData
						width:parent.width
						alignItems:FlexboxLayout.AlignCenter
						gap:root.gap
						IconImage{
							implicitSize:28
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
			onClosed:_=>root.activeAsync=false
		}
	}

	IpcHandler {
		target:"drun"
		function exec():void{root.activeAsync=true}
	}
}
