* call this file at start of application
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")


LOCAL MD5Hash, UTF8Encoding, bytes, result, Convert, hash, latin, encoding

MD5Hash= _screen.kodnet.getStaticWrapper("System.Security.Cryptography.MD5").create()


* strings in VFP are latin encode, but in .NET are UTF8
UTF8Encoding= _screen.kodnet.getStaticWrapper("System.Text.Encoding").UTF8
bytes= UTF8Encoding.getBytes("textó de prueba") 

result= MD5Hash.ComputeHash(bytes)


* get the pure string representation of the result hash in VFP
encoding= _screen.kodnet.getStaticWrapper("System.Text.Encoding").getEncoding("WINDOWS-1252")
hash= encoding.getString(m.result)
?(m.hash)


* or Convert to base64 
Convert= _screen.kodnet.getStaticWrapper("System.Convert")
hash= m.Convert.ToBase64String(m.result)
?(m.hash)



* or Convert to hex
Convert= _screen.kodnet.getStaticWrapper("System.BitConverter")
hash = STRTRAN(LOWER(m.Convert.ToString_2(m.result)),'-','')
?(m.hash)

