#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}


WM_WINDOWPOSCHANGED(wParam, lParam, msg, Hwnd) {
	try
		collateGuis(hwnd)
}

collateGuis(hwnd) {
	try {
		switch hwnd {
			case ui.mainGui.hwnd:
				if (!ui.afkDocked) {
					winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui)
					ui.AfkGui.Move((mainGuiX+45),(mainGuiY+50),270,)
					ui.titleBarButtonGui.Move((mainGuiX+456)*(A_ScreenDPI/96),(mainGuiY-3)*(a_screenDpi/96))
					ui.gameSettingsGui.move((mainGuiX+35)*(A_ScreenDPI/96),(mainGuiY+32)*(A_ScreenDPI/96))
					ui.gameTabGui.move((mainGuiX+35)*(A_ScreenDPI/96),(mainGuiY+184)*(A_ScreenDPI/96))
					ui.gameSettingsLinkGui.move((mainGuiX+35+12)*(A_ScreenDPI/96),(mainGuiY+32+79)*(A_ScreenDPI/96))
				}
			case ui.pbConsoleBg.hwnd:
				winGetPos(&winX,&winY,,,ui.pbConsoleBg.hwnd)
				ui.pbConsole.move(winX,winY)
		} 
	}
}



{ ;mouse events

WM_LBUTTONDOWN_callback(thisControl,info) {
	postMessage("0xA1",2,,,"A")
	;WM_LBUTTONDOWN(0,0,0,thisControl)	
}


WM_LBUTTONDOWN_pBcallback(*) {
	WM_LBUTTONDOWN(0,0,0,ui.pbConsole.Hwnd)
}

WM_LBUTTONDOWN(wParam, lParam, msg, Hwnd) {
	;ShowMouseClick()
		postMessage("0xA1",2)

		; try {
			; if (Hwnd = ui.MainGui.hwnd) 
			; PostMessage("0xA1",2)
		; }
		; try {	
			; if (Hwnd = ui.titleBarButtonGui.Hwnd) 
			; PostMessage("0xA1",2)
		; }
		; try {
			; if (hwnd == ui.dividerGui.hwnd) 
			; PostMessage("0xA1",2)
		; }
		; try {
			; if (hwnd == ui.afkGui.hwnd)
			; PostMessage("0xA1",2)
		; }
		; try {
			; if (hwnd == ui.pbConsole.hwnd)
			; PostMessage("0xA1",2)
		; }
		; try {
			; if (hwnd == ui.pbConsoleHandle.hwnd)
			; PostMessage("0xA1",2)
		; }
		; try {
		; if (hwnd == ui.dividerGui.hwnd)
		; {
		; keyWait("LButton")
		; MonitorGetWorkArea(cfg.AppDockMonitor, &Left, &Top, &Right, &Bottom)
		; coordMode("mouse","screen")
		; MouseGetPos(&mX,&mY,&currWin)
		; winMove(,mY,,Bottom-mY+8,"ahk_exe " ui.app2filename.text)
		; winMove(,Top,,mY-Top,"ahk_exe " ui.app1filename.text)
		; winActivate(ui.dividerGui)
		; }
		; }
}

wm_mouseMove(wParam, lParam, msg, hwnd) {
	static prevHwnd := 0
    if (hwnd != prevHwnd) {
		toolTip()
		this_control := guiCtrlFromHwnd(hwnd)
		if (this_control.hasProp("ToolTip") && cfg.toolTipsEnabled) || this_control.hasProp("ToolTipData") {
			setTimer () => toolTipDelayStart(this_control), -850
		}
		prevHwnd := Hwnd
	}
}


toolTipDelayStart(origGuiCtrl) {
	mouseGetPos(,,&currCtrlWin,&currCtrlClass)
	try {
		if origGuiCtrl.hwnd == controlGetHwnd(currCtrlClass,currCtrlWin) {
			if origGuiCtrl.hasProp("ToolTipData")
				toolTip(origGuiCtrl.toolTipData)
			else
				toolTip(origGuiCtrl.toolTip)
			setTimer () => toolTip(), -10000
		}
	}
}


} ;end mouse EVENTS##############
;end modal guis
	
