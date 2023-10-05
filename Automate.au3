#include <MsgBoxConstants.au3>
#include <File.au3>

; Set the Escape hotkey to terminate the script.
HotKeySet("{ESC}", "_Terminate")

; This app monitors the Automation Direct
; Made for https://www.automationdirect.com/adc/shopping/catalog/retired_products/programmable_controllers/d2-240 but other PLC units may work as well.
; Requires DirectSoft https://support.automationdirect.com/demos.html

; Windows title to enter password
Global $pintitle = "Enter Password"

; Window title if password is incorrect
Global $errortitle = "Error!"

; Window title if password is correct
Global $connected = "Connecting"

; Window title if briowse window is active
Global $browserwindow = "Element Browser"

_FindPassword ()

Func _FindPassword ()

; Starting value can be either A or 0, change this to suit your needs.
Local $startingvalue = "A"
Local $password = 0000000        ; starting password. If you know the password to have a different starting value you can add here. Otherwise the default will check all possible options.
Local $finalpassword = 9999999   ; this it the last password to try.
Local $pin

	While $password <= $finalpassword

		; Convert to string because the PIN can lead with many 0 values such as A0000001
		$stringvalue = string($password)
		Select
			Case $password < 10
				$stringvalue = $startingvalue&"000000"&$password
			Case $password < 100
				$stringvalue = $startingvalue&"00000"&$password
			Case $password < 1000
				$stringvalue = $startingvalue&"0000"&$password
			Case $password < 10000
				$stringvalue = $startingvalue&"000"&$password
			Case $password < 100000
				$stringvalue = $startingvalue&"00"&$password
			Case $password < 1000000
				$stringvalue = $startingvalue&"0"&$password
			Case $password < 10000000
				$stringvalue = $startingvalue&$password
		EndSelect

		Select
			Case WinExists ($pintitle, "")
				; enter the PIN value in this window.
				WinActivate ($pintitle,"")
				send ($stringvalue)   ; send incremental code
				send ("{ENTER}")      ; Hit Enter to test.
				sleep (50) ;wait
				; write to log in case the app stops early. You can see which value was last tested and update the app to start from that incread of from beginning.
				_WriteErrorLog ($stringvalue)
				; increase PIN counter
				$password = $password + 1
			Case WinExists ($errortitle,"")
				; close this window
				WinActivate ($errortitle,"")
				; sleep (10) ;wait
				send ("{ENTER}")
			Case WinExists ($browserwindow,"")
				; close this window if it opens
				WinActivate ($browserwindow,"")
				sleep (50) ;wait
				send ("!x")
			Case WinExists ($connected,"")
				; stop password cracking
				$pin = $password - 1
				MsgBox($MB_SYSTEMMODAL, "", "Password: A" & $pin)
				ExitLoop
		EndSelect
	WEnd
EndFunc

Func _Terminate()
        Exit
	EndFunc   ;==>_Terminate

Func _WriteErrorLog($ErrorMessage)
    Local $Logfile = @WorkingDir & "\" & @ScriptName & ".log"
    Local $errorFile = $Logfile
    ; Local $LogTime = @HOUR & ":" & @MIN & ":" & @SEC
	Local $LogTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" &  @HOUR & ":" & @MIN & ":" & @SEC
    Local $hFileOpen = FileOpen($errorFile, 9)
    FileWriteLine($hFileOpen, $LogTime & " " & $ErrorMessage & @CRLF)
    FileClose($hFileOpen)
EndFunc   ;==>WriteErrorLog