* call this file at start of application
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")


local OutlookApplicationClass, OutlookApplicationObject

* for this example you need install Microsoft.Outlook, this example was tested with Outlook 2013 x64
_screen.kodnet.loadAssemblyFile("C:\Windows\assembly\GAC_MSIL\Microsoft.Office.Interop.Outlook\15.0.0.0__71e9bce111e9429c\Microsoft.Office.Interop.Outlook.dll")

m.OutlookApplicationClass		= _screen.kodnet.getStaticWrapper("Microsoft.Office.Interop.Outlook.ApplicationClass")
m.OutlookApplicationObject		= m.OutlookApplicationClass.construct() 
MESSAGEBOX(m.OutlookApplicationObject.version)
MESSAGEBOX(m.OutlookApplicationObject.ProductCode)