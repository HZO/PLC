#include <MsgBoxConstants.au3>
#include <File.au3>

; Set the Escape hotkey to terminate the script.
HotKeySet("{ESC}", "_Terminate")

$pintitle = "Enter Password"
$errortitle = "Error!"
$connected = "Connecting"

FindPassword ()

Func FindPassword ()

; Local $realpassword = A1234567 ; this is the actual pwd
Local $startingvalue = "A"
Local $password = 0000000        ; starting password
Local $finalpassword = 9999999  ; this it the last password to try.

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
	send ($stringvalue)
	send ($password)
	send ("{ENTER}")
	sleep (100) ;wait 0.1 seconds
	
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