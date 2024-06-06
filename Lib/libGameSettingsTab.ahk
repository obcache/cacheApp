#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}

{ ;global UI
	inputHookAllowedKeys := "{All}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Left}{Right}{Up}{Down}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}{Tab}{Enter}{ScrollLock}{LButton}{MButton}{RButton}"	

	GuiGameTab() {
		global	
		loop cfg.gameModuleList.length {
			if fileExist("./lib/lib" cfg.gameModuleList[A_Index])
				runWait("./lib/lib" cfg.gameModuleList[A_Index])
		}

		ui.gameSettingsGui := Gui()
		ui.gameSettingsGui.Name := "CacheApp"
		ui.gameSettingsGui.BackColor := cfg.themeBackgroundColor
		ui.gameSettingsGui.Color := cfg.themeBackgroundColor
		ui.gameSettingsGui.MarginX := 5
		ui.gameSettingsGui.Opt("-Caption -Border +AlwaysOnTop +ToolWindow +Owner" ui.MainGui.Hwnd)
		ui.gameSettingsGui.SetFont("s14 c" cfg.ThemeFont1Color,"Calibri")
		ui.gameTabs := ui.gameSettingsGui.addTab3("x-1 y-5 w497 h181 0x400 bottom c" cfg.themeFont1Color " choose" cfg.activeGameTab,cfg.gameModuleList)
		ui.gameTabs.choose(cfg.gameModuleList[cfg.activeGameTab])
		ui.gameTabs.setFont("s10")
		ui.gameTabs.onEvent("Change",gameTabChanged)
		ui.MainGui.GetPos(&winX,&winY,,)

	 Loop cfg.gameList.length {
			try {
				runWait("./lib/lib" cfg.gameList[a_index])
				ui.gameTabs.value([cfg.gameList[a_index]])
				ui.gameTabs.useTab(cfg.gameList[a_index])
			}
		}
	} 
} ;END global UI


{ ;Global UI Logic
	
	drawGameTabs(cfg.activeGameTab)
	;gameTabChanged()


	createButtonBar(*) {
		}
	gameTabChanged(*) {
		cfg.activeGameTab := ui.gametabs.value
		drawGameTabs(ui.gameTabs.value)
		guiVis(ui.gameTabGui,true)
		controlFocus(ui.buttonDockAfk)
	}

	drawGameTabs(tabNum := 1) {
		ui.gameTabWidth := 0
		try	 
			ui.gameTabGui.destroy()
		ui.gameTabGui := gui()
		ui.gameTabGui.opt("-caption toolWindow alwaysOnTop +E0x20 owner" ui.gameSettingsGui.hwnd)
		ui.gameTabGui.backColor := ui.transparentColor
		ui.gameTabGui.color := ui.transparentColor
		drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,227,28,cfg.themeBright1Color,cfg.themeBright1Color,1)
		
		winSetTransColor(ui.transparentColor,ui.gameTabGui)
		ui.gameTabGui.addText("x1 y0 w0 h27 section background" cfg.themeBright1Color,"")
		ui.gameTab1Skin := ui.gameTabGui.addText(
			((tabNum == 1) ? "ys+0 h27" : "ys+1 h26")
			" x+0 w110 section center background" 
			((tabNum == 1) ? cfg.themeBackgroundColor : cfg.themePanel4Color) 
			" c" ((tabNum == 1) ? cfg.themeFont1Color : cfg.themeFont4Color)
			,"")
		ui.gameTab1Skin.setFont((tabNum == 1 ? "s14" : "s12"),"Impact")
		ui.gameTab1Label := ui.gameTabGui.addText(
			((tabNum == 1) ? "ys+0 h27" : "ys+1 h26")
			" x+-110 w110 section center backgroundTrans c" 
			((tabNum == 1) ? cfg.themeFont1Color : cfg.themeFont4Color)
			,"Destiny 2")
		ui.gameTab1Label.setFont((tabNum == 1 ? "s14" : "s12"),"Impact")
		ui.gameTabWidth += 113
		((tabNum == 1)
			? ui.gameTabGui.addText("ys x+0  w2 h27 section background" cfg.themeBright1Color,"")
			: ui.gameTabGui.addText("ys-1 x+0  w2 h27 section background" cfg.themeBright1Color,""))
		ui.gameTab2Skin := ui.gameTabGui.addText(
			((tabNum == 2) 
				? "ys-1 h27" 
				: "ys+2 h25")
			" x+0 w112 section center background" 
			((tabNum == 2) 
				? cfg.themeBackgroundColor 
				: cfg.themePanel4Color)
			" c" ((tabNum == 2)
				? cfg.themeFont1Color 
				: cfg.themeFont4Color)
			,"")
		ui.gameTab2Skin.setFont(
			((tabNum == 2)
				? "s14" 
				: "s12")
			,"Impact")
		ui.gameTab2Label := ui.gameTabGui.addText(
			((tabNum == 2) 
				? "ys+0 h27" 
				: "ys+0 h27")
			" x+-112 w112 section center backgroundTrans c" 
			((tabNum == 2)
			? cfg.themeFont1Color 
				: cfg.themeFont4Color)
			,"World//Zero")
		ui.gameTab2Label.setFont(
			((tabNum == 2)
				? "s14" 
				: "s12")
			,"Impact")
		ui.gameTabWidth += 113
		((tabNum == 1)
			? ui.gameTabGui.addText("ys-1 x+0 w2 " (tabNum == 1 ? "h26" : "h27") " section background" cfg.themeBright1Color,"")
			: ui.gameTabGui.addText("ys+1 x+0 w2 " (tabNum == 1 ? "h26" : "h27") " section background" cfg.themeBright1Color,""))
		guiVis(ui.gameTabGui,false)
		if (winGetTransparent(ui.gameTabGui)) == 0 {
			ui.gameTabGui.addText("ys+1 x+0 w" 498-(ui.gameTabWidth+3) " h27 background" cfg.themePanel1Color)
			drawOutlineNamed("gameTabs",ui.gameTabGui,ui.gameTabWidth+3,4,498-ui.gameTabWidth-6,25,cfg.themeDark1Color,cfg.themeDark1Color,1)
			winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
			ui.gameTabGui.show("w497 h29 x" mainGuiX+35 " y" mainGuiY+184 " noActivate")
		} else {
			winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
			ui.gameTabGui.show("w228 h29 x" mainGuiX+35 " y" mainGuiY+184 " noActivate") 
		}
		;setTimer () => ui.gameTabGui.move(winX+35,winY+184,495,29),-3000

	}
}
			
