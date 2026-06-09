pragma Singleton
import QtQml
import QtQuick
import Quickshell
import qs.plte

Singleton{
	function alpha(x:color,a:real):color{return Qt.rgba(x.r,x.g,x.b,a);}
}
