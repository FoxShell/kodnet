
#define FORMAT_MESSAGE_ALLOCATE_BUFFER 0x00000100
#define FORMAT_MESSAGE_IGNORE_INSERTS 0x00000200
#define FORMAT_MESSAGE_FROM_SYSTEM 0x00001000

LOCAL localPath
localPath= JUSTPATH(SYS(16))

if(TYPE("_screen.dotnet4")=="O" and !isnull(_screen.dotnet4))
	if(TYPE("_screen.dotnet4manager")=="O" and !isnull(_screen.dotnet4manager))
		RETURN 
	ENDIF 
ENDIF 
SET PATH TO (m.localpath) additive
SET PATH TO (m.localpath+"/lib") additive
*DO wwDotnet4

* Programa creado por Michael Suárez para interactura con .NET desde VFP ...
LOCAL dotnet4

dotnet4 = CREATEOBJECT("jxshell_dotnet4")
dotnet4.path = m.localpath+"\"
dotnet4.libPath = dotnet4.path + "lib\"


* Ahora se debe cargar el ensamblado encargado de todo ...
dotnet4.initClr()
LOCAL manager
manager = dotnet4.getClr()

_screen.AddProperty("dotnet4Manager", m.dotnet4)
_screen.AddProperty("__dotnet4", m.manager)
_screen.AddProperty("__dotnetv", CREATEOBJECT("kodnet"))
_screen.AddProperty("dotnet4", m.manager)
_screen.AddProperty("kodnet", m.manager)
_screen.AddProperty("kodnetManager", m.dotnet4)
RETURN manager

DEFINE CLASS jxshell_dotnet4ui as session
	dataSession=1
	anchorStyles = null
	_anchorStyles = null
	
	FUNCTION anchorStyles_access()
		if(ISNULL(this._anchorStyles))
			this._anchorStyles= _Screen.dotnet4.getStaticWrapper("System.Windows.Forms.AnchorStyles")
		ENDIF 
		RETURN this._anchorStyles
	ENDFUNC 
ENDDEFINE 

* THIS CLASSES (kodnet, kodnetWrapper) ARE FOR A EXPERIMENT TRYING TO INCREASE PERFORMANCE IN LOADING TIME
* AND REALLY CAN INCREASE PERFORMANCE ON LOADING TIME, BUT DECREASES ON INVOKING METHODS
DEFINE CLASS kodnetWrapper as session  
	__helper= null 
	___obj= null
	FUNCTION init(helper, obj)
		this.__helper= m.helper
		this.___obj= obj
		this.init_class()
	ENDFUNC 
	FUNCTION init_class()
	ENDFUNC 

ENDDEFINE 

DEFINE CLASS kodnet as Custom 

	helpers= null
	tmpfolder= null 
	FUNCTION init()
		LOCAL folder 
		this.helpers= CREATEOBJECT('collection')
		folder= GETENV("APPDATA")
		folder= ADDBS(m.folder) + "kodnet"
		IF !DIRECTORY(m.folder)
			MKDIR (m.folder )
		ENDIF 
		folder= ADDBS(m.folder) + "tmp"
		IF !DIRECTORY(m.folder)
			MKDIR (m.folder )
		ENDIF 
		this.tmpfolder= m.folder
	ENDFUNC 
	
	FUNCTION compile(ast, typeD)
		LOCAL file , val 
		val= null 
		file= ADDBS(this.tmpfolder) + SYS(2015) + ".prg"
		TRY 
			STRTOFILE(m.ast.code, m.file) 
			SET procedure TO (m.file) ADDITIVE 
			val= CREATEOBJECT(m.ast.staticName, m.typeD)
		CATCH TO ex 
			error  m.ex.message
		FINALLY 
			IF FILE(m.file)
				DELETE FILE m.file
			ENDIF 
		ENDTRY 
		RETURN m.val 
	
	ENDFUNC 
	
	FUNCTION create(helper)
		RETURN CREATEOBJECT("kodnetWrapper", m.helper)
	ENDFUNC 
	
	FUNCTION getStaticWrapper(type)
		LOCAL typeD, helper
		typeD= NULL 
		helper= null 
		TRY 
			helper= this.helpers[m.type]
		CATCH TO er 
		ENDTRY
		IF ISNULL(m.helper)
			typeD= _screen.__dotnet4.loadTypeNoCompile(m.type)
			helper= _screen.__dotnet4.vfpHelper(m.typeD)
			
			* compile class 
			ast= m.helper.compile()
			helper= this.compile(m.ast, m.helper)
			* helper= this.create(m.helper)
			this.helpers.Add(m.helper, m.type)
		ENDIF 
		
		RETURN m.helper
		
	ENDFUNC 

