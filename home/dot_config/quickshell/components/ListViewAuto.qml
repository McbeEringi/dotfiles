import QtQuick

Item{
	required property var model
	required property Component delegate
	property int orientation:ListView.Horizontal
	property real spacing:0

	implicitHeight:orientation==ListView.Horizontal?parent.implicitHeight:lv.contentItem.childrenRect.height
	implicitWidth: orientation==ListView.Horizontal?lv.contentItem.childrenRect.width:parent.implicitWidth
	Behavior on implicitHeight{NumberAnimation{easing.type:Easing.OutCubic}}
	Behavior on implicitWidth{NumberAnimation{easing.type:Easing.OutCubic}}

	ListView{
		id:lv
		model:parent.model
		delegate:parent.delegate
		// interactive:false
		flickableDirection:Flickable.AutoFlickIfNeeded
		spacing:parent.spacing
		orientation:parent.orientation
		implicitHeight:orientation==ListView.Horizontal?parent.implicitHeight:parent.parent.height
		implicitWidth:orientation==ListView.Horizontal?parent.parent.width:parent.implicitWidth

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
}
