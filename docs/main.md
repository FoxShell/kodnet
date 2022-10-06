## Kodnet DOCS

### Start with kodnet

First install kodnet. In your VisualFoxPro app, execute this at startup:

```foxpro
DO getenv("userprofile") + "\kwruntime\kodnet\loader.prg"

* Load for .NET 6+ (you need install .NET 6 Runtime)
_screen.kodnetLoader.Load("v6")


* Load for .NET Framework v4.5+
_screen.kodnetLoader.Load("v4")
```

It's all.  Now you can use:

```foxpro
kodnet = _screen.kodnetLoader.v6
int = m.kodnet.COM.getStaticWrapper("System.Int32")
?m.int.maxValue

```

## Documentation

```foxpro
* version can be v6 or v4
version = "v6" 

kodnet = _screen.kodnetLoader.Load(version)

* KodnetCOM Object 
?m.kodnet.COM

* KodnetUtils Object 
?m.kodnet.Utils

* KodnetHelper Object 
?m.kodnet.Helper
```

## KodnetCOM object (kodnet.COM)


#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **GetBytesFromString**

```foxpro
FUNCTION GetBytesFromString(str as string) as System.Byte[]
```

Returns a .NET System.Byte[] object, from the VFP string. This method is equivalent to this in C# (.NET Framework v4.5): 

```c#
public byte[] GetBytesFromString(string str){
    return System.Text.Encoding.GetEncoding("WINDOWS-1252").GetBytes(str);
}
```

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **GetDefaultFor**

```foxpro
FUNCTION GetDefaultFor(type as System.Type) as InstanceWrapper
```

Construct an object with the default new value of a specified System.Type.
Returns an *InstanceWrapper* that is the representation of .NET instance object. This method is util for **struct** classes in NET. Consider this example:

```c#
public struct Size{
    public int Width;
    public int Height;
} 
```

```foxpro
* Size is a value type, and has no constructo, so instead of call getStaticWrapper("Size").construct() call getDefaultFor(type)


kodnetCOM = _screen.kodnetLoader.v6.COM
SizeType = m.kodnetCOM.getTypeFromString("Size")
size = m.kodnetCOM.GetDefaultFor(m.SizeType)

size.Width = 200
size.Height = 100
```

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **GetStaticWrapper**

```foxpro
FUNCTION GetStaticWrapper(type as string) as Wrapper
```

Returns an object (Wrapper) that is the representation of static .NET class. For example, with *static wrappers* you can construct .NET objects:

Consider the c# code:

```c#
using System;
using System.Text;

public class Program{
    public static void main(string[] args){
        StringBuilder sb = new StringBuilder();
        sb.AppendLine("Prueba, línea 1");
        sb.Append("Otro texto más");
    }
}
```

Equivalent in kodnet:

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
StringBuilderClass = m.kodnetCOM.getStaticWrapper("System.Text.StringBuilder")
* xxx.construct is like new xxx in c#
sb = StringBuilderClass.construct() 
sb.AppendLine("Prueba, línea 1")
sb.Append("Otro texto más")
```

*static wrappers* also allows execute any static method, or access to any static property. Consider this example:

```c#
// convert and string to base64 string representation
string result = System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes("Texto xxx"));
```

Equivalent in kodnet:

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
UTF8Encoding = m.kodnetCOM.getStaticWrapper("System.Text.Encoding").UTF8
ConvertClass = m.kodnetCOM.getStaticWrapper("System.Convert")

result = ConvertClass.ToBase64String(UTF8Encoding.GetBytes("Texto xxx"))
```

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **GetWrapped**

```foxpro
FUNCTION GetWrapped(object as System.Object, type as System.Type) as InstanceWrapper
```

Returns an *InstanceWrapper* that is the representation of .NET instance object, but with the **type** specified.
This method is util for get primitive values as a .NET Object and **call** NET methods. Consider this example:


```foxpro

kodnetCOM = _screen.kodnetLoader.v6.COM
strObject = m.kodnetCOM.GetWrapped("a,comma,separated,string", m.kodnetCOM.GetTypeFromString("System.String"))

StringSplitOptions = m.kodnetCOM.GetStaticWrapper("System.StringSplitOptions")

* Split the string using instance method: System.String.Split(string separator, StringSplitOptions options)
strArray = m.strObject.Split(",", m.StringSplitOptions.None)

* Access to System.String[] object in vfp:

for i=0 to m.strarray.Length - 1
    ? m.strArray.Get(m.i)
endfor 
```

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **GetWrappedConverted**


```foxpro
FUNCTION GetWrappedConverted(object as System.Object, type as System.Type) as InstanceWrapper
```

Similar to GetWrapped, but performs a **convert process**  from the original **object** to the **type** specified.
This method is util for convert a .NET object to other type. For example, numbers in VFP are always **int** or **double**, consider this code to call a method that only accepts **float** parameters: 


```c#
public class Test{
    public float SumFloat(float n1, float n2){
        return n1 + n2;
    }
}
```