ENDDEFINE 

DEFINE CLASS jxshell_event as custom
	target=null
	_method=''
	
	FUNCTION init(target,method)
		IF !(m.target.baseclass == "Form")
			this.target= m.target
			this._method = m.method
		
			ADDPROPERTY(this.target, "_event_" + m.method, this)
		ENDIF
		
		* THIS NOT WORKING ON VFPA
		BINDEVENT(this, "invoke", m.target, m.method)	
	ENDFUNC 
	
	FUNCTION invoke()
		LPARAMETERS e1,e2,e3,e4,e5,e6
	ENDFUNC 
	FUNCTION destroy()
		this.target= null
	ENDFUNC 

ENDDEFINE 

DEFINE CLASS jxshell_dotnet4 as Session
	
	dataSession=1
	manager = null
	path = ""
	libPath = ""
	wwDotnet = null
	API = null
	ui= null
	initedUi= .f.
	
	FUNCTION init()
		this.API= CREATEOBJECT("JXSHELLDOTNET4_WIN32API")
		this.ui = CREATEOBJECT("jxshell_dotnet4ui")
	ENDFUNC 
	
	FUNCTION getClr()
		RETURN this.manager
	ENDFUNC 
	
	FUNCTION setClassLoadingMode(mode)
		* 0 - compile with c#
		* 1 - compile with VFP 
		IF mode == 0
			_screen.dotnet4= _screen.__dotnet4 
			_screen.kodnet= _screen.__dotnet4 
		ENDIF 
		IF mode == 1
			_screen.dotnet4= _screen.__dotnetv 
			_screen.kodnet= _screen.__dotnetv
		ENDIF 
		
	ENDFUNC 
	FUNCTION getWrapped(obj)
		LOCAL cls 
		IF vartype(m.obj)=='O'
			cls=_screen.__dotnetv.getStaticWrapper(m.obj.name)
			obj= m.cls.___create(m.obj.value)
		ENDIF 
		RETURN obj 
	ENDFUNC 
	FUNCTION getUnWrapped(obj)
		IF vartype(m.obj) == "O"
			RETURN m.obj.__obj
		ENDIF 
		RETURN obj 
	ENDFUNC 
	FUNCTION initUi()
		if(!this.initedUi)
			_screen.dotnet4.loadAssemblyPartialName("System")
			_screen.dotnet4.loadAssemblyPartialName("System.Drawing")
			_screen.dotnet4.loadAssemblyPartialName("System.Windows.Forms")
			
			_screen.dotnet4.loadManyTypes("System.Drawing.Font-System.EventHandler-System.EventArgs-System.Windows.Forms.Form-System.Windows.Forms.Application-System.Windows.Forms.Button-System.Windows.Forms.ComboBox-"+;
				"System.Windows.Forms.TextBox-System.Windows.Forms.Control-System.Drawing.Color-System.Drawing.Bitmap"+;
				"-System.Drawing.PointF-System.Drawing.RectangleF-System.Drawing.Point-System.Drawing.Rectangle")
				
			LOCAL app
			app= _screen.dotnet4.getStaticWrapper("System.Windows.Forms.Application")
			app.enableVisualStyles()
			
			this.initedUi= .t.
		ENDIF 
	ENDFUNC 
	
	FUNCTION createEventHandler(object, method, className)
		if(EMPTY(m.className))
			className = "System.EventHandler" 
		ENDIF 
		LOCAL ev, even
		ev = _Screen.dotnet4.getStaticWrapper(m.className)
		
		
		*even= CREATEOBJECT("jxshell_event", m.object, m.method)
		*RETURN ev.construct(m.even, "invoke")
		
		IF !(m.object.baseclass == "Form")
			*even= CREATEOBJECT("jxshell_event", m.object, m.method)
		endif 
		
		
		ev0 = ev.construct(m.object, m.method)
		
		*try
		*	addproperty(m.object, "_event_" + m.method, null)
		*catch to er 
		*endtry 
		*str = "m.object._event_" + m.method + "=m.ev0"
		*&str 

		return ev0
		
	ENDFUNC 


	FUNCTION rgbtoArgb
		LPARAMETERS tnColor, tnAlpha
	 	Local argb, red, green, blue
	 	blue = Bitrshift(Bitand(tnColor, 0x00FF0000), 16)
	 	green = Bitrshift(Bitand(tnColor, 0x0000FF00), 8)
	 	red = Bitand(tnColor, 0x000000FF)
	 	argb = blue + Bitlshift(green, 8) + Bitlshift(red, 16)
	 	If Vartype(tnAlpha) = 'N'
	 		argb = argb + Bitlshift(Bitand(tnAlpha, 0xFF), 24)
	 	Else
	 		argb = argb + Bitlshift(255, 24)
	 	ENDIF
	 	RETURN ARGB
	ENDFUNC 	
	
	FUNCTION initClr()
		if(!ISNULL(this.manager))
			RETURN 
		ENDIF 
		LOCAL dotnet4File, er, er1
		dotnet4File = this.libpath + "jxshell.dotnet4.dll"

		try
			

			* ya no es necesario el código de CLRHOST
			* automáticamente se registra al usuario (no admin rights)
			* al instalar 
			this.manager = CREATEOBJECTEX("{9173A427-2F3B-405D-9B0F-23C7B7048114}","")
			
			this.manager.init()
			this.manager.setThreadedLibraryFile(this.libpath+"lib.dll")
		CATCH TO ex
			er = ex.message
			er1= ex.ErrorNo
			
		ENDTRY 
		if(!EMPTY(m.er))
			ERROR m.er1, m.er
		ENDIF 			

	ENDFUNC 
	
