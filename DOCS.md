
# Start kodnet Library 

```foxpro
* call this file at start of application, or before start using kodnet
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")
```

	If you get a message that says Unable to load CLR it's probably because Windows blocks files downloaded from the Internet. To do this right-click on the .DLL libraries distributed with kodnet and click unlock.


Now you can start using: 

```foxpro
* you can now access to kodnet using _screen.kodnet


local WebClientClass, WebClientObj
* you get a reference to static class calling getStaticWrapper
m.WebClientClass = _screen.kodnet.getStaticWrapper("System.Net.WebClient")
* create an instance of WebClient
m.WebClientObj = m.WebClientClass.construct()
* Download Google's home page
m.WebClientObj.DownloadFile("https://www.google.com", "Sample.html")


* load an assembly by file
local customClass, customObject
_screen.kodnet.loadAssemblyFile("customdotnet.dll")
m.customClass= _screen.kodnet.getStaticWrapper("CustomClass")
* create an instance of type 
m.customObject= m.customClass.construct()
* call customObject's method
? m.customObject.customMethod()


* access to property, methods, fields directly
local int32Class 
m.int32Class= _screen.kodnet.getStaticWrapper("System.Int32")
? m.int32Class.MaxValue
? m.int32Class.MinValue 

```


# Some examples 

```foxpro


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
``` 


### Async and events 

Consider now a more advanced example that calls asynchronous methods and uses .NET events.
See the sample [samples/downloadfileasync.prg](./samples/downloadfileasync.prg)

```foxpro
LOCAL netClientClass, netClient, uriClass, downloadCallbackObj, downloadCallback, file 

* select a file
file= GETFILE()
IF EMPTY(m.file)
	RETURN MESSAGEBOX("Please select a file",64,"")
ENDIF 

uriClass= _screen.kodnet.getStaticWrapper("System.Uri")
netClientClass= _screen.kodnet.getStaticWrapper("System.Net.WebClient")
m.netClient= m.netClientClass.construct()





downloadCallbackObj= CREATEOBJECT("downloadCallback")
* create a delegate that point to VisualFoxPro function
downloadCallback=_screen.kodnetManager.createeventhandler(m.downloadCallbackObj, "finished", "System.ComponentModel.AsyncCompletedEventHandler")
* add the event handler 
m.netClient.add_DownloadFileCompleted(m.downloadCallback)

* this method is a .NET async method, this call will complete without finish the download
m.netClient.DownloadFileAsync(uriClass.construct("https://raw.githubusercontent.com/voxsoftware/kwcore-static/master/win32/12.11.1.ia32.tar.gz"), m.file)

* this executes before finish for demostrate that method is called async
? "Download has started. Running in background"
return 


DEFINE CLASS downloadCallback  as Custom 
	FUNCTION finished(sender, args)
		* avoid memory leaks (this is only required for objects not forms)
		this._event.destroy()
		IF !ISNULL(args.Error)
			MESSAGEBOX("Failed download: " + args.Error.Message, 48, "")
		ELSE 
			? "download finished"
			MESSAGEBOX("Finished download.", 64, "")
		ENDIF 
	ENDFUNC 
ENDDEFINE 
```


### Compile c# code 

kodnet allow C# code dompilation. Take a look in this example

```foxpro 
TEXT TO m.code noshow

using System;
public class program{
	public static void main(){
	}
}
namespace Compiled
{

	public class Person{
		public string name;
		public int age;
	}
	
	public class Test
	{	
		public Person person(string name, int age){
			var p= new Person();
			p.name= name;
			p.age= age;
			return p;
		}
	
		public static int ExecuteFunc(Func<string,int> func)
		{
			return func("Method executed from .NET");
		}
		
		public static int ExecuteFunc(Func<string,int> func, string message)
		{
			return func(message);
		}
		
		public static int ExecuteFunc(Func<string,int,string,int> func, string message, int option, string title)
		{
			return func(message,option,title);
		}
	}
}


ENDTEXT 

LOCAL engine

* COMPILE C# CODE
Local asem, test, person

engine= _screen.kodnet.getStaticWrapper("jxshell.csharplanguage").construct()
m.engine.Runscript(m.code)
asem = m.engine.getCompiledAssembly()
_Screen.kodnet.loadAssembly(m.asem)


* now you can use the type compiled 
test= _screen.kodnet.getStaticWrapper("Compiled.Test").construct()
person= test.person("James", 24)
?person.name
?person.age
```


### Delegates, generic types 

kodnet supports the creation of delegates and generic objects. In the following example you will see how the class compiled in the previous example is used, to show the use of delegates and generic types: System.Func<string,int>.


```foxpro 
* YES! KODNET SUPPORTS DELEGATES 
LOCAL Func1, Func2, target , TestClass, needrunCompile


TRY 
	* Take a look in compilecsharp.prg example for understand
	TestClass= _screen.kodnet.getStaticWrapper("Compiled.Test")
CATCH TO ex 
	needrunCompile= .t.
ENDTRY 

IF needrunCompile 
	RETURN MESSAGEBOX("Please execute first 'compilecsharp.prg' example",64,"Kodnet")
ENDIF 



target= CREATEOBJECT("func_callback")
Func1= _screen.kodnet.getStaticWrapper("System.Func<System.String,System.Int32>").construct(m.target,"callback")
Func2= _screen.kodnet.getStaticWrapper("System.Func<System.String,System.Int32,System.String,System.Int32>").construct(m.target,"callback")

* Pass Func1 delegate to c# function 
?TestClass.executeFunc(Func1)

* pass overloaded 
?TestClass.executeFunc(Func1, "Parameter sent to c#")


* pass overloaded System.Func<string,int,string,int>
?TestClass.executeFunc(Func2, "Parameter sent to c#", 64, "Title")


* It's a good practice Free delegate, avoid memory leaks
Func1.dispose()
Func2.dispose()

DEFINE CLASS func_callback as Custom 

	FUNCTION callback( str, option, title )
		IF PCOUNT() == 3
			RETURN MESSAGEBOX(str,option,title)
		ELSE 
			RETURN MESSAGEBOX(str)
		ENDIF 

	ENDFUNC 

ENDDEFINE 
```


For more examples see the [samples folder](./samples)