# KodnetHelper object (kodnet.Helper)

**kodnet** helper is used mostly in *internal* operations, but there are some useful methods: 

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Proxy**

```foxpro
FUNCTION Proxy(object as VFPObject) as FoxShell.Proxy
```

Due to a limitation in VFP COM+ object model, you should not pass VFP *objects*  to *Managed Code* (.NET Framework or .NET 6) methods. Because each time you pass a new object, previous objects are replaced (I don't know why). So, if you need for any reason pass a VFP object to .NET Method use this method. 

For example (incorrect way, never do this): 

```c#
public class Test{

    public static int CheckPerson(object personObject){
        dynamic person = personObject;
        if(person.name == "James" && person.age == 28){
            return (int) person.GetIdNumber();
        }
        return 0;
    }
}
``` 

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
testClass = m.kodnetCOM.getStaticWrapper("Test")

person = createobject("person")
m.person.age = 28
m.person.name = "James"



* NEVER DO THIS. TECHNICALLY WORKS, YES, BUT PRODUCE RARE CONDITIONS, AND KODNET WILL STOP WORKING CORRECTLY
m.testClass.CheckPerson(m.person)


Define Class Person as Custom

    age = 0
    name = ""

    Function GetIdNumber()
        return this.age * 2
    endfunc 

EndDefine 
```

Instead use this way: 


```c#
// add reference or load assembly kodnet dll 
public class Test{

    public static int CheckPerson(FoxShell.Proxy person){
        
        var name = (string)person.GetProperty("name");
        var age = (int)person.GetProperty("age");

        if(name == "James" && age == 28){
            return (int) person.InvokeMethod("GetIdNumber", new object[]{});
        }
        return 0;
    }
}
``` 

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetHelper = _screen.kodnetLoader.v6.Helper

testClass = m.kodnetCOM.getStaticWrapper("Test")

person = createobject("person")
m.person.age = 28
m.person.name = "James"



* correct way
proxy = kodnetHelper.proxy(m.person)
m.testClass.CheckPerson(m.proxy)
* Recommended for free memory and avoid memory leaks
m.proxy.dispose()


Define Class Person as Custom

    age = 0
    name = ""

    Function GetIdNumber()
        return this.age * 2
    endfunc 

EndDefine 
```


However it's recommended avoid usage of passing VFP Objects to .NET for performance reasons. You can try write your code using Dictionary for example, when need pass data from VFP to .NET


```c#
using System.Collections.Generic;
public class Test{

    public static int CheckPerson(Dictionary<string, object> person){
        
        var name = (string)person["name"];
        var age = (int)person["age"];

        if(name == "James" && age == 28){
            return age * 2;
        }
        return 0;
    }
}
``` 

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

testClass = m.kodnetCOM.getStaticWrapper("Test")

person = m.kodnetUtils.dictionary()
m.person.item["age"] = 28
m.person.item["name"] = "James"

?m.testClass.CheckPerson(m.person)
```


---


#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Delegate**

```foxpro
FUNCTION Delegate(object as VFPObject, method as String) as FoxShell.DelegateProxy
```

Returns a **FoxShell.DelegateProxy** object representing a method invocation. Basically is an special **FoxShell.Proxy** object with an additional **Invoke** method, that invokes in the VFPObject the specified **method**.

It's useful for construct **.NET delegates**


Consider this example: 

```c#
// add reference or load assembly kodnet dll
public class Test{

    public static int SumFromVFP(FoxShell.DelegateProxy method, int num1, int num2){

        return (int) method.Invoke(new object[]{ num1, num2 });
        
    }
}
``` 


```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

testClass = m.kodnetCOM.getStaticWrapper("Test")


SumObject = createobject("SumClass")

delegate = kodnetHelper.Delegate(m.SumObject, "Sum")
?m.testClass.SumFromVFP(m.delegate, 10, 20)

* Recommended for free memory and avoid memory leaks
m.delegate.dispose()


Define Class SumClass as Custom

    Function Sum(p1 as number, p2 as number)
        return m.p1 + m.p2
    endfunc 

EndDefine 


```

This is good, but not always you have control on c# code to add reference to **kodnet** dll. How execute VFP methods from **.NET**? Using **.NET delegates**. Look the same example using a **System.Func** delegate.


```c#
using System;
public class Test{

    public static int SumFromVFP(Func<int, int, int> method, int num1, int num2){
        return method.Invoke(num1, num2);        
    }
}
``` 


```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

testClass = m.kodnetCOM.getStaticWrapper("Test")
funcIntIntIntClass = m.kodnetCOM.getStaticWrapper("System.Func<System.Int32, System.Int32, System.Int32>")


SumObject = createobject("SumClass")
* create a System.Func<int,int,int> delegate
func = m.funcIntIntIntClass.construct( m.kodnetHelper.Delegate(m.SumObject, "Sum") )

?m.testClass.SumFromVFP(m.func, 10, 20)

* Recommended for free memory and avoid memory leaks
m.func.dispose()


Define Class SumClass as Custom

    Function Sum(p1 as number, p2 as number)
        return m.p1 + m.p2
    endfunc 

EndDefine 


```