ENDDEFINE

DEFINE CLASS JXSHELLDOTNET4_WIN32API AS Session
	datasession =1
	
	FUNCTION init()
		* Funciones del API
		DECLARE INTEGER FormatMessage IN kernel32 as jxshelldotnet4_formatMessage;
		    INTEGER   dwFlags,;
		    integer   lpSource,;
		    INTEGER   dwMessageId,;
		    INTEGER   dwLanguageId,;
		    INTEGER @ lpBuffer,;
		    INTEGER   nSize,;
		    INTEGER   Arguments
		    
		    
		DECLARE long GetLastError IN kernel32 as jxshelldotnet4_lastError 
		
		DECLARE long SetParent IN WIN32API as jxshelldotnet4_setParent;
			LONG,LONG
			
		DECLARE long GetParent IN WIN32API as jxshelldotnet4_getParent;
			LONG
			
		DECLARE long GetForegroundWindow IN WIN32API as jxshelldotnet4_getForegroudWindow
		
	ENDFUNC 
	
	FUNCTION setParent(controlHandle, form)
		LOCAL o
		o= form
		if(TYPE("m.form")="O")
			o= form.hwnd 
		ENDIF 
		
		LOCAL ret
		ret = jxshelldotnet4_setParent(m.controlHandle, m.o)
		if(m.ret = 0)
			&& Significa que falló ...
			ret = jxshelldotnet4_lastError ()
			IF m.ret = 0
				ERROR("Falló asignando el objeto parent al control. Error desconocido.")
				RETURN .f.
			else	
				
				LOCAL flags
				flags = BITOr(FORMAT_MESSAGE_ALLOCATE_BUFFER ,;
					 FORMAT_MESSAGE_FROM_SYSTEM ,FORMAT_MESSAGE_IGNORE_INSERTS)
				
				LOCAL message, len
				message = 0 &&SPACE(4096)
				len = jxshelldotnet4_formatMessage(m.flags, 0, m.ret, 0, @message, 0, 0)
				ERROR("Falló asignando el objeto parent al control. " + SYS(2600,m.message,m.len))
				RETURN .f.
				
				
			ENDIF 
			
			
		ENDIF 
	ENDFUNC 
	
ENDDEFINE 

FUNCTION await(toTask)
	LOCAL lcERR 
	DECLARE Sleep IN kernel32 as await_sleep integer
	
	DO WHILE NOT toTask.IsCompleted
		await_sleep(100)
	ENDDO 
	
	CLEAR DLLS 'await_sleep'

	IF toTask.IsFaulted
		lcERR = toTask.Exception.ToString()
		ERROR lcErr
	ENDIF 
	
	RETURN toTask.Result
ENDFUNC 