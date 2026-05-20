import Quickshell
import QtQuick

Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 16
			color:"#88222222"

			Text {
				anchors.centerIn: parent
				text: Time.time
				color: "#fff"
				font.family: "monospace"
			}
    }
  }
}