{ ;d2 Logic
	setTimer(incursionNotice,15000)
	incursionNotice(*) {
		try {
			whr := ComObject("WinHttp.WinHttpRequest.5.1")
			whr.Open("GET","http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
			whr.Send()
			whr.WaitForResponse()
			ui.latestIncursion := whr.ResponseText
			cfg.lastIncursion := iniRead(cfg.file,"Game","LastIncursion")
			
			if ui.latestIncursion != cfg.lastIncursion {
				try {
					ui.incursionGui.destroy()
				}
				ui.incursionGui := gui()
				ui.incursionGui.opt("-caption -border alwaysOnTop")
				ui.incursionGui.backColor := "010203"
				winSetTransColor("010203",ui.incursionGui)
				ui.incursionGui.addText("x3 y3 w344 h70 background" cfg.themePanel3Color)
				drawOutlineNamed("notice",ui.incursionGui,2,2,345,148,cfg.themeBright2Color,cfg.themeDark2Color,1)
				drawPanelLabel(ui.incursionGui,20,-5,100,17,"Destiny2 Event",cfg.themeFont3Color,cfg.themeBright2Color,cfg.themePanel3Color)
				ui.incursionNoticeBorder 	:= ui.incursionGui.addText("x130 y7 w180 h20 background000000")
				ui.incursionNoticeBorder2 	:= ui.incursionGui.addText("x131 y8 w178 h18 background" cfg.themeDark1Color)
				ui.incursionNotice := ui.incursionGui.addText("x10 y29 w340 h70 backgroundTrans c" cfg.themeFont3Color,"Vex Incursion Coming!")
				ui.incursionGui.setFont("s10 c" cfg.themePanel3Color,"Cascadia Code")
				ui.incursionTime := ui.incursionGui.addText("x136 y8 w180 h50 backgroundTrans",formatTime("T12","MM-dd-yyyy @ hh:mm:ss"))
				ui.incursionClose := ui.incursionGui.addPicture("x328 y1 w22 h22 background" cfg.themeButtonAlertColor,"./img/button_quit.png")
				ui.incursionClose.onEvent("click", closeIncursionNotice)
				closeIncursionNotice(*) {
					ui.incursionGui.hide()
					ui.incursionGui.destroy()
				}
				ui.incursionNotice.setFont("s20 c" cfg.themeFont3Color,"Courier")
				ui.incursionGui.show("y150 w350 h70 noActivate")
			}
		
		cfg.lastIncursion := ui.latestIncursion
		iniWrite(cfg.lastIncursion,cfg.file,"Game","LastIncursion")
		}
	}
	ui.d2IsReloading := false
	ui.d2IsSprinting := false

	
	hotIfWinActive("ahk_exe destiny2.exe")
		hotKey(cfg.d2AppToggleSprintKey,d2ToggleAlwaysRun)
	hotIf()

	hotIf(d2RemapCrouchEnabled)
		hotkey(cfg.d2AppHoldToCrouchKey,d2HoldToCrouch)
	hotIf()

	hotIf(d2ReadyToReload)
		hotKey("~*r",d2reload)
	hotIf()
	
	hotIf(d2ReadyToSprint)
		hotKey("~*w",d2StartSprinting)
	hotIf()
	
	d2RemapCrouchEnabled(*) {
		return ((winActive("ahk_exe destiny2.exe"))
			? cfg.d2AlwaysRunEnabled
				? 1
				: 0
			: 0)
	}	
	
	d2reload(*) {
		if cfg.d2AlwaysRunEnabled {
			ui.d2GameReloadKeyData.opt("c" cfg.themeButtonOnColor)
			ui.d2GameReloadKeyData.redraw()
			ui.d2IsReloading := true
			d2ToggleAlwaysRunOff()
			setTimer () => (ui.d2IsReloading := false,d2ToggleAlwaysRunOn(),ui.d2GameReloadKeyData.opt("c" cfg.themeButtonAlertColor),ui.d2GameReloadKeyData.redraw()),-2700
		}	
		;setTimer () => d2ToggleAlwaysRunOn(), -2600
	}

	d2HoldToCrouch(*) {
		ui.d2AppHoldToCrouchKeyData.opt("c" cfg.themeButtonOnColor)
		setTimer () => ui.d2AppHoldToCrouchKeyData.opt("c" cfg.themeButtonAlertColor),800
		send("{" cfg.d2gameHoldToCrouchKey " down}")
		keywait(cfg.d2appHoldToCrouchKey)
		ui.d2AppHoldToCrouchKeyData.opt("c" cfg.themeButtonAlertColor)
		send("{" cfg.d2gameHoldToCrouchKey " up}"),600
		if getKeyState("w") {
			d2StartSprinting()
			}
	}



	
	d2FireButtonClicked(*) {
		send("{LButton Down}")
		keyWait("LButton")

		send("{LButton Up}")
		if ui.d2IsSprinting
			send("{" cfg.d2GameToggleSprintKey "}")
	}
	
	d2ReadyToReload(*) {
		if winActive("ahk_exe destiny2.exe") && !ui.d2IsReloading && cfg.d2AlwaysRunEnabled
			return 1
		else
			return 0	
	}
	
	d2ReadyToSprint(*) {
		if (winActive("ahk_exe destiny2.exe") && cfg.d2AlwaysRunEnabled && !getKeyState("RButton") && !getKeyState("LButton"))
			return 1
		else
			return 0
	}
	
	d2startSprinting(*) {
		ui.d2IsSprinting := true
		;send("{w down}")
		if (cfg.d2AlwaysRunEnabled) {
			send("{" strLower(cfg.d2GameToggleSprintKey) "}")
		}
		setCapsLockState("Off")
	
		keyWait("w","L")
		send("{w up}")
	}



cfg.d2LoadoutCoords1920x1080 := strSplit(iniRead(cfg.file,"Game","d2LoadoutCoords1920x1080","145:380,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790"),",")
	
cfg.d2LoadoutCoords1920x1200 := strSplit(iniRead(cfg.file,"Game","d2LoadoutCoords1920x1200","145:380,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790"),",")
	
cfg.d2LoadoutCoords2560x1440 := strSplit(iniRead(cfg.file,"Game","d2LoadoutCoords2560x1440","636:512,760:512,636:640,760:640,636:770,760:770,636:900,760:900,636:1030,760:1030"),",")	

cfg.d2LoadoutCoords3440x1440 := strSplit(iniRead(cfg.file,"Game","d2LoadoutCoords3440x1440","636:460,760:460,636:590,760:590,636:720,760:720,636:850,760:850,636:980,760:980"),",")	
				
cfg.d2LoadoutCoordsCustom := strSplit(iniRead(cfg.file,"Game","d2LoadoutCoordsCustom","636:512,760:512,636:640,760:640,636:770,760:770,636:900,760:900,636:1030,760:1030"),
",")

d2CreateLoadoutKeys(*) {
	try {
		if (ui.monitorAuto == true) {
			cfg.d2LoadoutCoords := cfg.d2LoadoutCoords%a_screenWidth%x%a_screenHeight%
		} else {
			cfg.d2Loadoutcoords := cfg.d2LoadoutCoords%ui.monitorResDDL.text%
		}
	} catch {
		cfg.d2LoadoutCoords := cfg.d2LoadoutCoords1920x1080
	}
	;msgBox(cfg.d2LoadoutCoords.length)
	loop cfg.d2LoadoutCoords.length {
		d2LoadOutCoordsStr .= cfg.d2LoadoutCoords[a_index] ","
	}	

		hotIfWinActive("ahk_exe destiny2.exe")
			loop cfg.d2LoadoutCoords.length {
				if a_index == 10 {
					hotkey(cfg.d2AppLoadoutKey " & 0",d2LoadoutModifier)
				} else {
					hotKey(cfg.d2AppLoadoutKey " & " substr(a_index,-1),d2LoadoutModifier)
				}
			}

		hotIf()
}
d2CreateLoadoutKeys()


; joy13::
; {
	; sleep(50)
	; switch getKeyState("JoyPOV") {
		; case 0:sendEvent("{` down}{2}{` up}")
		; case 9000: sendEvent("{` down}{3}{` up}")
		; case 18000: sendEvent("{` down}{4}{` up}")
		; case 27000: sendEvent("{` down}{1}{` up}")
		; default: Return
	; }
; }		


d2LoadoutModifier(hotKeyName) {
	d2LoadoutCoordsStr := ""

	loop cfg.d2LoadoutCoords.length {
		d2LoadoutCoordsStr .= cfg.d2LoadoutCoords[a_index] ","
	}
	d2LoadoutCoordsStr := rtrim(d2LoadoutCoordsStr,",")


	try {
			ui.dockBarLoadouts.opt("background" cfg.themeButtonAlertColor)
			ui.dockBarLoadouts.redraw()
		}
		ui.d2AppLoadoutKeyData.text := cfg.d2AppLoadoutKey " - " subStr(hotKeyName,-1)
		ui.d2AppLoadoutKeyData.opt("c" cfg.themeButtonOnColor)
		ui.d2AppLoadoutKeyData.redraw()
		setTimer () => (ui.d2AppLoadoutKeyData.text := cfg.d2AppLoadoutKey,ui.d2AppLoadoutKeyData.opt("c" cfg.themeButtonAlertColor),ui.d2AppLoadoutKeyData.redraw()),-1000

		loadoutX := strSplit(cfg.d2LoadoutCoords[subStr(hotKeyName,-1)],":")[1]
		loadoutY := strSplit(cfg.d2LoadoutCoords[subStr(hotKeyName,-1)],":")[2]

		if !(loadoutX || loadoutY)
			return
		
		send("{F1}")
		sleep(550*cfg.d2AppLoadoutMultiplier)
		send("{Left}")
		sleep(150*cfg.d2AppLoadoutMultiplier)
		coordMode("mouse","client")
		click(loadoutX,loadoutY,0)
		sleep(250*cfg.d2AppLoadoutMultiplier)
		send("{LButton}")
		sleep(100*cfg.d2AppLoadoutMultiplier)
		send("{F1}")
		try {
			ui.dockBarLoadouts.opt("background" cfg.themeButtonReadyColor)
			ui.dockBarLoadouts.redraw()
		}
	}
	
	d2ToggleAlwaysRun(*) {
		(cfg.d2AlwaysRunEnabled := !cfg.d2AlwaysRunEnabled)
			? d2ToggleAlwaysRunOn()
			: d2ToggleAlwaysRunOff()
	}

	d2ToggleAlwaysRunOn() {
		ui.d2AppToggleSprintKeyData.opt("c" cfg.themeButtonOnColor)
		ui.d2AppToggleSprintKeyData.redraw()
		ui.d2GameToggleSprintKeyData.opt("c" cfg.themeButtonOnColor)
		ui.d2GameToggleSprintKeyData.redraw()
		SetCapsLockState("Off")
		cfg.d2AlwaysRunEnabled := true
		;ui.d2Log.text := " start: SPRINT`n rcvd: " strUpper(subStr(cfg.d2AppToggleSprintKey,1,8)) "`n" ui.d2Log.text
		ui.d2AlwaysSprint.Opt("Background" cfg.ThemeButtonOnColor)
		ui.d2AlwaysSprint.value := "./img/toggle_vertical_trans_on.png"
		try {
			ui.dockBarD2AlwaysRun.Opt("Background" cfg.ThemeButtonOnColor)
			ui.dockBarD2AlwaysRun.value := "./img/toggle_vertical_trans_on.png"
		}
	}

	d2ToggleAlwaysRunOff() {
		if ui.d2IsSprinting
			send("{" cfg.d2AppToggleSprintKey "}")
		ui.d2IsSprinting := false
		SetCapsLockState("Off")
		ui.d2AppToggleSprintKeyData.opt("c" cfg.themeButtonAlertColor)
		ui.d2AppToggleSprintKeyData.redraw()
		ui.d2GameToggleSprintKeyData.opt("c" cfg.themebuttonAlertColor)
		ui.d2GameToggleSprintKeyData.redraw()
		cfg.d2AlwaysRunEnabled := false
		

		;ui.d2Log.text := " stop: SPRINT`n rcvd: " strUpper(subStr(cfg.d2AppToggleSprintKey,1,8)) "`n" ui.d2Log.text
		ui.d2AlwaysSprint.opt("background" cfg.ThemeButtonReadyColor)
		ui.d2AlwaysSprint.value := "./img/toggle_vertical_trans_off.png"
		try {
			ui.dockBarD2AlwaysRun.opt("background" cfg.ThemeButtonReadyColor)
			ui.dockBarD2AlwaysRun.value := "./img/toggle_vertical_trans_off.png"
		}
	}

	keyCleanUp(this,*) {
		for keyForCleanup in 
					[cfg.d2GameToggleSprintKey
					,cfg.d2AppHoldToCrouchKey
					,cfg.d2AppToggleSprintKey
					,cfg.d2AppLoadoutKey
					,"Shift"
					,"Ctrl"
					,"Alt"]
			send("{" keyForCleanup "}")
			SetCapsLockState("Off")
			d2cleanupNeeded := false
	}

} ;END d2 Logic

{ ;d2 UI
		ui.gameTabs.useTab("Destiny2") 
		
		ui.d2Sliding := false
		ui.d2HoldingRun := false         
		ui.d2cleanupNeeded := false

		ui.gameSettingsGui.setFont("s10")
		ui.gameSettingsGui.addText("x7 y4 w481 h63 background" cfg.themePanel1Color,"")
		ui.gameSettingsGui.addText("x7 y71 w481 h71 background" cfg.themePanel1Color,"")

		ui.gameSettingsGui.addText("x12 y78 w470 h58 c" cfg.themePanel1Color " background" cfg.themePanel2Color)
		drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,13,79,470,57,cfg.themeDark2Color,cfg.themeBright2Color,1)
		drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,3,484,66,cfg.themeBright2Color,cfg.themeDark2Color,1)
		drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,71,484,73,cfg.themeBright2Color,cfg.themeDark2Color,1)

		ui.gameSettingsGui.addText("hidden x19 y18 section")
		ui.gameSettingsGui.addText("x38 y10 w260 h43 background" cfg.themePanel2color " c" cfg.themeFont4color,"")
		drawOutlineNamed("gameSettings",ui.gameSettingsGui,38,11,260,42,cfg.themeDark1Color,cfg.themeBright2Color,1)
		ui.gameSettingsGui.addText("x304 y10 w177 h43 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
		drawOutlineNamed("appSettings",ui.gameSettingsGui,305,11,176,42,cfg.themeDark1Color,cfg.themeBright2Color,1)
	
		ui.d2GameToggleSprintKey				:= ui.gameSettingsGui.AddPicture("x45 y17 w84  h30 section backgroundTrans","./img/keyboard_key_up.png")
		ui.d2GameToggleSprintKeyData 		:= ui.gameSettingsGui.addText("xs-3 y+-24 w84  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameToggleSprintKey),1,8))
		ui.d2GameToggleSprintKeyLabel		:= ui.gameSettingsGui.addText("xs-1 y+-34 w84  h20 center c" cfg.themeFont1Color " backgroundTrans","Toggle Sprint")
		ui.d2GameReloadKey				:= ui.gameSettingsGui.addPicture("x+2 ys w82 h30 section backgroundTrans","./img/keyboard_key_up.png")
		ui.d2GameReloadKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w82  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameReloadKey),1,8))
		ui.d2GameReloadKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w82  h20 center c" cfg.themeFont1Color " backgroundTrans","Reload")
		ui.d2AppHoldToCrouchKey				:= ui.gameSettingsGui.AddPicture("x+2 ys w84  h30 section backgroundTrans","./img/keyboard_key_up.png")
		ui.d2AppHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w84  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppHoldToCrouchKey),1,8))
		ui.d2AppHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w84  h20 center c" cfg.themeFont1Color " backgroundTrans","Slide")
		
		ui.d2AppToggleSprintKey			:= ui.gameSettingsGui.addPicture("x312 y17 w84  h30 section backgroundTrans","./img/keyboard_key_up.png")
		ui.d2AppToggleSprintKeyData 		:= ui.gameSettingsGui.addText("xs-3 y+-24 w84  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppToggleSprintKey),1,8))
		ui.d2AppToggleSprintKeyLabel		:= ui.gameSettingsGui.addText("xs-1 y+-34 w84  h20 center c" cfg.themeFont1Color " backgroundTrans","Always Sprint")
		ui.d2AppLoadoutKey				:= ui.gameSettingsGui.addPicture("x+2 ys w80  h30 section backgroundTrans","./img/keyboard_key_up.png")
		ui.d2AppLoadoutKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w80  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppLoadoutKey),1,8))
		ui.d2AppLoadoutKeyLabel 		:= ui.gameSettingsGui.addText("xs-1 y+-34 w80  h20 center c" cfg.themeFont1Color " backgroundTrans","Loadout")
		
		; ui.d2GameHoldToCrouchKey					:= ui.gameSettingsGui.addPicture("x15 y55 w84  h28 section hidden backgroundTrans","./img/keyboard_key_up.png")
		; ui.d2AppHoldToCrouchKeyData 				:= ui.gameSettingsGui.addText("xs y+-23 w84  h21 center c" cfg.themeButtonAlertColor " hidden backgroundTrans",subStr(strUpper(cfg.d2AppHoldToCrouchKey),1,8))
		; ui.d2AppHoldToCrouchKeyLabel 			:= ui.gameSettingsGui.addText("xs-1 y+-20 w84  h20 hidden center c" cfg.themeFont1Color " backgroundTrans","Mount HoldToCrouch")
			
		ui.d2LaunchDIMbutton				:= ui.gameSettingsGui.addPicture("x25 y+52 section w50 h50 backgroundTrans","./Img2/d2_button_DIM.png")
		ui.d2LaunchLightGGbutton			:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_LightGG.png")
		ui.d2LaunchBlueberriesButton 		:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_bbgg.png")
		ui.d2LaunchD2CheckListButton 		:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_d2CheckList.png")
		ui.d2LaunchDestinyTrackerButton 	:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_DestinyTracker.png")
		ui.d2Launchd2FoundryButton 			:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_d2Foundry.png")
		ui.d2LaunchBrayTechButton 			:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_braytech.png")
		;ui.d2LoadoutTimingBg				:= ui.gameSettingsGui.addText("x125 y33 w70 h10 background" cfg.themePanel1Color)
		;ui.d2LoadoutTiming					:= ui.gameSettingsGui.addSlider("x204 y18 w10 h30  altSubmit vertical tickInterval5 range1-5 thick10 vD2loadoutTiming c" cfg.themeFont2Color " background" cfg.themePanel1Color)

		; ui.gameSettingsLinkGui := gui()
		; ui.gameSettingsLinkGui.opt("-caption -border toolwindow owner" ui.gameSettingsGui.hwnd)
		; ui.gameSettingsLinkGui.backColor := "010203"
		; winSetTransColor("010203",ui.gameSettingsLinkGui)
		; ui.gameSettingsLinkGui.AddText()
		; ui.gameSettingsLinkGui.addText("x0 y0 w470 h57 c" cfg.themePanel1Color " background" cfg.themePanel2Color)
		; drawOutlineNamed("d2linkPanel",ui.gameSettingsLinkGui,1,1,468,55,cfg.themeDark2Color,cfg.themeBright2Color,1)

		; ui.d2LaunchDIMbutton				:= ui.gameSettingsLinkGui.addPicture("x+15 ys-2 section w50 h50 backgroundTrans","./Img2/d2_button_DIM.png")
		; ui.d2LaunchLightGGbutton			:= ui.gameSettingsLinkGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_LightGG.png")
		; ui.d2LaunchBlueberriesButton 		:= ui.gameSettingsLinkGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_bbgg.png")
		; ui.d2LaunchD2CheckListButton 		:= ui.gameSettingsLinkGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_d2CheckList.png")
		; ui.d2LaunchDestinyTrackerButton 	:= ui.gameSettingsLinkGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_DestinyTracker.png")
		; ui.d2Launchd2FoundryButton 			:= ui.gameSettingsLinkGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_d2Foundry.png")
		; winGetPos(&gsx,&gsy,&gsw,&gsh,ui.gameSettingsGui)
		;ui.gameSettingsLinkGui.show("w470 h57 noActivate")
		


		drawPanelLabel(ui.gameSettingsGui,168,45,130,17,"Always Run Settings",cfg.themePanel2Color,cfg.themeBright2Color,cfg.themeFont1Color)
		
		drawPanelLabel(ui.gameSettingsGui,305,45,130,17,"Other Assists",cfg.themePanel2Color,cfg.themeBright2Color,cfg.themeFont1Color)
		
		ui.gameSettingsGui.addText("x304 y45 w1 h18 background" cfg.themePanel2Color)
		ui.gameSettingsGui.addText("x305 y45 w1 h18 background" cfg.themeDark2Color)

		drawPanelLabel(guiName,labelX,labelY,labelW := 100,labelH := 20,labelText := "needs value",backColor := "gray",outlineColor := "white",fontColor := "white") {
			static labelName := array()
			static labelNum := 0
			labelNum +=1
			labelName.push("labelName" labelNum)
			labelName[labelNum] := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
			labelName[labelNum].setFont("s9")
			labelNum +=1
			labelName.push("labelName" labelNum)
			labelName[labelNum] := guiName.addText("x" labelX+1 " y" labelY+2 " w" labelW-2 " h" labelH-1 " background" backColor " center c" fontColor) 
			labelName[labelNum].setFont("s10")
			labelName[labelNum] := guiName.addText("x" labelX+1 " y" labelY+3 " w" labelW-2 " h" labelH " backgroundTrans center c" fontColor, labelText) 
			labelName[labelNum].setFont("s10")
		}
		

		
		; drawOutlineNamed("d2AlwaysRunOutline3",ui.gameSettingsGui,121,47,90,5,cfg.themeBright1Color,cfg.themePanel1Color,1)		
		; ui.gameSettingsGui.addText("x122 y48 w88 h15 c" cfg.themeFont1Color " background" cfg.themePanel1Color,"  Game Settings")
		; drawOutlineNamed("d2AlwaysRunOutline4",ui.gameSettingsGui,210,47,1,5,cfg.themeBright1Color,cfg.themeBright1Color,1)						 
			
		; }

