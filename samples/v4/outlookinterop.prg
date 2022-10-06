* IN YOUR APP PUT THIS LINES AT STARTUP
* do (getenv("Userprofile") + "\kwruntime\kodnet\loader.prg")
* _screen.kodnetLoader.load("v4")

if type("_screen.kodnetLoader.v4") == "U" or  isnull(_screen.kodnetLoader.v4)
	* Execute init.prg
	MESSAGEBOX("Por favor ejecute el archivo init.prg primero. (Please execute first init.prg)", 64, "")
	return 
endif 


local kodnet 
kodnet = _Screen.kodnetLoader.v4

local OutlookApplicationClass, OutlookApplicationObject

* for this example you need install Microsoft.Outlook, this example was tested with Outlook 2013 x64
_screen.kodnet.loadAssemblyFile("C:\Windows\assembly\GAC_MSIL\Microsoft.Office.Interop.Outlook\15.0.0.0__71e9bce111e9429c\Microsoft.Office.Interop.Outlook.dll")

m.OutlookApplicationClass		= m.kodnet.COM.getStaticWrapper("Microsoft.Office.Interop.Outlook.ApplicationClass")
m.OutlookApplicationObject		= m.OutlookApplicationClass.construct() 
MESSAGEBOX(m.OutlookApplicationObject.version)
MESSAGEBOX(m.OutlookApplicationObject.ProductCode)