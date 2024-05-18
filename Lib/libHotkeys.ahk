#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}



; ^+/::
; {
	; mx := 0
	; coordMode("mouse","screen")
	; while (mx < a_screenwidth) {
		; if (getKeyState("Escape"))
			; Return
		; mouseMove(mx,-10,2)
		; mx += 1
		; sleep(1)
	; }
; }



; hotIf(SLCapsOn)
	; hotKey("w down",SLBHop)
; hotIf()

; SLCapsOn(*) {
	; if getKeyState("CapsLock","T") && winActive("ahk_exe shatterline.exe")
		; return 1
	; else
		; return 0
; }

; SLBHop(*) {
	; CoordMode("Mouse","Client")
	; send("{w down}")
	; sleep(400)
	; send("{LShift}")
	; Sleep(400)
	; MouseMove(-100,0,30,"R")
	; MouseMove(100,0,30,"R")
	; send("{Space}")
	; sleep(300)
	; while getKeyState("W") {
		; send("{Space}")
		; sleep(50)
	; }
; }

!+F:: {
	keyWait("F")
	if getKeyState("D") {
		launchApp("foobar2000")
	} else {
		launchApp("discord")
	}
	if winExist("ahk_exe discord.exe") && winExist("ahk_exe foobar2000.exe")
		dockApps()
}


; !^Backspace:: {
	; ui.MainGui.Move(30,A_ScreenHeight-ui.TaskbarHeight-GuiH)
	; winGetPos(,,,&GuiH,,ui.mainGui)
	; ToggleGuiCollapse()
; }

; +Esc:: {
	; resetWindowPosition()
; }



^+[:: {
	static currOutputDeviceNum := 1
	ui.audioDevices := array()
	
	; loop
	; {
		; try {
			; ui.audioDevices.push(SoundGetName(, devIndex := A_Index))
		; } catch
			; break
	; }
	
	; loop ui.audioDevices.length {
		; audioListStr .= ui.audioDevices[a_index] "`n"
	; }
	;msgBox(audioListStr)


regAudioDevices := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
allowedDevices := ["S2MASTER","G432","2nd Output","Yeti Classic","Tango"]
; currDev := ""
; loop reg regAudioDevices,"K" {
	; loop reg a_loopRegKey "\" a_loopRegName "\Properties\" {
		; currDev := regRead(a_loopRegKey,"{a45c254e-df1c-4efd-8020-67d146a850e0},2") " (" regRead(a_loopRegKey,"{b3f8fa53-0004-438e-9003-51a46e139bfc},6") ")"
		; loop allowedDevices.length {
			; if inStr(currDev,allowedDevices[A_Index]) {
				; isDupe := false
				; for dev in ui.audioDevices {
					; if dev == currDev	
						; isDupe := true
				; }
				; if !isDupe {
					; ui.audioDevices.push(currDev)
		
				; }
			; }	
		; }
	; }
; }


RunWait('.\redist\SoundVolumeView.exe /scomma .tmp /columns "Device Name,Type,Name,Direction" | .\redist\GetNir.exe ""')
loop read, ".\.tmp" {
	;msgBox(a_loopReadLine)
	lineArr := strSplit(a_loopReadLine,",")
	if lineArr[2] == "Device" && lineArr[4] == "Render" && !inStr(lineArr[1],"VB-Audio") && !inStr(lineArr[1],"NVIDIA") && lineArr[3] != "Monitor"
	ui.audioDevices.push(lineArr[1] "\" lineArr[2] "\" lineArr[3] "\" lineArr[4])
	;ui.audioDevices.push(lineArr[1])
}

tmpStr := ""
loop ui.audioDevices.length {
	tmpStr .= ui.audioDevices[A_Index] "`n"
}
	
;msgBox(tmpStr)



if currOutputDeviceNum == ui.audioDevices.length
	currOutputDeviceNum := 1
else
	currOutputDeviceNum += 1	
Run('.\Redist\soundVolumeView.exe /SetDefault "' ui.audioDevices[currOutputDeviceNum] '" "all"')
TrayTip("Audio Changed:`n " strSplit(ui.audioDevices[currOutputDeviceNum],"\")[1],"CacheApp Audio Mgr","Iconi Mute")
;Run("./Redist/nircmd.exe setdefaultsounddevice " ui.audioDevices[currOutputDeviceNum])
;TrayTip("setting audio device: " ui.audioDevices[currOutputDeviceNum])



; if currOutputDeviceNum > ui.audioDevices.length
	; currOutputDeviceNum := 1
; else
	; currOutputDeviceNum += 1	
; Run("./Redist/nircmd.exe setdefaultsounddevice " ui.audioDevices[currOutputDeviceNum])
; TrayTip("setting audio device: " ui.audioDevices[currOutputDeviceNum])




}

; ^Enter::
; {
	
		; togglePip()
	
	; }

; !^m::
; {
	; getClick(&clickX,&clickY,&activeWindow)
; }



; !^F::
; {
	; autoFire(0)
; }

; !^c::
; {
	; ToggleAutoClicker()
; }

; !^a::
; {
	; ToggleAFK()
; }

; !^t::
; {
	; ToggleTower()
; }

; !^w::
; {
	; ReturnToWorld()
; }
	
; !^d::
; {
	; ToggleAfkDock()
; }

;GameSettings HotKeys	
; ^+d::
; {
	; global
	; toggleOSD()
; }



