; When using "runas /user:..." in windows it can get confusing to identify what account a given window
; is running under. This appends "owned by <username>" to the currently focused window, making it easy to check.  

#include <WinAPIEx.au3>
#Include <Array.au3>
#RequireAdmin 


While ( True ) 

	Sleep( 1000 )

	Local $iPID = 0
	Do
		$handle = WinGetHandle("[ACTIVE]", "") 
		$iPID = WinGetProcess($handle)
	Until $iPID > 0
	Local $aUser = _WinAPI_GetProcessUser($iPID)

	
	If Not (@error Or @extended) Then
	
		$UserName=$aUser[0]
		$title = WinGetTitle ( $handle )
		$result = StringInStr($title, "Owned By")

		If ( $Result == 0 ) Then
			WinSetTitle($handle, "", $title & " - Owned By " & $UserName)
			$title = WinGetTitle ( $handle )
		EndIf
		Else 
		;	TrayTip("Warning","WindowTitle.au3 couldn't get user.",3)
	EndIf

WEnd
