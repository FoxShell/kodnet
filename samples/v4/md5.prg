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


LOCAL MD5Hash, UTF8Encoding, bytes, result, Convert, hash, latin, encoding

MD5Hash= m.kodnet.COM.getStaticWrapper("System.Security.Cryptography.MD5").create()


* strings in VFP are latin encode, but in .NET are UTF8
UTF8Encoding= m.kodnet.COM.getStaticWrapper("System.Text.Encoding").UTF8
bytes= UTF8Encoding.getBytes("textó de prueba") 

result= MD5Hash.ComputeHash(bytes)


* get the pure string representation of the result hash in VFP
encoding= m.kodnet.COM.getStaticWrapper("System.Text.Encoding").getEncoding("WINDOWS-1252")
hash= encoding.getString(m.result)
?(m.hash)


* or Convert to base64 
Convert= m.kodnet.COM.getStaticWrapper("System.Convert")
hash= m.Convert.ToBase64String(m.result)
?(m.hash)



* or Convert to hex
Convert= m.kodnet.COM.getStaticWrapper("System.BitConverter")
hash = STRTRAN(LOWER(m.Convert.ToString(m.result)),'-','')
?(m.hash)

