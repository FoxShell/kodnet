# Kodnet

**kodnet** is a library for VFP8/VFP9/VFP Advanced that allows:

- Use any .NET Framework object/class/type  from VisualFoxPro
- Use any .NET Core (called NET 6 by Microsoft) object from VisualFoxPro
- Execute and interact with  javascript/typescript code from VisualFoxPro

This project is for generate the installer, focused to work with VisualFoxPro.
If you want see the C# source code of DLL used internally, go to this project: [KodnetLib](https://github.com/FoxShell/KodnetLib)

## Requirements

* VFP8 or superior
* NET Framework v4.5 or superior or NET 6 (like you prefer)

> NOTE: If you plan use .NET 6 you need install the appropiate version for each architecture. For example, if you will use with VisualFoxPro 8 or 9, you need install NET 6 Runtime x86, but if you will use with VisualFoxPro Advanced 64 bits, you need install NET 6 Runtime x64.

## Install

1. Install [kwruntime/core](https://github.com/kwruntime/core)

2. From CMD execute: 
```bash
kwrun gh+/FoxShell/packages/kodnet/3.0.4.kwc
``` 

> NOTE: No required admin permissions. You can (and is recommended) execute as normal user.

## Documentation

[docs/main.md](./docs/main.md) Read here the documentation


## What can do kodnet?

Anything you need, can be done on **kodnet**! Your libraries based on **kodnet** are welcome. If you have or want create a library for .NET Framework or .NET Core can be used with **kodnet**.

* [QRCoder](https://github.com/FoxShell/qrcoder) Create QR Codes in PNG format with VFP (actually works with .NET Framework)

* [Webcam-example](https://github.com/FoxShell/webcam_example) An example using AForge libraries to show Camera preview and save screenshot in a VFP form.


## Features

* Supports VisualFoxPro Advanced 64 bits
* Access any .NET component even if it is not marked for interop [ComVisible]
* No need to register or install your components (no COM registration required).
* Call any method, property directly like any other object in VisualFoxPro.
* Calling the constructor of a class with parameters is possible.
* Call any method overload. kodnet select the best, baseed to your parameters.
* Support for any non-native .NET type
* Access to static members, including Structs, Enums, Generics, etc.
* Access .NET arrays easily using **Get** and **Set** methods.
* ~~You can pass an object FoxPro and read it from a .NET method using dynamic.~~ = This not working due to a limitation of VFP Com objects. Instead, you can pass a **Proxy** object and read/write properties or invoke methods from C# (or any .NET DLL)
* Multithread support.
* Include visual .NET controls within your VisualFoxPro forms and access your members like any other .NET class (Just now only works with .NET Framework 4.5, no tested on .NET 6).
* Support for adding/deleting .NET event handlers or delegates. NO NEED TO REGISTER A VFP COM LIBRARY.
* The best performance. Use a custom combination of Reflection, Compiled Expressions, and CallSites, giving the best performance over any other similar library.

## Advantages over wwDotnetBridge

* Supports .NET 6 (before named .NET Core).
* Supports 64 bits (VisualFoxPro Advanced 64 bits)
* Easier code. You invoke method, read/write properties as any other VFP Object, using its own name. 
* Real support for async (Task objects in .NET) without creating new threads.
* Built-in support for compile C# code.
* Faster, **kodnet** many times faster than wwDotnetBridge


# Be an sponsor

Make open source software is hard, and need many time. Please consider donate, and if you want write us to **developer@kodhe.com**, and your name will appear here

* Donate to paypal [![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XTUTKMVWCVQCJ&source=url)

If you want write an specific library based on **kodnet** for you, write us to **developer@kodhe.com**