; drawOutlineNamed("d2AlwaysRunOutline3",ui.gameSettingsGui,349,47,85,5,cfg.themeBright1Color,cfg.themeBackgroundColor,1)		
		; ui.gameSettingsGui.addText("x350 y48 w83 h15 c" cfg.themeFont1Color " background" cfg.themePanel1Color,"   App Settings")
		; drawOutlineNamed("d2AlwaysRunOutline4",ui.gameSettingsGui,433,47,1,6,cfg.themeBright1Color,cfg.themeBright1Color,1)	
; ui.d2DestinySetupLabel 		:= ui.gameSettingsGui.addText("x15 y18 w84  h20  right section backgroundTrans","D2 Setup")
		; ui.d2AppSetupLabel 			:= ui.gameSettingsGui.addText("xs+0 y+25  w84  h20 right backgroundTrans","Your Binds")
		; ui.d2AppSetupLabel.setFont("s13")
		; ui.d2DestinySetupLabel.setFont("s13")

		
		; ui.d2AppSetupLabelInfo		:= ui.gameSettingsGui.addPicture("x105 y4 section w16 h16 backgroundTrans","./img2/icon_info.png")
		; ui.d2DestinySetupLabelInfo	:= ui.gameSettingsGui.addPicture("x105 y88 section w16 h16 backgroundTrans","./img2/icon_info.png")	
		; ui.d2AppSetupLabelInfo.toolTip 		:= "Bind these to what you'd`nlike to use when playing."
		; ui.d2DestinySetupLabelInfo.toolTip	:= "Bind these to whatever they're set to in Destiny 2."
		
		ui.d2AlwaysSprint := ui.gameSettingsGui.addPicture("x13 y9 w28 h46 section "
		((cfg.d2AlwaysRunEnabled) 
			? ("Background" cfg.ThemeButtonOnColor) 
				: ("Background" cfg.themeButtonReadyColor)),
		((cfg.d2AlwaysRunEnabled) 
			? ("./img/toggle_vertical_trans_on.png") 
				: ("./img/toggle_vertical_trans_off.png")))
		ui.d2Log			:= ui.gameSettingsGui.addText("x405 y10 w68 h80 hidden background" cfg.themePanel3color " c" cfg.themeFont3color," Destiny 2`n Log Started`n Waiting for Input")
		ui.d2Log.setFont("s7","ariel")

		ui.d2AlwaysSprint.ToolTip 			:= "Toggles holdToCrouch"
		ui.d2AppHoldToCrouchKey.ToolTip 			:= "Click to Assign"
		ui.d2AppHoldToCrouchKeyData.ToolTip  	:= "Click to Assign"
		ui.d2AppHoldToCrouchKeyLabel.ToolTip		:= "Click to Assign"
		ui.d2AppLoadoutKey.ToolTip			:= "Click to Assign"
		ui.d2AppLoadoutKeyData.ToolTip  	:= "Click to Assign"
		ui.d2AppLoadoutKeyLabel.ToolTip		:= "Click to Assign"
		ui.d2gameToggleSprintKey.ToolTip		:= "Click to Assign"
		ui.d2gameToggleSprintKeyData.ToolTip  := "Click to Assign"
		ui.d2gameToggleSprintKeyLabel.ToolTip	:= "Click to Assign"
		ui.d2AppToggleSprintKey.ToolTip		:= "Click to Assign"
		ui.d2AppToggleSprintKeyData.ToolTip  	:= "Click to Assign"
		ui.d2AppToggleSprintKeyLabel.ToolTip	:= "Click to Assign"
		ui.d2AppHoldToCrouchKey.ToolTip		:= "Click to Assign"
		ui.d2AppHoldToCrouchKeyData.ToolTip  	:= "Click to Assign"
		ui.d2AppHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"
		ui.d2GameReloadKey.ToolTip		:= "Click to Assign"
		ui.d2GameReloadKeyData.ToolTip  	:= "Click to Assign"
		ui.d2GameReloadKeyLabel.ToolTip	:= "Click to Assign"
		ui.d2LaunchDIMbutton.ToolTip	:= "Launch DIM in Browser"
		ui.d2LaunchLightGGbutton.toolTip := "Launch Light.gg in Browser"
		ui.d2LaunchBlueberriesButton.toolTip	:= "Launch Blueberries.gg in Browser"
		ui.d2Launchd2CheckListButton.toolTip	:= "Launch D2Checklist.com in Browser"
		ui.d2LaunchDestinyTrackerButton.toolTip	:= "Launch DestinyTracker.com in Browser"
		ui.d2LaunchBrayTechButton.toolTip	:= "Launch Bray.Tech in Browser"
		ui.d2Launchd2FoundryButton.toolTip	:= "Launch d2Foundry"
		ui.d2AppLoadoutKeyData.setFont("s11")
		ui.d2AppHoldToCrouchKeyData.setFont("s11")
		ui.d2gameToggleSprintKeyData.setFont("s11")
		ui.d2AppHoldToCrouchKeyData.setFont("s11")
		ui.d2GameReloadKeyData.setFont("s11")
		ui.d2AppToggleSprintKeyData.setFont("s11")

		ui.d2AppLoadoutKeyLabel.setFont("s9")
		ui.d2AppHoldToCrouchKeyLabel.setFont("s9")
		ui.d2gameToggleSprintKeyLabel.setFont("s9")
		
		ui.d2AppHoldToCrouchKeyLabel.setFont("s9")
		ui.d2GameReloadKeylabel.setFont("s9")
		ui.d2AppToggleSprintKeyLabel.setFont("s9")
		
		ui.d2AlwaysSprint.OnEvent("Click", d2ToggleAlwaysRun)
		
		ui.d2AppLoadoutKey.onEvent("click",d2AppLoadoutKeyClicked)
		ui.d2AppLoadoutKeyData.onEvent("click",d2AppLoadoutKeyClicked)
		
		ui.d2AppHoldToCrouchKey.onEvent("click",d2AppHoldToCrouchKeyClicked)
		ui.d2AppHoldToCrouchKeyData.onEvent("click",d2AppHoldToCrouchKeyClicked)
		
		ui.d2GameReloadKey.onEvent("click",d2GameReloadKeyClicked)
		ui.d2GameReloadKeyData.onEvent("click",d2GameReloadKeyClicked)
		
		ui.d2AppToggleSprintKey.onEvent("click",d2AppToggleSprintKeyClicked)
		ui.d2AppToggleSprintKeyData.onEvent("click",d2AppToggleSprintKeyClicked)
		
		ui.d2gameToggleSprintKey.onEvent("click",d2gameToggleSprintKeyClicked)
		ui.d2gameToggleSprintKeyData.onEvent("click",d2gameToggleSprintKeyClicked)
		
		; buttonBar1 := ["DIhttps://cashmantree-my.sharepoint.com/:x:/g/personal/cashman_omnibros_net/Ef1lAG_rWYdHqsOd5RkIkwYBgQF6Tn2KdOZLj_Y6AuNc9w?e=nF3YBZM:./img2/d2_button_DIM.png:./img2/d2_button_DIM_down.png:launchURL("Wishlist Mgr:./img2/d2_button_wishlistMgr.png:./img2/d2_button_wishlistMgr_down.png:launchURL('https://wishlists.littlelight.club'):Launch LittleLight WishList Mgr in Browser","Light.GG:./img2/d2_button_lightgg.png:./img2/d2_button_lightgg_down.png:launchURL('https://light.gg'):Launch Light.GG in browser","Roll Appraiser:./img2/d2_button_lightggAppraiser.png:./img2/d2_button_lightgg_appraiser_down.png:launchURL('light.gg/god-roll-appraiser'):Light.gg Build Popularity  Classifier)]
		; createButtonBar
		ui.d2LaunchDIMbutton.onEvent("click",d2launchDIMbuttonClicked)
		ui.d2LaunchLightGGbutton.onEvent("click",d2launchLightGGbuttonClicked)
		ui.d2LaunchD2checkListButton.onEvent("click",d2launchD2checklistButtonClicked)
		ui.d2LaunchBlueberriesButton.onEvent("click",d2launchBlueBerriesButtonClicked)
		ui.d2LaunchDestinyTrackerButton.onEvent("click",d2LaunchDestinyTrackerButtonClicked)
		ui.d2Launchd2FoundryButton.onEvent("click",d2Launchd2FoundryButtonClicked)
		ui.d2LaunchBrayTechButton.onEvent("click",d2LaunchBrayTechButtonClicked)

} ;end d2 ui
	
