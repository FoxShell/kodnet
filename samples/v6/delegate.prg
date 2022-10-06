* IN YOUR APP PUT THIS LINES AT STARTUP
* do (getenv("Userprofile") + "\kwruntime\kodnet\loader.prg")
* _screen.kodnetLoader.load("v6")

if type("_screen.kodnetLoader.v6") == "U" || isnull(_screen.kodnetLoader.v6)
	* Execute init.prg
	MESSAGEBOX("Por favor ejecute el archivo init.prg primero. (Please execute first init.prg)", 64, "")
	return 
endif 

local kodnet 
kodnet = _screen.kodnetLoader.v6


* YES! KODNET SUPPORTS DELEGATES 
PUBLIC Func1, Func2, target , TestClass, needrunCompile


TRY 
	* Take a look in compilecsharp.prg example for understand
	TestClass= m.kodnet.COM.getStaticWrapper("Compiled.Test")
CATCH TO ex 
	needrunCompile= .t.
ENDTRY 

IF needrunCompile 
	RETURN MESSAGEBOX("Please execute first 'compilecsharp.prg' example",64,"Kodnet")
ENDIF 



target= CREATEOBJECT("func_callback")
target1= CREATEOBJECT("func_callback1")
Func1= m.kodnet.COM.getStaticWrapper("System.Func<System.String,System.Int32>").construct(m.kodnet.Helper.delegate(m.target,"callback"))
Func2= m.kodnet.COM.getStaticWrapper("System.Func<System.String,System.Int32,System.String,System.Int32>").construct(m.kodnet.Helper.delegate(m.target1,"invoke"))

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


DEFINE CLASS func_callback1 as Custom 

	FUNCTION invoke( str, option, title )
		IF PCOUNT() == 3
			RETURN MESSAGEBOX("MS2: " + str,option,title)
		ELSE 
			RETURN MESSAGEBOX("MS2: "+str)
		ENDIF 

	ENDFUNC 

ENDDEFINE 