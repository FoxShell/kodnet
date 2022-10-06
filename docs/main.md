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

Please READ documentation of each one: 

- [KodnetCOM object](./kodnet-com.md) Principal object for comunication

- [KodnetUtils object](./kodnet-utils.md) Utilities for make easier some actions

- [KodnetHelper object](./kodnet-helper.md) Helper for create Delegates



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

Create event handlers is like creating delegates. Please see the section **KodnetHelper -> Delegate** in [KodnetHelper](./kodnet-helper.md)
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

See this examples: 

- [downloadFileAsync.prg](../samples/v4/downloadfileasync.prg) with .NET Framework 
- [delegate.prg](../samples/v4/delegate.prg) with .NET Framework
- [delegate.prg](../samples/v6/delegate.prg) with .NET 6


#### Creating objects of generic types

It's easy with kodnet.

```foxpro
kodnetCOM = _screen.kodnetLoader.v6.COM

* construct and object System.Collections.Generic.List<int>
m.kodnetCOM.getStaticWrapper("System.Collections.Generic.List<System.Int32>").construct()
```

#### Compile C# code

**kodnet** allows compile C# code, in .NET Framework v4.5+ or in .NET 6+

See the samples: 

- [compilecsharp.prg](../samples/v4/compilecsharp.prg) with .NET Framework
- [compilecsharp.prg](../samples/v6/compilecsharp.prg) with .NET 6