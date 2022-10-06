if(TYPE("_screen.kodnetHelper") == "U")
	_screen.AddProperty("kodnetHelper", .null.)
	_screen.AddProperty("kodnet", .null.)
	_screen.AddProperty("kodnetManager", .null.)
ENDIF 


_screen.kodnetHelper = CREATEOBJECT("kodnetClient")
_screen.kodnet = _screen.kodnetHelper.create()
_screen.kodnetManager =  _screen.kodnet.utils


DEFINE CLASS Kodnet6Client as Custom 

	kodnet = .null. 
	kodnetUtils = .null.
	lastException = .null.
	_clients = 0
	targets = .null.
	proxyClass= .null.
	
	FUNCTION init()
		this.targets = CREATEOBJECT("collection")
	ENDFUNC 
	
	FUNCTION create()
		IF ISNULL(this.kodnet)
			this.kodnet = CREATEOBJECT("FoxShell.KodnetCOM")
			*this.kodnet.setVfpCom(_vfp )
			this.kodnet.setVfpClient(this)
			*DISp= this.getrealReference(this.kodnet.vfp.internal_value)
			*this.kodnet.setVfpClient(m.disp)

			this.kodnetUtils = this.kodnet.utils
			this.proxyClass= this.kodnet.getStaticWrapper("FoxShell.Proxy")
		ENDIF 

		RETURN this.kodnet 
	ENDFUNC 
	
	FUNCTION SetVar(varname, value)
		_vfp.SetVar(m.varname, m.value)
	ENDFUNC 
	
	FUNCTION ProcessId()
		RETURN _vfp.ProcessId
	ENDFUNC 
	
	FUNCTION DoCmd(cmd)
		RETURN _vfp.DoCmd(m.cmd)
	ENDFUNC 

	FUNCTION GetRealReference(object)
		RETURN SYS(3095, m.object)
	ENDFUNC 

	FUNCTION Proxy(target)
		LOCAL col as Collection 
		col = this.targets 
		this._clients = this._clients + 1 
		str = ALLTRIM(STR(this._clients))
		m.col.Add(m.target, m.str)
		return this.proxyClass.construct(this._clients)	
	ENDFUNC
	
	FUNCTION Delegate(target, method)
		proxy = this.proxy(m.target)
		RETURN m.proxy.GetDelegate(m.method)
	ENDFUNC

	FUNCTION ProxyUnref(ptr)
		IF TYPE("m.ptr") == "O"
			m.ptr = m.ptr.id
		ENDIF 
	
		LOCAL col as Collection 
		col = this.targets 
		m.col.Remove(m.ptr)
	ENDFUNC
	
	
	FUNCTION Execute(target, method, args)
		LOCAL col as Collection 

		if type("m.target") == "N"
			col = this.targets 
			target = m.col.Item(ALLTRIM(STR(m.target)))
		ELSE 
			if type("m.target") == "C"
				col = this.targets 
				target = m.col.Item(m.target)
			endif 
		endif 
		
		str = ''
		FOR i=0 TO (m.args.length-1)
			IF i  > 0
				m.str = m.str + ","
			ENDIF  
			m.str = m.str + "m.args.get(" + ALLTRIM(STR(m.i)) + ")"
		ENDFOR 
		
		RETURN m.target.&method(&str)
	ENDFUNC
	
	
	FUNCTION Proxy_GetProperty(target, name)
		LOCAL col as Collection 

		if type("m.target") == "N"
			col = this.targets 
			target = m.col.Item(ALLTRIM(STR(m.target)))
		ELSE 
			if type("m.target") == "C"
				col = this.targets 
				target = m.col.Item(m.target)
			endif 
		endif 
		
		RETURN m.target.&name
	ENDFUNC
	
	FUNCTION Proxy_SetProperty(target, name, value)
		LOCAL col as Collection 

		if type("m.target") == "N"
			col = this.targets 
			target = m.col.Item(ALLTRIM(STR(m.target)))
		ELSE 
			if type("m.target") == "C"
				col = this.targets 
				target = m.col.Item(m.target)
			endif 
		endif 
		
		RETURN m.target.&name = m.value 
	ENDFUNC

	FUNCTION throwError(exception)
		this.lastException = m.exception
		ERROR(m.exception.toString())
	ENDFUNC 	

ENDDEFINE 