# KodnetCOM object (kodnet.COM)

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