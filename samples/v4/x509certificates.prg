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


local X509StoreClass, StoreLocation, store, X509OpenFlagsEnum, Certificates, certificate, count
X509StoreClass= m.kodnet.COM.getStaticWrapper("System.Security.Cryptography.X509Certificates.X509Store")

* access to enum
StoreLocation= m.kodnet.COM.getStaticWrapper("System.Security.Cryptography.X509Certificates.StoreLocation")
store= m.X509StoreClass.construct(StoreLocation.LocalMachine)

* OR use this for certificates only the user
*store= m.X509StoreClass.construct(StoreLocation.CurrentUser)



X509OpenFlagsEnum=  m.kodnet.COM.getStaticWrapper("System.Security.Cryptography.X509Certificates.OpenFlags")
m.store.Open(X509OpenFlagsEnum.ReadOnly)

* manage collections  
Certificates= store.Certificates
count= Certificates.Count 

?"Certificates found: " + str(m.count)
FOR i=1 TO m.count

	* use item for access to collection items
	certificate= m.Certificates.item(m.i - 1)
    if (!ISNULL(m.certificate))
        ? m.certificate.FriendlyName
		? m.certificate.SerialNumber
		? m.certificate.GetName()
    endif 
endfor 