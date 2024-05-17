#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) {
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}

wm_windowPosChanged(wParam, lParam, msg, Hwnd) {
	global
	try {
		switch hwnd {
			case ui.mainGui.hwnd:
				if (!ui.afkDocked) {
					winGetPos(&winX,&winY,,,ui.mainGui)
					mainGuiX := winX
					mainGuiY := winY
					ui.AfkGui.Move((mainGuiX+45),(mainGuiY+50),270,)

					ui.titleBarButtonGui.Move((mainGuiX+456)*(A_ScreenDPI/96),(mainGuiY-3)*(a_screenDpi/96))
					ui.gameSettingsGui.move((mainGuiX+35)*(A_ScreenDPI/96),(mainGuiY+32)*(A_ScreenDPI/96))
					ui.editorGui.move((mainGuiX+35)*(A_ScreenDPI/96),(mainGuiY+32)*(A_ScreenDPI/96))
					ui.gameTabGui.move((mainGuiX+35)*(A_ScreenDPI/96),(mainGuiY+184)*(A_ScreenDPI/96))
				}
				


			case ui.pbConsoleBg.hwnd:
				winGetPos(&winX,&winY,,,ui.pbConsoleBg.hwnd)
				ui.pbConsole.move(winX,winY)
		} 
	}
}

wm_LButtonDown(*) {
	postMessage("0xA1",2)
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

drawPanel(targetGui,panelX,panelY,panelW,panelH,panelColor,outlineColor,outlineColor2,outlineWidth := 1,outlineOffset := 1,labelPos := .5,labelW := 100,labelText := "Demo Panel",labelFont := "Calibri",labelFontColor := "white") {
	labelH := 15
	static panelId := 0
	panelId+=1

	ui.backPanel%panelId% := targetGui.addText("x" panelX " y" panelY " w" panelW " h" panelH " background" panelColor)		
	ui.panelOutline2%panelId% := targetGui.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineOffset*2 " h" panelH-outlineOffset*2 " background" outlineColor2)		
	ui.panelOutline1%panelId% := targetGui.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineWidth-outlineOffset*2 " h" panelH-outlineWidth-outlineOffset*2 " background" outlineColor)	
	ui.panel%panelId% := targetGui.addText("x" panelX+outlineWidth+outlineOffset " y" panelY+outlineWidth+outlineOffset " w" panelW-outlineWidth*2-outlineOffset*2 " h" panelH-outlineWidth*2-outlineOffset*2 " background" panelColor)	

	if (labelPos != "none") {
		labelX := panelX+panelW*labelPos
		labelY := panelY
		

		ui.label%panelId% := targetGui.addText("x" labelX " y" labelY+outlineWidth " w" labelW " h" labelH " background" outlineColor,"")
		
		ui.label%panelId%.setFont("s10")
		
		ui.labelTop%panelId% := targetGui.addText("x" labelX+1 " y" labelY " w" labelW-2 " h" labelH " background" cfg.themeBackgroundColor " center c" labelFontColor) 
		
		ui.labelTop%panelId%.setFont("s10")
		ui.labelBottom%panelId% := targetGui.addText("x" labelX+1 " y" labelY-1 " w" labelW-2 " h" labelH " backgroundTrans center c" labelFontColor, labelText) 
		
		ui.labelBottom%panelId%.setFont("s10")

		;ui.mainGui.show("w500 h500")		
	}
}
