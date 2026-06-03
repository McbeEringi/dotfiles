import QtQuick

Behavior{
	id:root
	property Item fadeTarget:targetProperty.object
	SequentialAnimation{
		NumberAnimation{target:root.fadeTarget;property:'opacity';to:0;easing.type:Easing.InQuad}
		PropertyAction{}
		NumberAnimation{target:root.fadeTarget;property:'opacity';to:1;easing.type:Easing.InQuad}
	}
}
