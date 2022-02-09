# kodnet 

Versión en ESPAÑOL => [README-es-la.md](./README-es-la.md)

kodnet allows use any .NET object/class/type from VFP9 and VFP Advanced 32/64 bits.

This project is a guide for install and use kodnet. Contains the distributable files, and the info required for include in your VFP project.

If you want see C# source code:
 - [jxshell.dotnet4](https://github.com/kodhework/jxshell.dotnet4)


# Requirements

1. VFP9 or superior 
2. NET Framework 4.5 or superior 


# Installation of kodnet 

1. Install [kwruntime/core](https://github.com/kwruntime/core/blob/main/INSTALL.md)

2. Execute in ```cmd```the following command:

> No required admin permissions. You can execute as normal user.

```bash	
kwrun gh+/FoxShell/packages/kodnet/2.0.4.kwc
```

That's all, you are ready to use. See the examples


# How to use

Read the [DOCS.md](./DOCS.md)


# Features

- NOW SUPPORTS VFP ADVANCED 64 Bits!
- Access any .NET component even if it is not marked for interop [ComVisible].
- You do not need to register or install the component
- Call any method, property directly like any other object FoxPro
- Calling the constructor of a class with parameters is possible
- Call any method overload. kodnet select the best, according to your parameters
- Support for any non-native .NET type
- Access to static members, including Structs, Enums, Generics, etc.
- Access .NET arrays easily using Get and Set methods
- You can pass an object FoxPro and read it from a .NET method using dynamic.
- Multithread support
- Include visual .NET controls within your VisualFoxPro forms and access your members like any other .NET class.
- Support for adding/deleting .NET event handlers (delegates)
- Great performance in method calls, properties, because internally it doesn't use Reflection but uses CallSite (the methodology it uses internally dynamic in C#)


# Advantages over wwDotnetBridge

- Easier code to write! Call/assign methods, properties, fields using the member's own name.
- Support to create delegates and add/delete events. YES! kodnet supports DELEGATES without registering VFP components
- Create generic class instances easily
- Real support for asynchronous .NET methods
- Compile C# code dynamically
- Support for including visual controls from .NET to VFP forms
- Up to 10x times faster in instance method calls, and still faster on static method calls





# You need a work on your project?

If you have an specific requirenment, or want integrate this library in your project, contact us

 - developer@kodhe.com


# Be an sponsor

Make open source software is hard, and need many time. Please consider donate, and if you want write us to developer@kodhe.com, and your name will appear here

* Donate to paypal [![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XTUTKMVWCVQCJ&source=url)