{ ;window utilities

togglePIP() {
	if (!WinExist("ahk_id " ui.Win2Hwnd) 
		|| !WinExist("ahk_id " ui.Win1Hwnd)) {
			debugLog("PiP: Can't find 2 Game Windows.")
		try {
		stopPip()
		}
		Return
	}

	if (WinGetTransparent("ahk_id " ui.Win1Hwnd)) {
		if (WinGetTransparent("ahk_id " ui.Win1Hwnd) < 150) {
			WinMove(0,0,A_ScreenWidth,A_ScreenHeight,"ahk_id " ui.Win1Hwnd)
			WinSetAlwaysOnTop(0,"ahk_id " ui.Win1Hwnd)
			WinSetStyle("+0xC00000","ahk_id " ui.Win1Hwnd)
			WinSetTransparent(255,"ahk_id " ui.Win1Hwnd)

			WinMove(10,A_ScreenHeight-650,800,600,"ahk_id " ui.Win2Hwnd)
			WinSetAlwaysOnTop(1,"ahk_id " ui.Win2Hwnd)
			WinSetStyle("-0xC00000","ahk_id " ui.Win2Hwnd)
			WinSetTransparent(125,"ahk_id " ui.Win2Hwnd)
		} else {
			WinMove(0,0,A_ScreenWidth,A_ScreenHeight,"ahk_id " ui.Win2Hwnd)
			WinSetAlwaysOnTop(0,"ahk_id " ui.Win2Hwnd)
			WinSetStyle("+0xC00000","ahk_id " ui.Win2Hwnd)
			WinSetTransparent(255,"ahk_id " ui.Win2Hwnd)

			WinMove(10,A_ScreenHeight-650,800,600,WindowswID)
			WinSetAlwaysOnTop(1,"ahk_id " ui.Win1Hwnd)
			WinSetStyle("-0xC00000","ahk_id " ui.Win1Hwnd)
			WinSetTransparent(125,"ahk_id " ui.Win1Hwnd)
		}
	} else {
			WinMove(0,0,A_ScreenWidth,A_ScreenHeight,"ahk_id " ui.Win1Hwnd)
			WinSetAlwaysOnTop(0,"ahk_id " ui.Win1Hwnd)
			WinSetStyle("+0xC00000","ahk_id " ui.Win1Hwnd)
			WinSetTransparent(255,"ahk_id " ui.Win1Hwnd)

			WinMove(10,A_ScreenHeight-650,800,600,"ahk_id " ui.Win2Hwnd)
			WinSetAlwaysOnTop(1,"ahk_id " ui.Win2Hwnd)
			WinSetStyle("-0xC00000","ahk_id " ui.Win2Hwnd)
			WinSetTransparent(125,"ahk_id " ui.Win2Hwnd)
	}

		WinSetAlwaysOnTop(0,"ahk_id " ui.Win2Hwnd)
			WinSetStyle("+0xC00000","ahk_id " ui.Win2Hwnd)
			WinSetTransparent(255,"ahk_id " ui.Win2Hwnd)
			
	StopPip() {
		WinMove(0,0,(A_ScreenWidth/2),(A_ScreenHeight-getTaskbarHeight()),"ahk_id " ui.win1Hwnd)
		WinMove(A_ScreenWidth/2,0,(A_ScreenWidth/2),(A_ScreenHeight-getTaskbarHeight()),"ahk_id " ui.win2Hwnd)
		WinSetAlwaysOnTop(0,"ahk_id " ui.win1Hwnd)
		WinSetAlwaysOnTop(0,"ahk_id " ui.win2Hwnd)
		WinSetTransparent(255,"ahk_id " ui.win1Hwnd)
		WinSetTransparent(255,"ahk_id " ui.win2Hwnd)

	}
}
	
setGlass(accent_state, rgb_in:=0x0, alpha_in:=0xFF, hwnd:=0) {
    Static WCA_ACCENT_POLICY := 19, pad := A_PtrSize = 8 ? 4 : 0
        , max_rgb := 0xFFFFFF, max_alpha := 0xFF, max_accent := 3
    
    If (accent_state < 0) || (accent_state > max_accent)
        Return "Bad state value passed in.`nValue must be 0-" max_accent "."
    
    If (StrSplit(A_OSVersion, ".")[1] < 10)
        Return "Must be running > Windows 10"
    
    If (alpha_in < 0) || (alpha_in > max_alpha)
        Return "Bad alpha value passed in.`nMust be between 0x00 and 0xFF."
            . "`nGot: " alpha_in
    
    rgb_in += 0
    If (rgb_in < 0) || (rgb_in > max_rgb)
        Return "Bad RGB value passed in.`nMust be between 0x000000 and 0xFFFFFF."
            . "`nGot: " rgb_in
    
    (!hwnd) ? hwnd := WinActive("A") : 0
    ,abgr := (alpha_in << 24) | (rgb_in << 16 & 0xFF0000) | (rgb_in & 0xFF00) | (rgb_in >> 16 & 0xFF)
    ,accent_size := 16
    ,ACCENT_POLICY := Buffer(accent_size, 0)
    ,NumPut("int", accent_size, ACCENT_POLICY)
    ,(accent_state = 1 || accent_state = 2) ? NumPut("Int", abgr, ACCENT_POLICY, 8) : 0
    ,WINCOMPATTRDATA := Buffer(4 + pad + A_PtrSize + 4 + pad, 0)
    ,NumPut("int", WCA_ACCENT_POLICY, WINCOMPATTRDATA, 0)
    ,NumPut("ptr", ACCENT_POLICY.Ptr, WINCOMPATTRDATA, 4 + pad)
    ,NumPut("uint", accent_size, WINCOMPATTRDATA, 4 + pad + A_PtrSize)
    
    If !DllCall("user32\SetWindowCompositionAttribute"
            ,"ptr"   ,hwnd
            ,"ptr"   ,WINCOMPATTRDATA.Ptr)
        Return "SetWindowCompositionAttribute failed"
    
    ; This sets window transparency and is optional
    ; It can be commented in/out or have a permanent value set
    ;WinSetTransparent(alpha_in, "ahk_id " hwnd)
    Return 0
}


getTaskbarHeight() {
	MonitorGet(MonitorGetPrimary(),,,,&TaskbarBottom)
	MonitorGetWorkArea(MonitorGetPrimary(),,,,&TaskbarTop)
	TaskbarHeight := TaskbarBottom - TaskbarTop
	Return taskbarHeight
}


} ;end utility functions

