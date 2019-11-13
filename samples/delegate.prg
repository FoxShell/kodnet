* call this file at start of application
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")

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