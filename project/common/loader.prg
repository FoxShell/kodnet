
_screen.AddProperty("KodnetLoader", CREATEOBJECT("KodnetLoader"))

DEFINE class KodnetLoader as Custom

    v6 = .null.
    v4 = .null.

    FUNCTION Load(version as string)

        if((m.version == "v6") or (m.version == "net6"))


            if !isnull(this.v6)
                return this.v6
            endif 

            file = getenv("userprofile") + "\KwRuntime\kodnet-net6\kodnet.prg"
            if !file(m.file)
                file = getenv("programdata") + "\KwRuntime\kodnet-net6\kodnet.prg"
            endif 
        endif 


        if((m.version == "dotnet4") or (m.version == "v4"))

            if !isnull(this.v4)
                return this.v4
            endif 

            file = getenv("userprofile") + "\KwRuntime\kodnet\kodnet.prg"
            if !file(m.file)
                file = getenv("programdata") + "\KwRuntime\kodnet\kodnet.prg"
            endif 
        endif 

        if((m.version == "legacy"))

            * Cannot load legacy and v4 at same time
            if !isnull(this.v4)
                return this.v4
            endif 

            file = getenv("userprofile") + "\Kawix\Shide.lib\kodnet\kodnet.prg"
            if !file(m.file)
                file = getenv("programdata") + "\Kawix\Shide.lib\kodnet\kodnet.prg"
            endif 
        endif 


        if !empty(m.file)
            do (m.file)
            if((m.version == "v6") or (m.version == "net6"))
                this.v6 = CREATEOBJECT("kodnetGroup", _Screen.kodnet6, _Screen.kodnet6Helper, _Screen.kodnet6Manager)
                return this.v6
            else 
                this.v4 = CREATEOBJECT("kodnetGroup", _Screen.kodnet, _Screen.kodnetHelper, _Screen.kodnetManager)
                return this.v6
            endif 
        endif 

        return .null. 

    ENDFUNC


    Function Loadv6_OldMode()
        * Load .NET Core v6.x like kodnet with .NET Framework
        * using _screen.kodnet and _screen.kodnetManager

        v6 = this.load("v6")
        _screen.addproperty(_Screen, "kodnet", .null.)
        _screen.addproperty(_Screen, "kodnetHelper", .null.)
        _screen.addproperty(_Screen, "kodnetManager", .null.)

        _screen.kodnet = m.v6.com
        _screen.kodnetHelper = m.v6.helper
        _screen.kodnetManager = m.v6.utils

        return m.v6
    endfunc 

ENDDEFINE



define class KodnetGroup as custom 

    COM = .null.
    Helper = .null. 
    Utils = .null. 

    function init(com, helper, utils)
        this.com = m.com
        this.helper = m.helper
        this.utils = m.utils
    endfunc 

ENDDEFINE 