drawPanel(targetGui,panelX,panelY,panelW,panelH,panelColor,outlineColor,outlineColor2,outlineWidth := 1,outlineOffset := 1,labelPos := .5,labelW := 100,labelText := "Demo Panel",labelFont := "Calibri",labelFontColor := "white") {
	labelH := 20
	static panelId := 0
	panelId+=1
	

	

	ui.backPanel%panelId% := targetGui.addText("x" panelX " y" panelY " w" panelW " h" panelH " background" panelColor)		

	ui.panelOutline2%panelId% := targetGui.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineOffset*2 " h" panelH-outlineOffset*2 " background" outlineColor2)		

	ui.panelOutline1%panelId% := targetGui.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineWidth-outlineOffset*2 " h" panelH-outlineWidth-outlineOffset*2 " background" outlineColor)	
		
	ui.panel%panelId% := targetGui.addText("x" panelX+outlineWidth+outlineOffset " y" panelY+outlineWidth+outlineOffset " w" panelW-outlineWidth*2-outlineOffset*2 " h" panelH-outlineWidth*2-outlineOffset*2 " background" panelColor)	

if (labelPos != "none") {
	labelX := panelX+panelW*labelPos
	labelY := panelY
	

	ui.label%panelId% := targetGui.addText("x" labelX " y" labelY+1 " w" labelW " h" labelH " background" outlineColor,"")
	
	ui.label%panelId%.setFont("s10")
	
	ui.labelTop%panelId% := targetGui.addText("x" labelX+1 " y" labelY " w" labelW-2 " h" labelH " background" cfg.themeBackgroundcolor " center c" labelFontColor) 
	
	ui.labelTop%panelId%.setFont("s10")
	ui.labelBottom%panelId% := targetGui.addText("x" labelX+1 " y" labelY+2 " w" labelW-2 " h" labelH " backgroundTrans center c" labelFontColor, labelText) 
	
	ui.labelBottom%panelId%.setFont("s10")		
	}
}