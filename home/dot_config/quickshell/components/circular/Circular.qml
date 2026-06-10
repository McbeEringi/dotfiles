import QtQml
import QtQuick
import qs.config

ShaderEffect{
	id:root
	property string text:''
	implicitHeight:txt.width/Math.PI
	implicitWidth:implicitHeight
	property var source:ShaderEffectSource{
		sourceItem:Text{
			id:txt
			text:root.text
			color:ZabConf.textColor
			renderType:Text.NativeRendering
			font{
				family:ZabConf.fontFamily
				pointSize:ZabConf.fontSize
			}
		}
	}
	property real ratio:txt.height/txt.width
	mesh:GridMesh{resolution:Qt.size(256,1)}
	vertexShader:Qt.resolvedUrl('circular.vert.qsb')
}
