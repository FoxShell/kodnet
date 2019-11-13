* call this file at start of application
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")


local X509StoreClass, StoreLocation, store, X509OpenFlagsEnum, Certificates, certificate, count
X509StoreClass= _screen.kodnet.getStaticWrapper("System.Security.Cryptography.X509Certificates.X509Store")

* access to enum
StoreLocation= _screen.kodnet.getStaticWrapper("System.Security.Cryptography.X509Certificates.StoreLocation")
store= m.X509StoreClass.construct(StoreLocation.LocalMachine)

* OR use this for certificates only the user
*store= m.X509StoreClass.construct(StoreLocation.CurrentUser)



X509OpenFlagsEnum=  _screen.kodnet.getStaticWrapper("System.Security.Cryptography.X509Certificates.OpenFlags")
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