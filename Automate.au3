#include <MsgBoxConstants.au3>
#include <File.au3>

; Set the Escape hotkey to terminate the script.
HotKeySet("{ESC}", "_Terminate")

; This app monitors the Automation Direct 
; Made for https://www.automationdirect.com/adc/shopping/catalog/retired_products/programmable_controllers/d2-240 but other PLC units may work as well.
; Requires DirectSoft https://support.automationdirect.com/demos.html

; Windows title to enter password
$pintitle = "Enter Password"

; Window title if password is incorrect
$errortitle = "Error!"

; Window title if passowrd is correct
$connected = "Connecting"

FindPassword ()

Func FindPassword ()

; Starting value can be either A or 0, change this to suit your needs.
Local $startingvalue = "A"
Local $password = 0000000        ; starting password. If you know the password to have a different starting value you can add here. Otherwise the default will check all possible options.
Local $finalpassword = 9999999   ; this it the last password to try.

While $password <= $finalpassword

; Convert to string because the PIN can lead with many 0 values such as A0000001
$stringvalue = string($password)
Select
	Case $password < 10
		$stringvalue = "000000"&$password
	Case $password < 100
		$stringvalue = "00000"&$password
	Case $password < 1000
		$stringvalue = "0000"&$password
	Case $password < 10000
		$stringvalue = "000"&$password
	Case $password < 100000
		$stringvalue = "00"&$password
	Case $password < 1000000
		$stringvalue = "0"&$password
	Case $password < 10000000
		$stringvalue = $password
EndSelect

if WinExists ($pintitle, "") Then
	WinActivate ($pintitle,"")
	sleep (100) ;wait 0.1 seconds
	send ($startingvalue) ; send initial value (A or 0)
	send ($stringvalue)   ; send incremental code
	send ("{ENTER}")      ; Hit Enter to test.
	sleep (100) ;wait 0.1 seconds
	
	; write to log in case the app stops early. You can see which value was last tested and update the app to start from that incread of from beginning.
	WriteErrorLog ($stringvalue)
	
	; increase PIN counter
    $password = $password + 1	
EndIf
If WinExists ($errortitle,"") Then
	WinActivate ($errortitle,"")
	sleep (100) ;wait 0.1 seconds
	send ("{ENTER}")
	sleep (100) ;wait 0.1 seconds
EndIf

If WinExists ($connected,"") Then
	$pin = $password -1
	MsgBox($MB_SYSTEMMODAL, "", "Password: A" & $pin)
    ExitLoop
EndIf

WEnd
EndFunc

Func _Terminate()
        Exit
	EndFunc   ;==>_Terminate

Func WriteErrorLog($ErrorMessage)
    Local $Logfile = @WorkingDir & "\" & @ScriptName & ".log"
    Local $errorFile = $Logfile
    ; Local $LogTime = @HOUR & ":" & @MIN & ":" & @SEC
	Local $LogTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" &  @HOUR & ":" & @MIN & ":" & @SEC
    Local $hFileOpen = FileOpen($errorFile, 9)
    FileWriteLine($hFileOpen, $LogTime & " " & $ErrorMessage & @CRLF)
    FileClose($hFileOpen)
EndFunc   ;==>WriteErrorLog