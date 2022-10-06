* IN YOUR APP PUT THIS LINES AT STARTUP
* do (getenv("Userprofile") + "\kwruntime\kodnet\loader.prg")
* _screen.kodnetLoader.load("v4")

if type("_screen.kodnetLoader.v4") == "U" || isnull(_screen.kodnetLoader.v4)
	* Execute init.prg
	MESSAGEBOX("Por favor ejecute el archivo init.prg primero. (Please execute first init.prg)", 64, "")
	return 
endif 

local kodnet 
kodnet = _Screen.kodnetLoader.v4


* KODNET (developer@kodhe.com)
* Download File asynchronous example
LOCAL netClientClass, netClient, uriClass, downloadCallbackObj, file 
public downloadCallback


* select a file
file= GETFILE()
IF EMPTY(m.file)
	RETURN MESSAGEBOX("Please select a file",64,"")
ENDIF 

uriClass= m.kodnet.COM.getStaticWrapper("System.Uri")
netClientClass= m.kodnet.COM.getStaticWrapper("System.Net.WebClient")
m.netClient= m.netClientClass.construct()


* THIS IS NOW REQUIRED FOR ALMOST ALL WEBSITES
ServicePointManager = m.kodnet.COM.getStaticWrapper("System.Net.ServicePointManager")
* TLS12 = 3072
ServicePointManager.SecurityProtocol = 3072


downloadCallbackObj= CREATEOBJECT("downloadCallback")

* create a delegate that point to VisualFoxPro function
downloadCallback = m.kodnet.COM.getStaticWrapper("System.ComponentModel.AsyncCompletedEventHandler").construct(m.kodnet.Helper.delegate(m.downloadCallbackObj, "finished"))

* add the event handler 
m.netClient.add_DownloadFileCompleted(m.downloadCallback)



* this method is a .NET async method, this call will complete without finish the download
m.netClient.DownloadFileAsync(uriClass.construct("https://raw.githubusercontent.com/voxsoftware/kwcore-static/master/win32/12.11.1.ia32.tar.gz"), m.file)


* this executes before finish for demostrate that method is called async
? "Download has started. Running in background."
? "If you see this message before 'download finished', async mode is working ok"

return 



DEFINE CLASS downloadCallback  as Custom 
	FUNCTION finished(sender, args)
		IF !ISNULL(args.Error)
			MESSAGEBOX("Failed download: " + args.Error.Message, 48, "")
		ELSE 
			? "download finished"
			MESSAGEBOX("Finished download.", 64, "")
		ENDIF 

		* Free memory 
		downloadCallback.dispose()
	ENDFUNC 
ENDDEFINE 