```foxpro

kodnetCOM = _screen.kodnetLoader.v6.COM
floatType = m.kodnetCOM.GetTypeFromString("System.Single")
num1 = m.kodnetCOM.GetWrappedConverted(10, m.floatType)
num2 = m.kodnetCOM.GetWrappedConverted(20.5, m.floatType)

value = m.kodnetCOM.GetStaticWrapper("Test").SumFloat(m.num1, m.num2)
?m.value
```

--- 

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **GetTypeFromString**


```foxpro
FUNCTION GetWrappedConverted(type as string) as System.Type
```

Returns a **System.Type** representation (InstanceWrapper) of a .NET type. You can specify also generic types:

```foxpro

kodnetCOM = _screen.kodnetLoader.v6.COM
dictGenericType = m.kodnetCOM.GetTypeFromString("System.Collections.Generic.Dictionary<System.String, System.Object>")

?m.dictGenericType.toString()
```

Equivalent in c# should be like:

```c#
Type t = typeof(System.Collections.Generic.Dictionary<string, object>);
Console.Write(t.ToString());
```

Getting a **System.Type** is util for methods like ```GetDefaultFor, GetWrapped or GetWrappedConverted```

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **LoadAssembly**

```foxpro
FUNCTION LoadAssembly(AssemblyName as string) as void
```

Load an assembly using its full name. 

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM

