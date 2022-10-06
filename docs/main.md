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


```typescript
_screen.kodnetLoader.Load(version: string): KodnetVFPObject{
    // returns and object 
    // with 3 properties: 

    // COM => KodnetCOM Type
    // Helper => KodnetHelper Type 
    // Utils => KodnetUtils Type
}
``` 


## KodnetCom object (kodnet.COM)



<img src="https://client-tools.west-wind.com/docs/bmp/classmethod.png" width="20" height="20" /> Method
```typescript
GetStaticWrapper(type: string) : Wrapper
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



