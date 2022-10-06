* IN YOUR APP PUT THIS LINES AT STARTUP
* do (getenv("Userprofile") + "\kwruntime\kodnet\loader.prg")
* _screen.kodnetLoader.load("v6")

if type("_screen.kodnetLoader.v6") == "U" or isnull(_screen.kodnetLoader.v6)
	* Execute init.prg
	MESSAGEBOX("Por favor ejecute el archivo init.prg primero. (Please execute first init.prg)", 64, "")
	return 
endif 


local kodnet 
kodnet = _screen.kodnetLoader.v6


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
engine= m.kodnet.COM.getStaticWrapper("jxshell.csharplanguage").construct()
m.engine.Runscript(m.code)
asem = m.engine.getCompiledAssembly()
m.kodnet.COM.loadAssembly(m.asem)


* now you can use the type compiled 
test= m.kodnet.COM.getStaticWrapper("Compiled.Test").construct()
person= test.person("James", 24)
?"Your name is " + m.person.name + " and your age is: " + allt(str(m.person.age))