{ ;d2 UI Logic

	d2RedrawUI(*) {
		d2CreateLoadoutKeys()
	}

	d2LaunchDIMButtonClicked(*) {
		ui.d2LaunchDIMbutton.value := "./Img2/d2_button_DIM_down.png"
		setTimer () => ui.d2LaunchDIMbutton.value := "./Img2/d2_button_DIM.png",-400
		
		run("chrome.exe http://app.destinyitemmanager.com")
	}

	d2LaunchLightGGbuttonClicked(*) {
		ui.d2LaunchLightGGbutton.value := "./Img2/d2_button_LightGG_down.png"
		setTimer () => ui.d2LaunchLightGGbutton.value := "./Img2/d2_button_LightGG.png",-400
		run("chrome.exe https://www.light.gg/god-roll/roll-appraiser/")	
	}

	d2LaunchBlueBerriesButtonClicked(*) {
		ui.d2LaunchBlueberriesButton.value := "./Img2/d2_button_bbgg_down.png"
		setTimer () => ui.d2LaunchBlueberriesButton.value := "./Img2/d2_button_bbgg.png",-400
		run("chrome.exe https://www.blueberries.gg")
		}
		
	d2Launchd2CheckListButtonClicked(*) {
		ui.d2Launchd2ChecklistButton.value := "./Img2/d2_button_d2Checklist_down.png"
		setTimer () => ui.d2Launchd2ChecklistButton.value := "./Img2/d2_button_d2Checklist.png",-400
		run("chrome.exe https://www.d2checklist.com")
		}

	d2LaunchDestinyTrackerButtonClicked(*) {
		ui.d2LaunchDestinyTrackerButton.value := "./Img2/d2_button_DestinyTracker_down.png"
		setTimer () => ui.d2LaunchDestinyTrackerButton.value := "./Img2/d2_button_DestinyTracker.png",-400
		run("chrome.exe https://www.DestinyTracker.com")
		}

	d2Launchd2FoundryButtonClicked(*) {
		ui.d2Launchd2FoundryButton.value := "./Img2/d2_button_d2Foundry_down.png"
		setTimer () => ui.d2Launchd2FoundryButton.value := "./Img2/d2_button_d2Foundry.png",-400
		run("chrome.exe https://www.d2foundry.gg")
		}	

	d2LaunchBrayTechButtonClicked(*) {
		ui.d2LaunchBrayTechButton.value := "./Img2/d2_button_brayTech_down.png"
		setTimer () => ui.d2LaunchBrayTechButton.value := "./Img2/d2_button_braytech.png",-400
		run("chrome.exe https://www.bray.tech")
		}


keyBindDialogBox(Msg,Alignment := "Center") {
	Global
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Bind Key"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.ThemePanel1Color  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s12")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c" cfg.ThemeButtonOnColor " " Alignment " BackgroundTrans","Press desired key to use for: ")
	ui.notifyGui.setFont("s14")
	ui.notifyGui.addText("ys-4 x+0 c" cfg.themeButtonAlertColor,Msg)
	ui.notifyGui.setFont("s11 c" cfg.themeButtonOnColor,"Courier Narrow Bold")
	ui.notifyGui.addText("xs y+0","Or click target with desired mouse button")  ; XX & YY serve to 00auto-size the window.
	ui.mouseBindingTarget := ui.notifyGui.addPicture("x+15 y+-18 w25 h25 backgroundTrans",".\img2\button_keyBindTarget.png")

	ui.notifyGui.AddText("xs hidden")
	
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	drawOutlineNotifyGui(1,1,w,h,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2)
	drawOutlineNotifyGui(2,2,w-4,h-4,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)
	
	Transparency := 0
	guiVis(ui.mainGui,false)
	guiVis(ui.titleBarButtonGui,false)
	guiVis(ui.gameSettingsGui,false)
	guiVis(ui.gameTabGui,false)
	While Transparency < 253 {
		Transparency += 5
		WinSetTransparent(Round(Transparency),ui.notifyGui)
	}
}


