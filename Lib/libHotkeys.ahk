#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}


^+a:: {
	toggleAfk()
}
^+[:: {
	static currOutputDeviceNum := 1
	ui.audioDevices := array()

	regAudioDevices := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
	cfg.allowedAudioOutput := ["S2MASTER","G432","Realtek","Yeti Classic","Tango"]

	RunWait('.\redist\SoundVolumeView.exe /scomma .tmp /columns "Device Name,Type,Name,Direction" | .\redist\GetNir.exe ""')
	loop read, ".\.tmp" {
		lineArr := strSplit(a_loopReadLine,",")
		if lineArr[2] == "Device" && lineArr[4] == "Render" && !inStr(lineArr[1],"VB-Audio") && !inStr(lineArr[1],"NVIDIA") && lineArr[3] != "Monitor"
			ui.audioDevices.push(lineArr[1] "\" lineArr[2] "\" lineArr[3] "\" lineArr[4])
	}

	tmpStr := ""
	loop ui.audioDevices.length {
		tmpStr .= ui.audioDevices[A_Index] "`n"
	}

		currOutputDeviceNum += 1	
	Run('.\Redist\soundVolumeView.exe /SetDefault "' ui.audioDevices[currOutputDeviceNum] '" "all"')
	TrayTip("Audio Changed:`n " strSplit(ui.audioDevices[currOutputDeviceNum],"\")[1],"CacheApp Audio Mgr","Iconi Mute")
}

; !^c::darknessdarkness
; {
	; ToggleAutoClicker()
; }

; ^+r::
; {
	; robl := object()
	; robl.client_pid 	:= ""
	; robl.app_pid 	:= ""
	; robl.appRunning := false
	; robl.clientRunning := false
	; while winExist("ahk_exe RobloxPlayerInstaller.exe") {
		; processClose(winGet("PID"))
		; sleep(500)
	; }
	; robl.client_pid := run(regRead("HKEY_CLASSES_ROOT\roblox\DefaultIcon"))
	; runApp('Roblox')
	; runApp(appName) { ; https://www.autohotkey.com/boards/viewtopic.php?p=438517#p438517
		; for app in ComObject('Shell.Application').NameSpace('shell:AppsFolder').Items
			; (app.Name = appName) && robl.app_pid := run('explorer shell:appsFolder\'  app.Path,,,&app_pid)	
	; }
	; timeout := 0
	; while !(winActive("ahk_exe ApplicationFrameHost.exe") && winActive("ahk_exe RobloxPlayerBeta.exe")) && timeout < 10  {
		; timeout += 1
		; sleep(2000)
		; if !winExist("ahk_exe RobloxPlayerInstaller.exe") && winExist("ahk_exe RobloxPlayerBeta.exe")
			; robl.clientRunning := true
		; if winExist("ahk_exe ApplicationFrameHost.exe") 
			; robl.appRunning := true
		; if timeOut >= 10 {
			; msgBox('timed out')
			; return
		; }
		; if (robl.clientRunning) && (robl.appRunning) {
			; winWait("ahk_exe RobloxPlayerBeta.exe")
			; winActivate()
			; winWaitActive()
			; winMove(-7,0,1734,1399)
			; winWait("ahk_exe ApplicationFrameHost.exe")
			; winActivate()
			; winWaitActive()
			; winMove(1713,0,1734,1399)
			; break
		; }
	; }
; }



^!+v:: {
	incursionNotice("manualFire")
}