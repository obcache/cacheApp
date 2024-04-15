;MaintainBuild.ahk
#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

; if (InStr(A_LineFile,A_ScriptFullPath)){
	; Run(A_ScriptDir "/../cacheApp.ahk")
	; ExitAppE
	; Return
; }

MainScriptFile := "E:\Documents\Resources\AutoHotKey\__cacheApp\cacheApp.ahk"
Loop Read MainScriptFile, MainScriptFile "-tmp"
{
	CurrLine := A_LoopReadLine
   If (A_Index == 1)
	{ 
		OldBuildNumber := FileRead("E:\Documents\Resources\AutoHotKey\__cacheApp\cacheApp_currentBuild.dat")
		BuildNumber := OldBuildNumber + 1
		FileDelete("E:\Documents\Resources\AutoHotKey\__cacheApp\cacheApp_currentBuild.dat")
		FileAppend(BuildNumber,"E:\Documents\Resources\AutoHotKey\__cacheApp\cacheApp_currentBuild.dat")
		A_BuildVersion := SubStr(BuildNumber,1,1) "." SubStr(BuildNumber,2,1) "." SubStr(BuildNumber,3,1) "." SubStr(BuildNumber,4,1)
		CurrLine := 'A_FileVersion := "' A_BuildVersion '"' 
	}
   FileAppend(CurrLine "`n")
}
msgBox(MainScriptFile "`n" OldBuildNumber)
FileMove(MainScriptFile,"E:\documents\resources\autoHotKey\__cacheApp\backups\cacheApp-" OldBuildNumber ".ahk")
FileMove(MainScriptFile "-tmp",MainScriptFile,1)
RunWait('"c:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe" /in "E:\Documents\Resources\AutoHotKey\__cacheApp\cacheApp.ahk" /out "E:\Documents\Resources\AutoHotKey\__cacheApp\Bin\cacheApp_' BuildNumber '.exe"')
;FileCreateShortcut("E:\Documents\Resources\AutoHotKey\__cacheApp\Bin\cacheApp_" BuildNumber ".exe","e:\desktop\cacheApp.lnk")
if (FileExist(A_Desktop "/cacheApp.lnk"))
	FileDelete(A_Desktop "\cacheApp.lnk")
FileCreateShortcut("E:\Documents\Resources\AutoHotKey\__cacheApp\Bin\cacheApp_" BuildNumber ".exe", A_Desktop "\cacheApp.lnk",,,"cacheApp-Latest Build",,"i")
if (FileExist("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_cacheApp.lnk"))
	FileDelete("C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_cacheApp.lnk")
FileCreateShortcut("E:\Documents\Resources\AutoHotKey\__cacheApp\Bin\cacheApp_" BuildNumber ".exe", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\_cacheApp.lnk",,,"cacheApp-Latest Build",,"i")