keyBindDialogBoxClose(*)
{
	Global
	Try
		ui.notifyGui.Destroy()
	guiVis(ui.mainGui,true)
	guiVis(ui.titleBarButtonGui,true)
	guiVis(ui.gameSettingsGui,true)
	guiVis(ui.gameTabGui,true)
}


	d2AppHoldToCrouchKeyClicked(*) {
		tmpCrouchKey := ""
		keyBindDialogBox('HoldToCrouch',"Center")
		Sleep(100)
		d2AppHoldToCrouchKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		d2AppHoldToCrouchKeyInput.start()
		d2AppHoldToCrouchKeyInput.wait()
		if (d2AppHoldToCrouchKeyInput.endKey == "" && d2AppHoldToCrouchKeyInput.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2AppHoldToCrouchKeyInput.input)
			{
				tmpCrouchKey := d2AppHoldToCrouchKeyInput.input
			} else {
				tmpCrouchKey := d2AppHoldToCrouchKeyInput.endKey
			}
		}
		keyBindDialogBoxClose()
		; keyBindDialogBox('Crouch (No AutoSprint)',"Center")
				; Sleep(100)
		; d2AppHoldToCrouchKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		; d2AppHoldToCrouchKeyInput.start()
		; d2AppHoldToCrouchKeyInput.wait()
		; if (d2AppHoldToCrouchKeyInput.endKey == "" && d2AppHoldToCrouchKeyInput.input =="") {
			; keyBindDialogBoxClose()
			; notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		; } else {
			; if (d2AppHoldToCrouchKeyInput.input)
			; {
				; tmpCrouchKey .= "|" d2AppHoldToCrouchKeyInput.input
			; } else {
				; tmpCrouchKey .= "|" d2AppHoldToCrouchKeyInput.endKey
			; }
		; }
		; keyBindDialogBoxClose()
		cfg.d2AppHoldToCrouchKey := tmpCrouchKey
		ui.d2AppHoldToCrouchKeyData.text := subStr(strUpper(cfg.d2AppHoldToCrouchKey),1,8)
		d2RedrawUI()
	}

	d2AppLoadoutKeyClicked(*) {
		keyBindDialogBox('Loadout Modifier',"Center")
		Sleep(100)
		d2AppLoadoutKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2AppLoadoutKeyInput.start()
		d2AppLoadoutKeyInput.wait()
		if (d2AppLoadoutKeyInput.endKey == "" && d2AppLoadoutKeyInput.input == "") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2AppLoadoutKeyInput.input)
			{
				cfg.d2AppLoadoutKey := d2AppLoadoutKeyInput.input
			} else {
				cfg.d2AppLoadoutKey := d2AppLoadoutKeyInput.endKey
			}
			ui.d2AppLoadoutKeyData.text := subStr(strUpper(cfg.d2AppLoadoutKey),1,8)
		}
		keyBindDialogBoxClose()
		d2RedrawUI()
	}



	d2GameToggleSprintKeyClicked(*) {
		keyBindDialogBox('Hold to Walk',"Center")
		Sleep(100)
		d2GameToggleSprintKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameToggleSprintKeyInput.start()
		d2GameToggleSprintKeyInput.wait()
		if (d2GameToggleSprintKeyInput.endKey == "" && d2GameToggleSprintKeyInput.input == "") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameToggleSprintKeyInput.input)
			{
				cfg.d2GameToggleSprintKey := d2GameToggleSprintKeyInput.input
			} else {
				cfg.d2GameToggleSprintKey := d2GameToggleSprintKeyInput.endKey
			}
			ui.d2GameToggleSprintKeyData.text := subStr(strUpper(cfg.d2GameToggleSprintKey),1,8)
		}
		keyBindDialogBoxClose()
		d2RedrawUI()
	}

	d2AppToggleSprintKeyClicked(*) {
		keyBindDialogBox('Toggle Walk',"Center")
		Sleep(100)
		d2AppToggleSprintKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2AppToggleSprintKeyInput.start()
		d2AppToggleSprintKeyInput.wait()
		if (d2AppToggleSprintKeyInput.endKey == "" && d2AppToggleSprintKeyInput.input == "") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2AppToggleSprintKeyInput.input)
			{
				cfg.d2AppToggleSprintKey := d2AppToggleSprintKeyInput.input
			} else {
				cfg.d2AppToggleSprintKey := d2AppToggleSprintKeyInput.endKey
			}
			ui.d2AppToggleSprintKeyData.text := subStr(strUpper(cfg.d2AppToggleSprintKey),1,8)
		}
		keyBindDialogBoxClose()
		d2RedrawUI()
	}


	; d2AppHoldToCrouchKeyClicked(*) {
		; DialogBox('Press Key to Assign to: `n"Toggle Walk"',"Center")
		; Sleep(100)
		; d2AppHoldToCrouchKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		; d2AppHoldToCrouchKeyInput.start()
		; d2AppHoldToCrouchKeyInput.wait()
		; if (d2AppHoldToCrouchKeyInput.endKey == "" && d2AppHoldToCrouchKeyInput.input == "") {
			; DialogBoxClose()
			; notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		; } else {
			; if (d2AppHoldToCrouchKeyInput.input)
			; {
				; cfg.d2AppHoldToCrouchKey := d2AppHoldToCrouchKeyInput.input
			; } else {
				; cfg.d2AppHoldToCrouchKey := d2AppHoldToCrouchKeyInput.endKey
			; }
			; ui.d2AppHoldToCrouchKeyData.text := subStr(strUpper(cfg.d2AppHoldToCrouchKey),1,8)
		; }
		; DialogBoxClose()
	; }

	d2GameReloadKeyClicked(*) {
		DialogBox('Assign key for: `n"Reload"',"Center")
		Sleep(100)
		d2GameReloadKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameReloadKeyInput.start()
		d2GameReloadKeyInput.wait()
		if (d2GameReloadKeyInput.endKey == "" && d2GameReloadKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameReloadKeyInput.input)
			{
				cfg.d2GameReloadKey := d2GameReloadKeyInput.input
			} else {
				cfg.d2GameReloadKey := d2GameReloadKeyInput.endKey
			}
			ui.d2GameReloadKeyData.text := subStr(strUpper(cfg.d2GameReloadKey),1,8)
		}
		DialogBoxClose()
		d2RedrawUI()
	}

} ;END d2 UI Logic

