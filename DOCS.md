
# Start kodnet Library 

```foxpro
* call this file at start of application, or before start using kodnet
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")
```


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


# Available methods

Methods for ```_screen.kodnet``` 

```csharp 

/**
* wrapperStatic = Represents a .NET Framework static class 
                  It's used for access to static methods, properties and fields, and for construct new objects
                  For example: uri = _screen.kodnet.getStaticWrapper("System.Uri").construct("https://google.com")

* wrapper = Represents a .NET Framework instance object 
            It's used for access to instance methods, properties and fields.
            For example: ?m.uri.wrapperStatic
*/

/**
* get a object representing the static class
*/
public wrapperStatic getStaticWrapper (string typeName);

/**
* get a System.Type object from Object
*/
public wrapper getTypeFromObject (object o);

/**
* get a System.Type object from 
*/
public object getTypeFromString (string name);

/**
* get a UTF8 string as object (from VFP is like and object, for kodnet is a string).
* You can use all methods and properties from string class
*/
public object getUTF8WrappedString (object s);

/**
* load an assembly with full qualified name
*/
public void loadAssembly (string name);

/**
* load an assembly file
*/
public void loadAssemblyFile (string file);

/**
* load an assembly with partial name. Example: System.Drawing
* Deprecated in .NET Framework
*/
public void loadAssemblyPartialName (string name);


/**
* get default value for a class. It's good for Structs like System.DateTime for example
*/
public wrapper getDefaultFor (string type);
public wrapper getDefaultFor (Type type);

/*
* implicit cast and object to other type
* Good when you need pass parameters with specific type
* For example: _screen.kodnet.getObjectAsType(12, "System.Single")
*/
public wrapper getObjectAsType (object o, string type);
public wrapper getObjectAsType (object o, Type type);

/*
* convert string WINDOWS-1252 encoding to byte[]
*/
public byte[] getBytesFromString (string s);

```


Methods for _screen.kodnetManager

```foxpro
* Create an .NET event (delegate) bound to a VFP Target+method
Function createEventHandler(target as Object, method as String, className as string) as System.Event
endfunc 

* Add alpha channel to rgb. Convert rgb to argb
Function rgbtoArgb(color as number, alpha as number) as Number
EndFunc

* Block VFP thread until .NET async method finish
Function await(task as System.Threading.Task) as VOID
EndFunc

``` 

Methods for _screen.kodnetManager.API

```foxpro
* Embed a .NET Windows.Forms Control into VFP Form
Function setParent(control as System.IntPtr, form as Form) as VOID
endfunc 

* Add alpha channel to rgb. Convert rgb to argb
Function rgbtoArgb(color as number, alpha as number) as Number
EndFunc

* Block VFP thread until .NET async method finish
Function await(task as System.Threading.Task) as VOID
EndFunc

``` 




# Access to static methods/properties/fields

```foxpro
int32 = _screen.kodnet.getStaticWrapper("System.Int32")
?int32.MaxValue
?int32.MinValue

environ = _screen.kodnet.getStaticWrapper("System.Environment")
?environ.GetEnvironmentVariable("USERPROFILE")
```


# Construct objects

```foxpro
uri = _screen.kodnet.getStaticWrapper("System.Uri").construct("https://github.com")
```

## Generic objects

```foxpro
dictionaryClass = _screen.kodnet.getStaticWrapper("System.Collections.Generic.Dictionary<System.String, System.Object>")
dict = dictionaryClass.construct()
dict.item["name"] = "James"
dict.item["number"] = 1

* This throws error beacuse string is expected as index
dict.item[10] = 1
``` 


# Load Assemblies 

```foxpro
_screen.kodnet.loadAssemblyPartialName("System.Drawing")
_screen.kodnet.loadAssemblyPartialName("System.Windows.Forms")

messageBoxClass = _screen.kodnet.getStaticWrapper("System.Windows.Forms.MessageBox")
m.messageBoxClass.show("Mensaje de prueba")
``` 

# Default value

Struct types can be instantiated using ```getDefaultFor```

```foxpro
_screen.kodnet.loadAssemblyPartialName("System.Drawing")
size = _screen.kodnet.getDefaultFor("System.Drawing.Size")
size.Width = 1280
size.Height = 720
``` 

# Cast values

Sometimes, you need cast values, or get a "wrapped object" to specific type. For example, in VFP all numbers are just that, numbers. In .NET numbers can be: ```System.Single```, ```System.Int16```, ```System.Int32```, ```System.Double```, ```System.Int64```, etc. 

If you need a parameter with specific type you can cast values:

```foxpro
custom = _screen.kodnet.getStaticWrapper("Custom.Class")
* custom method requiring a System.Int64 (long) parameter:
custom.CustomMethod(_screen.kodnet.getObjectAsType(10, "System.Int64"))
```

# Delegates

In kodnet you can use delegates/events without registering VFP Components. 

```foxpro
target= CREATEOBJECT("func_callback")
Func1= _screen.kodnet.getStaticWrapper("System.Func<System.String,System.Int32>").construct(m.target,"callback")

define class func_callback as custom
	function callback()
		* your code here
	endfunc 
enddefine
```

For events use special method: ```_screen.kodnetManager.createEventHandler```

```foxpro 
downloadCallback=_screen.kodnetManager.createeventhandler(m.downloadCallbackObj, "finished", "System.ComponentModel.AsyncCompletedEventHandler")
``` 


You can see full example at end of this document.



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

do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")

* select a file
file= GETFILE()
IF EMPTY(m.file)
	RETURN MESSAGEBOX("Please select a file",64,"")
ENDIF 

uriClass= _screen.kodnet.getStaticWrapper("System.Uri")
netClientClass= _screen.kodnet.getStaticWrapper("System.Net.WebClient")
m.netClient= m.netClientClass.construct()



* THIS IS NOW REQUIRED FOR ALMOST ALL WEBSITES
ServicePointManager = _screen.kodnet.getStaticWrapper("System.Net.ServicePointManager")
* TLS12 = 3072
ServicePointManager.SecurityProtocol = 3072


downloadCallbackObj= CREATEOBJECT("downloadCallback")

* create a delegate that point to VisualFoxPro function
downloadCallback=_screen.kodnetManager.createeventhandler(m.downloadCallbackObj, "finished", "System.ComponentModel.AsyncCompletedEventHandler")
m.downloadCallbackObj.event_finished = m.downloadCallback

* add the event handler 
m.netClient.add_DownloadFileCompleted(m.downloadCallback)

* this method is a .NET async method, this call will complete without finish the download
m.netClient.DownloadFileAsync(uriClass.construct("https://raw.githubusercontent.com/voxsoftware/kwcore-static/master/win32/12.11.1.ia32.tar.gz"), m.file)

* this executes before finish for demostrate that method is called async
? "Download has started. Running in background"
return 


DEFINE CLASS downloadCallback  as Custom 
	event_finished = null
	FUNCTION finished(sender, args)
		
		* dispose delegate to avoid memory leaks
		if !isnull(this.event_finished)
			this.event_finished.dispose()
		endif
		
		public obj 
		obj = this
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

kodnet allow C# code compilation. Take a look in this example

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