* This is only an example, Assembly System is loaded by default, so you don't need this
m.kodnetCOM.LoadAssembly("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
```

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **LoadAssemblyFile**


```foxpro
FUNCTION LoadAssemblyFile(path as string) as void
```

Load an assembly using a file path.

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
* For example
m.kodnetCOM.LoadAssembly("c:\path\to\Aforge.dll")
```

All LoadAssembly methods are useful when you need load other types not included by default.

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **LoadAssemblyPartialName**


```foxpro
FUNCTION LoadAssemblyPartialName(name as string) as void
```

Load an assembly using a *partial* name.  

```foxpro
* This example is tested with .NET Framework, maybe works with NET 6, no tested

kodnetCOM = _screen.kodnetLoader.v4.COM

* For example for use System.Windows.Forms.MessageBox
m.kodnetCOM.LoadAssemblyPartialName("System.Drawing")
m.kodnetCOM.LoadAssemblyPartialName("System.Windows.Forms")

messageboxClass = m.kodnetCOM.GetStaticWrapper("System.Windows.Forms.MessageBox")
messageboxClass.show("Messagebox using .NET")
```



## KodnetUtils object (kodnet.Utils)

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Dictionary**

```foxpro
FUNCTION Dictionary() as System.Collections.Generic.Dictionary<System.String, System.Object>
```

or 

```foxpro
FUNCTION Dictionary(TKey as System.Type, TValue as System.Type) as System.Collections.Generic.Dictionary<TKey, TValue>
```

or 

```foxpro
FUNCTION Dictionary(TKeyStr as string, TValueStr as string) as System.Collections.Generic.Dictionary<TKey, TValue>
```


Returns a representation (InstanceWrapper) of System.Collections.Generic.Dictionary<TKey, TValue>. If you omit parameters, ```TKey``` is taken as **System.String** type and ```TValue``` as **System.Object** type. 

Consider this example: 

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

dict = m.kodnetUtils.dictionary()
m.dict.item["Name"] = "James"
m.dict.item["Age"] = "28"

* is equivalent to this:
dict = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.Dictionary<System.String, System.Object>").contruct()
m.dict.item["Name"] = "James"
m.dict.item["Age"] = "28"


dict = m.kodnetUtils.dictionary("System.Int32", "System.String")
m.dict.item[0] = "James"
m.dict.item[1] = "28"

* is equivalent to this:
dict = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.Dictionary<System.Int32, System.String>").contruct()
m.dict.item[0] = "James"
m.dict.item[1] = "28"
```

---


#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **CustomList**

```foxpro
FUNCTION CustomList(TValue as System.Type, p1 as TValue, p2 as TValue, p3 as TValue ...) as System.Collections.Generic.List<TValue>
```

or 

```foxpro
FUNCTION CustomList(TValueStr as string, p1 as TValue, p2 as TValue, p3 as TValue ...) as System.Collections.Generic.List<TValue>
```

Returns a representation (InstanceWrapper) of System.Collections.List<TValue>. You can pass ```TValue``` as System.Type or as string. 
Is usefull for returns a *List* with values in one line:



```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

vocals = m.kodnetUtils.CustomList("System.String", "A", "E", "I", "O", "U")
for i=0 to m.vocals.length - 1
    ?m.vocals.item[m.i]
endfor 

* is equivalent to this:
vocals = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.List<System.String>").contruct()
vocals.Add("A")
vocals.Add("E")
vocals.Add("I")
vocals.Add("O")
vocals.Add("U")
for i=0 to m.vocals.length - 1
    ?m.vocals.item[m.i]
endfor 
```

--- 

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **List**

```foxpro
FUNCTION List(p1 as System.Object, p2 as System.Object, p3 as System.Object ...) as System.Collections.Generic.List<TValue>
```

Similar to **CustomList** but ```TValue``` parameter omitted, and taken as **System.Object**. If no parameters sent, returns an empty **List**



```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

list = m.kodnetUtils.List(1, "A", 2, "B")
for i=0 to m.list.length - 1
    ?m.list.item[m.i]
endfor 

* is equivalent to this:
list = m.kodnetCOM.getStaticWrapper("System.Collections.Generic.List<System.Object>").contruct()
list.Add(1)
list.Add("A")
list.Add(2)
list.Add("B")
for i=0 to m.vocals.length - 1
    ?m.list.item[m.i]
endfor 
```

---


#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Array**

```foxpro
FUNCTION Array(TValue as System.Type, p1 as TValue, p2 as TValue, p3 as TValue ...) as TValue[]
```

OR

```foxpro
FUNCTION Array(TValueStr as string, p1 as TValue, p2 as TValue, p3 as TValue ...) as TValue[]
```

Similar to **CustomList** but instead of **List** returns a .NET Array. For example, suppose you need call a method with receives **string[]** as parameter: 

```c# 
public class Test{
    public string Join(string[] words, string separator){
        return string.Join(separator, words);
    }
}
```


```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetUtils = _screen.kodnetLoader.v6.Utils

testClass = m.kodnetCOM.getStaticWrapper("Test")

* create array in oneline
array = m.kodnetUtils.Array("System.String", "kodnet", "is" "great")
?m.testClass.Join(m.array, " ")


* is equivalent to this:
array = m.kodnetCOM.getStaticWrapper("System.String[]").contruct(3)
array.Set(0, "kodnet")
array.Set(1, "is")
array.Set(2, "great")
?m.testClass.Join(m.array, " ")
```

---



#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **RGBToArgb**

```foxpro
FUNCTION RGBToArgb(rgb as int, alpha as int) as int
```

Add alpha channel to RGB color and returns the *number* representation. Is usefull for use with **.NET Controls** inside VFP. 

---

#### <img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method **Await**

```foxpro
FUNCTION Await(task as System.Threading.Task) as System.Object
```

**kodnet** supports async operations. **Await** method allows execute *wait* in sync mode the result of async operation. If the async operations completes *Faulted* (with an error) throws an exception, if not, returns the **result** of async operation.



## KodnetHelper object (kodnet.Helper)

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

---

## More info about how use kodnet

#### Exception control

This is the best way to control kodnet exceptions

```foxpro 
kodnetCOM = _screen.kodnetLoader.v6.COM
kodnetHelper = _screen.kodnetLoader.v6.Helper

try     

    * execute here a method that throws a .NET Exception
    m.kodnetCOM.getStaticWrapper("System.TypeNonExistent")


catch to ex 

    * get the original .NET exception if available
    if !isnull(m.kodnetHelper.lastException)
        * show the full message
        messagebox(m.kodnetHelper.lastException.toString(), 48, "Error")

        * maybe access to some .NET Exception properties not availables in VFP Exception
        * ?m.kodnetHelper.lastException.message
        * ?m.kodnetHelper.lastException.stack
        * ?m.kodnetHelper.lastException.innerException
        * etc

        m.kodnetHelper.lastException = .null.
    else

        messagebox(m.kodnetHelper.lastException.toString(), 48, "Error")

    endif 

endtry

```


#### Create event handlers

Create event handlers is like creating delegates. Please see the section **KodnetHelper -> Delegate** 
Also, for add events, you can call as a method: 

```foxpro 
* This example works with .NET Framework v4.5+ no tested on .NET Core
kodnetCOM = _screen.kodnetLoader.v4.COM
kodnetHelper = _screen.kodnetLoader.v4.Helper

netClientClass= _screen.kodnet.getStaticWrapper("System.Net.WebClient")
m.netClient= m.netClientClass.construct()


downloadCallbackObj= CREATEOBJECT("downloadCallback")

* create a delegate, please refer to KodnetHelper->Delegate section
m.downloadCallback = m.kodnetCOM.getStaticWrapper("System.ComponentModel.AsyncCompletedEventHandler").construct(m.kodnetHelper.delegate( ... ))


* ADD THE EVENT
m.netClient.add_DownloadFileCompleted(m.downloadCallback)

* REMOVE THE EVENT
m.netClient.remove_DownloadFileCompleted(m.downloadCallback)

``` 


This part: 
```foxpro
m.netClient.add_DownloadFileCompleted(m.downloadCallback)
``` 

is equivalent in C# to this:

```c#
netClient.DownloadFileCompleted += new System.ComponentModel.AsyncCompletedEventHandler(MyMethod);

...
``` 

#### Creating objects of generic types

It's easy with kodnet.

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM

* construct and object System.Collections.Generic.List<int>
m.kodnetCOM.getStaticWrapper("System.Collections.Generic.List<System.Int32>").construct()
```