{ ;w0 Tab
	ui.gameTabs.useTab("World//Zero")
	ui.gameSettingsGui.addText("x10 y7 w475 h65 background" cfg.themePanel1Color,"")
	drawOutlineNamed("w0AutoTowerOutline",ui.gameSettingsGui,10,6,475,67,cfg.themeBright2Color,cfg.themeDark2Color,1)
	drawOutlineNamed("w0AutoTowerHorizLine",ui.gameSettingsGui,20,6,70,1,cfg.themeBackgroundColor,cfg.themeBackgroundColor,2)
	drawOutlineNamed("w0AutoTowerVertLine",ui.gameSettingsGui,20,6,70,7,cfg.themeBackgroundColor,cfg.themeBright2Color,1)
	ui.gameSettingsGui.addText("x21 y-2 w68 h14 c" cfg.themeFont1Color " background" cfg.themeBackgroundColor," Auto Tower")
	drawOutlineNamed("w0AutoAfkTabs",ui.gameSettingsGui,20,6,1,7,cfg.themeDark1Color,cfg.themeBright2Color,1)
	ui.gameSettingsGui.setFont("s10")
	ui.toggleCelestialTower := ui.gameSettingsGui.AddPicture("x20 y20 w60 h25 section vCelestialTower " (cfg.CelestialTowerEnabled ? ("Background" cfg.ThemeButtonAlertColor) : ("Background" cfg.ThemeButtonAlertColor)),((cfg.CelestialTowerEnabled) ? "./img/towerToggle_celestial.png" : "./img/towerToggle_infinite.png"))
	ui.toggleCelestialTower.OnEvent("Click", towerToggleChanged)
	ui.toggleCelestialTower.ToolTip := "Toggles between Infinite and Celestial Towers."
	ui.towerIntervalSlider := ui.gameSettingsGui.addSlider("x+0 ys-4 w160 h30 tickInterval5 altSubmit vTowerCycleLength thick18 center section Range1-50  background" 
	cfg.themePanel1Color " ToolTip",cfg.towerInterval)
	ui.towerIntervalSlider.onEvent("change",towerCycleChange)
	towerCycleChange(*) {
		ui.cycleLengthData.value := ui.towerIntervalSlider.value
		controlFocus(ui.gameTabs)
	}
	ui.cycleLengthData := ui.gameSettingsGui.AddText("x+0 ys+3 w35 h30 section center background" cfg.themeBackgroundColor,ui.towerIntervalSlider.value)
	ui.cycleLengthData.setFont("s18")
	ui.labelCelestialTower:= ui.gameSettingsGui.AddText("xs-220 y+-1 w60 section backgroundTrans","Tower Type")
	ui.labelTowerTiming := ui.gameSettingsGui.AddText("ys w160 center section backgroundTrans","Cycle Length")	
	drawOutlineNamed("towerCycleLength",ui.gameSettingsGui,239,19,36,31,cfg.themeDark2Color,cfg.themeBright2Color,1)
	ui.towerIntervalSlider.OnEvent("Change",towerIntervalChanged)
	ui.towerIntervalSlider.ToolTip := "Tower Restart Interval"
	ToggleCelestialTower(*)
	{
		ui.toggleCelestialTower.Opt((cfg.CelestialTowerEnabled := !cfg.CelestialTowerEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleCelestialTower.Redraw()
	}
		towerIntervalChanged(*) {
		cfg.towerInterval := ui.towerIntervalSlider.Value
	}

	; ToggleSilentIdle(*)
	; {
		; ui.toggleSilentIdle.Opt((cfg.SilentIdleEnabled := !cfg.SilentIdleEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		; ui.toggleSilentIdle.Redraw()
	; }
	; ui.toggleSilentIdle := ui.gameSettingsGui.AddPicture("xs-60 y+45 w60 h25 section vSilentIdle " (r)),((cfg.SilentIdleEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor) ? (cfg.toggleOn) : (cfg.toggleOff)))
	; ui.toggleSilentIdle.OnEvent("Click", toggleChanged)
	; ui.toggleSilentIdle.ToolTip := "Minimizes Roblox Windows While Anti-Idling"
	; ui.labelSilentIdle:= ui.gameSettingsGui.AddText("xs-8 y+0 w82 center backgroundTrans","Silent AntiIdle")
	
} ;end w0 tab

if (cfg.d2AlwaysRunEnabled) {
				d2ToggleAlwaysRunOn()
			}
			



; ui.gameTabs.useTab("")
; ui.bottomBar := ui.gameSettingsGui.addText("x230 y150 w265 h38 background" ui.transparentColor)
; winSetTransColor(ui.transparentColor,ui.gameSettingsGui)