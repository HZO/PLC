#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=..\..\..\..\Downloads\Automate_faster.Exe
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductName=Automate_Faster
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_CompanyName=HZO
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
Local $logvalue = 3600           ; add to log every time the counter is a muiltiple of this

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

if WinExists ($pintitle, "") Then
	WinActivate ($pintitle,"")

	send ($stringvalue)   ; send incremental code
	send ("{ENTER}")      ; Hit Enter to test.
	sleep (10) ;wait 0.01 seconds

	; write to log in case the app stops early. You can see which value was last tested and update the app to start from that incread of from beginning.
	if Mod ($password, $logvalue) = 0 Then
		WriteErrorLog ($stringvalue)
	EndIf

	; increase PIN counter
    $password = $password + 1
EndIf
If WinExists ($errortitle,"") Then
	WinActivate ($errortitle,"")

	send ("{ENTER}")

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