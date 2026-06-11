import QtQml
import QtQuick

ShaderEffect{
	id:root
	required property Item srcItem
	property int numVerts:64
	readonly property real innerRadius:implicitHeight/2-srcItem.height
	implicitHeight:srcItem.width/Math.PI
	implicitWidth:implicitHeight
	property var source:ShaderEffectSource{sourceItem:srcItem}
	property real ratio:srcItem.height/srcItem.width*Math.PI*2
	mesh:GridMesh{resolution:Qt.size(numVerts,1)}
	vertexShader:Qt.resolvedUrl('circular.vert.qsb')
}
