import QtQuick

ListView{
	add:Transition{
		NumberAnimation{property:'scale';from:.5;to:1;easing.type:Easing.OutCubic}
		NumberAnimation{property:'opacity';to:1;easing.type:Easing.OutCubic}
	}
	displaced:Transition{
		NumberAnimation{properties:'x,y';easing.type:Easing.OutCubic}
	}
	remove:Transition{
		NumberAnimation{property:'scale';to:.5;easing.type:Easing.OutCubic}
		NumberAnimation{property:'opacity';to:0;easing.type:Easing.OutCubic}
	}
}
