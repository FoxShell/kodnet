* call this file at start of application
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")



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