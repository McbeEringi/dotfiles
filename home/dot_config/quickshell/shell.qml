import Quickshell
import QtQuick
import QtQuick.Layouts

Scope {

	Variants {
		model: Quickshell.screens

		PanelWindow {
			required property var modelData
			screen:modelData

			anchors {
				top:true
				left:true
				right:true
			}

			implicitHeight:16
			color:"#88222222"

			FlexboxLayout{
				anchors.fill:parent
				justifyContent:FlexboxLayout.JustifySpaceBetween
				Text {
					// anchors.centerIn: parent
					text: Time.time
					color: "#6ca"
					font.family: "monospace"
				}
				Text {
					text: Time.time
					color: "#fff"
					font.family: "monospace"
				}
				Text {
					text: Time.time
					color: "#dd6"
					font.family: "monospace"
				}
			}
		}
	}
}
