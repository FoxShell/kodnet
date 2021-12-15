# kodnet 

kodnet permite usar cualquier objeto/clase/tipo de .NET framework desde VFP9. 

Este proyecto es una guía para instalar y usar kodnet. Contiene los archivos que se distribuyen para que funcione la librería dentro de su proyecto. 

Si desea ver el código C# encargado de la comunicación:
 - [jxshell.dotnet4](https://github.com/kodhework/jxshell.dotnet4)



# Sea un patrocinador

Hacer software libre es complicado, y requiere tiempo. Por favor considere donar, y escríbanos a developer@kodhe.com si desea que su nombre aparezca aquí.

* Paypal: [![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=XTUTKMVWCVQCJ&source=url)



# Instalación de kodnet 

1. Instalar [@kawix/core](https://github.com/kodhework/kawix/blob/master/core/INSTALL.md)

2. Instalar la librería kodnet. Ejecute en una ventana cmd:

> Este comando puede ser ejecutado como un usuario normal, o como administrador, usted decide. Si usted ejecuta como usuario normal, *kodnet* no funcionará dentro de aplicaciones VisualFoxPro iniciadas como administrador. Si usted necesita usar *kodnet* dentro de aplicaciones VisualFoxPro iniciadas como administrador, aségurese de ejecutar la siguiente línea en una ventana **cmd modo administrador**

```bash
kwcore gh+/FoxShell/packages/kodnet/0.1.2.kwa
```

Es todo, está listo para usar. Vea los ejemplos


# Requerimientos

1. VFP9 o superior 
2. NET Framework 4.0 o superior (NET Core no soportado todavía)


# Features

- AHORA SOPORTA VFP ADVANCED 64 Bits!
- Acceda a cualquier componente .NET Incluso si ha sido marcado para intercomunicación []ComVisible]
- No necesita registrar o instalar cada componente
- Llame a cualquier método, propiedad, directamente como cualquier otro objeto de VisualFoxPro
- Llame un constructor de clase con parámetros
- Llame un método con cualquier sobrecarga de parámetros. Kodnet automáticamente selecciona la mejor sobrecarga basado en los parámetros de la llamada.
- Soporte para cualquier tipo .NET nativo y no nativo
- Acceda a miembros estáticos, incluidos Structs, Enums, Generics, y más.
- Acceda a vectores .NET fácilmente usando métodos Get y Set.
- Puede pasar cualquier objeto VFP a .NET y usarlos con la palabra clave de C#: dynamic.
- Soporte multihilo.
- Agregue controles visuales .NET dentro de formularios VFP, y acceda a sus miembros como cualquier otra clase .NET.
- Soporte para añadir/eliminar manejadores de eventos .NET (delegates)
- Gran rendimiento en llamadas a métodos, propiedades, porque internamente usar CallSite en lugar de  Reflection (el mismo método usado por el lenguaje C# para dar soporte a variables ```dynamic```)


# Ventajas sobre wwDotnetBridge

- Código más fácil de escribir! Llamadas a métodos, obtener/asignar propiedades, campos usando directamente el nombre.
- Soporte para  crear delegados y  añadir/eliminar eventos. SÍ! kodnet soporta DELEGADOS sin registrar ningún componente VFP.
- Crear instancias de clases genéricas.
- Soporte real para código asíncrono.
- Compilar código C# dinámicamente.
- Soporte para incluir controles visuales dentro de formularios VFP.
- Mayor rendimiento. Más eficiente en obtener/asignar propiedades, campos y hasta 10 veces más eficiente en llamadas a métodos.



# Cómo usar

Lea [DOCS.md](./DOCS.md)



# ¿Necesita un trabajo específico?

Kodnet puede realizar cualquier cosa. Pero si usted no sabe como implementarlo, contáctenos y cotizamos

 - developer@kodhe.com
