* call this file at start of application
do (getenv("Userprofile") + "\kawix\shide.lib\kodnet\kodnet.prg")

path= SYS(16)
SET PROCEDURE TO (m.path) additive


DEFINE CLASS HelperWebCam as Session
	Dimension __internalArray[1]
	
	
	FUNCTION arrayFromCollection(collection)
		LOCAL len
		len= m.collection.count
		DIMENSION this.__internalarray[MAX(len,1)]
		FOR i=0 TO len-1
			this.__internalarray[i+1]= m.collection.item[i]
		ENDFOR
		
		IF len=0
			RETURN null
		ENDIF  
		RETURN @this.__internalarray
	ENDFUNC 
	
	Function array(a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26)
		*** Esta función devuelve un array
		Local p,i
		p = pcount()
		If m.p = 0
			m.p = m.p + 1 
		EndIf 
		Dimension this.__internalArray[m.p]
		For i = 1 to m.p
			this.__internalArray[i] = Evaluate("m.a" + Alltrim(Str(i)))
		EndFor
		Return @this.__internalArray
	EndFunc 
	
	
ENDDEFINE 