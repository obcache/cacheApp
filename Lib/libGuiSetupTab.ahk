#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}

monitorResChanged(*) {
;libGuiSetupTab
	cfg.monitorRes := ui.monitorResDDL.text
	if (ui.monitorAuto.value) {
		ui.monitorResDDL.delete()
		ui.monitorResDDL.add([a_screenWidth "x" a_screenHeight])
		ui.monitorResDDL.text := a_screenWidth "x" a_screenHeight
		}

	d2CreateLoadoutKeys()
}

GuiSetupTab(&ui,&cfg) {
	global
	ui.MainGuiTabs.UseTab("6_Setup")
	
	drawPanel(ui.mainGui,45,36,210,168,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	drawPanel(ui.mainGui,263,36,210,108,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	drawPanel(ui.mainGui,263,151,210,53,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	drawPanel(ui.mainGui,480,36,40,168,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	
	ui.MainGui.SetFont("s09")
	ui.AutoClickerSpeedSlider := ui.MainGui.AddSlider("x487 y42 w25 h150 Range1-64 Vertical Left TickInterval8 Invert ToolTipTop",cfg.AutoClickerSpeed)
	ui.AutoClickerSpeedSlider.ToolTip := "AutoClicker Speed"
	ui.AutoClickerSpeedSliderLabel2 := ui.MainGui.AddText("x475 y190 w50 r1 Center BackgroundTrans","CPS")
	drawOutlineNamed("autoClicker",ui.mainGui,487,42,27,150,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1)
	ui.AutoClickerSpeedSlider.OnEvent("Change",AutoClickerSpeedChanged)
	
	ui.MainGui.SetFont("s10 c" cfg.themeFont1Color)
	drawOutlineMainGui(36,30,494,183,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,1)

	ui.MainGui.SetFont("s10")
	
	

	
	ToggleAfkSnap(*)
	{
		ui.toggleAfkSnap.Opt((cfg.AfkSnapEnabled := !cfg.AfkSnapEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAfkSnap.Redraw()
	}
	
	
	ui.toggleAfkSnap := ui.MainGui.AddPicture("x49 y18 w60 h1 section hidden vAfkSnap " (cfg.AfkSnapEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AfkSnapEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAfkSnap.OnEvent("Click", toggleChanged)
	ui.toggleAfkSnap.ToolTip := "Toggles Afk Screen Snapping"
	ui.labelAfkSnap:= ui.MainGui.AddText("x+2 ys+3 hidden background" cfg.themePanel3Color,"AFK Snapping")

	cfg.toolTipsEnabled:=iniRead(cfg.file,"Toggles","ToolTipsEnabled",true)
	ui.toggleToolTips := ui.MainGui.AddPicture("xs y+3 w50 h22 section vToolTips " ((cfg.ToolTipsEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.ToolTipsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleToolTips.OnEvent("Click", toggleChanged)
	ui.toggleToolTips.ToolTip := "Toggles ToolTips"
	ui.labelToolTips := ui.MainGui.AddText("x+5 ys+2 BackgroundTrans","  ToolTips")


	ToggleAlwaysOnTop(*)
	{
		ui.toggleAlwaysOnTop.Opt((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAlwaysOnTop.Redraw()
	}
	
	if cfg.AlwaysOnTopEnabled {
		if cfg.topDockEnabled
			try
				ui.dockBarGui.opt("alwaysOnTop")
		ui.mainGui.opt("alwaysOnTop")
	}
	ui.toggleAlwaysOnTop := ui.MainGui.AddPicture("xs y+2 w50 h22 section vAlwaysOnTop " (cfg.AlwaysOnTopEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AlwaysOnTopEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAlwaysOnTop.OnEvent("Click", ToggleAlwaysOnTopChanged)
	ui.toggleAlwaysOnTop.ToolTip := "Keeps this app on top of all other windows."
	ui.labelAlwaysOnTop:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  AlwaysOnTop")	
	

	
	ToggleAlwaysOnTopChanged(*) {
		ui.toggleAlwaysOnTop.value := 
			((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) 
				? (ui.toggleAlwaysOnTop.opt("Background" cfg.ThemeButtonOnColor),
					cfg.toggleOn) 
				: (ui.toggleAlwaysOnTop.opt("Background" cfg.ThemeButtonReadyColor),
					cfg.toggleOff))
					
		ui.toggleAlwaysOnTop.Redraw()
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
		}
		; try { 
			; winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.titleBarButtonGui)
		; }
		try { 
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.afkGui)
		}
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
		}
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopEnabled,ui.gameTabGui)
		}
	}
	
	cfg.animationsEnabled := iniRead(cfg.file,"Toggles","AnimationsEnabled",true)
	ui.toggleAnimations := ui.MainGui.AddPicture("xs w50 y+2 h22 section vAnimations " (cfg.AnimationsEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AnimationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAnimations.OnEvent("Click", toggleChanged)
	ui.toggleAnimations.ToolTip := "Toggles the app's slide and fade animations."
	ui.labelAnimations:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Animations")



	ui.toggleAutoStart := ui.MainGui.AddPicture("xs y+2 w50 h22 section vAutoStart " (cfg.autoStartEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.autoStartEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAutoStart.OnEvent("Click", toggleChangedAutoStart)
	ui.toggleAutoStart.ToolTip := "Auto-starts the app on Windows login."
	ui.labelAutoStart:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  AutoStart")
	
	toggleChangedAutoStart(toggleControl,*) {
		toggleControl.value := 
		(cfg.%toggleControl.name%Enabled := !cfg.%toggleControl.name%Enabled)
			? (toggleControl.Opt("Background" cfg.ThemeButtonOnColor),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.ThemeButtonReadyColor),cfg.toggleOff)

	if cfg.%toggleControl.name%Enabled 
		if !(fileExist(A_StartMenu "\Programs\Startup\cacheApp.lnk"))
			setAutoStart(1)
	else
		if (fileExist(A_StartMenu "\Programs\Startup\cacheApp.lnk"))
			setAutoStart(0)
	
}
	setAutoStart(OnOff) {
		if (OnOff == "On" || OnOff == true || OnOff == 1) {
			try {
				fileCreateShortcut(installDir "/cacheApp.exe", A_StartMenu "\Programs\Startup\cacheApp.lnk",installDir,,"CacheApp Gaming Assistant",installDir "/img/attack_icon.ico")
				trayTip("CacheApp now set to Autostart","CacheApp Config Change","Iconi Mute")
			} catch {
				trayTip("Failed to set CacheApp to Autostart","CacheApp Config Change","Iconi Mute")
				setAutoStart(0)
			}
		} else {
			try {
				fileDelete(A_StartMenu "\Programs\Startup\cacheApp.lnk")
				trayTip("CacheApp Autostart Disabled","CacheApp Config Change","Iconi Mute")
			} catch {
				trayTip("Failed to disable Autostart","CacheApp Config Change","Iconi Mute")
				setAutoStart(1)
			}
		}
	}
	
	
	ToggleStartMinimized(*)
	{
		ui.toggleStartMinimized.Opt((cfg.StartMinimizedEnabled := !cfg.StartMinimizedEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleStartMinimized.Redraw()
		iniWrite(cfg.StartMinimizedEnabled,cfg.file,"System","StartMinimizedEnabled")
	}
	cfg.StartMinimizedEnabled:=iniRead(cfg.file,"Toggles","StartMinimizedEnabled",false)
	ui.toggleStartMinimized := ui.MainGui.AddPicture("xs y+2 w50 h22 section vStartMinimized " (cfg.StartMinimizedEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.StartMinimizedEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleStartMinimized.OnEvent("Click", toggleChanged)
	ui.toggleStartMinimized.ToolTip := "Minimizes the app to system tray when started.  Useful when combined with 'Start with Windows'."
	ui.labelStartMinimized:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Start Minimized")
	; cfg.MouseRemapEnabled:=iniRead(cfg.file,"System","MouseRemapEnabled",false)
 	; ui.toggleMouseRemap := ui.MainGui.AddPicture("xs y+2 w50 h22 section vMouseRemap " (cfg.MouseRemapEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.MouseRemapEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	; ui.toggleMouseRemap.OnEvent("Click", toggleChanged)
	; ui.toggleMouseRemap.ToolTip := "Enables Mouse Remapping (cShift)"
	; ui.labelMouseRemap:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Remap Mouse")
	; ToggleMouseRemap(*)
	; {
		; ui.toggleMouseRemap.Opt((cfg.MouseRemapEnabled := !cfg.MouseRemapEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		; ui.toggleMouseRemap.Redraw()
		; iniWrite(cfg.MouseRemapEnabled,cfg.file,"System","MouseRemapEnabled")
	; }
	  
	cfg.confirmExitEnabled:=iniRead(cfg.file,"Toggles","ConfirmExitEnabled",true)
	ui.toggleconfirmExit := ui.MainGui.AddPicture("xs y+2 w50 h22 section vConfirmExit " (cfg.ConfirmExitEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.ConfirmExitEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleConfirmExit.OnEvent("Click", toggleChanged)
	ui.toggleConfirmExit.ToolTip := "Produces a confirmation prompt upon exiting the application."
	ui.labelConfirmExit:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Confirm Exit")


	TogglePushNotifications(*)
	{
		ui.togglePushNotifications.Opt((cfg.PushNotificationsEnabled := !cfg.PushNotificationsEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.togglePushNotifications.Redraw()
	}
	cfg.PushNotificationsEnabled:=iniRead(cfg.file,"Toggles","PushNotificationsEnabled",true)
	ui.togglePushNotifications := ui.MainGui.AddPicture("xs y+2 w50 h22 section vPushNotifications " (cfg.PushNotificationsEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.PushNotificationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.togglePushNotifications.OnEvent("Click", toggleChanged)
	ui.togglePushNotifications.ToolTip := "Enables pop-up notifications regarding in-game events."
	ui.labelPushNotifications:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Notifications")

	ToggleDebug(*)
	{
		ui.toggleDebug.Opt((cfg.DebugEnabled := !cfg.DebugEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleDebug.Redraw()
	}
	cfg.DebugEnabled:=iniRead(cfg.file,"Toggles","DebugEnabled",false)
	ui.toggleDebug := ui.MainGui.AddPicture("xs y+2 w50 h22 section vDebug " (cfg.DebugEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.DebugEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleDebug.OnEvent("Click", toggleChanged)
	ui.toggleDebug.ToolTip := "Keeps this app on top of all other windows."
	ui.labelDebug:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Debug")

	drawOutlineNamed("toggleBlock",ui.mainGui,49,39,52,162,cfg.themePanel2Color,cfg.themePanel2Color,1)
	drawOutlineNamed("toggleBlock",ui.mainGui,48,38,51,161,cfg.themeDark1Color,cfg.themeDark1Color,1)
	drawOutlineNamed("toggleBlock",ui.mainGui,48,39,52,163,cfg.themeBorderDarkColor,cfg.themeBorderDarkColor,1)
	ui.mainGui.addText("x270 y42 w197 h62 background" cfg.themePanel3Color)
	ui.mainGui.addText("x271 y43 w195 h60 background" cfg.themeBorderDarkColor)
	ui.mainGui.addText("x272 y44 w193 h58 background" cfg.themeBorderLightColor)
	ui.mainGui.addText("x273 y45 w191 h56 background" cfg.themePanel3Color)
	ui.checkForUpdatesLabel := ui.mainGui.addtext("x293 y46 w160 h30 section backgroundTrans c" cfg.themeFont3Color,"Check For Updates")
	ui.checkForUpdatesLabel.SetFont("s12")
	ui.checkForUpdatesButton := ui.mainGui.addPicture("xs-15 y+-9 w30 h30 section background" cfg.themeButtonOnColor,"./img/button_update.png")
	ui.checkForUpdatesButton.onEvent("Click",checkForUpdates)
	ui.checkForUpdatesButton.Tooltip := "Checks to see if a more recent version is available"	
	ui.installedVersionText := ui.mainGui.addText("ys-1 x+5 section w140 h19 backgroundTrans c" cfg.themeFont3Color ,"Installed:`t#.#.#.#")
	ui.latestVersionText := ui.mainGui.addText("xs y+-4 w140 backgroundTrans c" cfg.themeFont3Color,"Available:`t#.#.#.#")
	ui.monitorResList := ["1920x1080","1920x1200","2560x1440","3440x1440","Custom"]

	ui.monitorResDDL := ui.mainGui.AddDDL("xs-42 y+15 w90 r4 choose" cfg.monitorRes " background" cfg.themeBackgroundColor,ui.monitorResList)
	ui.monitorResDDL.onEvent("change",monitorResChanged)
	ui.monitorResLabel := ui.mainGui.AddText("x+3 y+-23 w65 c" cfg.themeFont1Color " backgroundTrans","Screen")	
	ui.monitorResLabel2 := ui.mainGui.AddText("y+-7 w65 c" cfg.themeFont1Color " backgroundTrans","Size")
	ui.monitorResLabel.setFont("s7")
	ui.monitorResLabel2.setFont("s7")
	ui.monitorAuto := ui.mainGui.addCheckbox("x+-22 y+-18 w15 h15",cfg.displaySizeAuto)
	ui.monitorAuto.onEvent("Click",toggleAutoDisplaySize)
	ui.monitorAutoLabel := ui.mainGui.addText("x+-21 y+-28 w25 h12 section c" cfg.themeFont1Color " backgroundTrans","Auto")
	ui.monitorAutoLabel.setFont("s8")

	ui.macroSpeed := ui.mainGui.addText("x+7 ys+13 w33 h16 center border section")
	ui.macroSpeed := ui.mainGui.addUpDown("vMacroSpeed range1-10",cfg.d2AppLoadoutMultiplier)
	ui.macroSpeedLabel := ui.mainGui.addText("x+-31 y+-29 w30 backgroundTrans","Delay")
	ui.macroSpeedLabel.setFont("s8")
	ui.macroSpeed.onEvent("change",macroSpeedChanged)
	ui.installedVersionText.setFont("s10")
	ui.latestVersionText.setFont("s10")

	macroSpeedChanged(*) {
		cfg.d2AppLoadoutMultiplier := ui.macroSpeed.value
	}

	if cfg.displaySizeAuto {
		ui.monitorResDDL.opt("disabled")
		ui.monitorAuto.value := true
	} else {
	ui.monitorResDDL.opt("-disabled")
		ui.monitorAuto.value := false
	}
	
	toggleAutoDisplaySize(*) {
		cfg.displaySizeAuto := ui.monitorAuto.Value
		if cfg.displaySizeAuto {
			ui.monitorResDDL.opt("disabled")
			monitorResChanged()
		} else {
			ui.monitorResDDL.opt("-disabled")
			ui.monitorResDDL.delete()
			ui.monitorResDDL.add(["1920x1080","1920x1200","2560x1440","3440x1440","Custom"])
			ui.monitorResDDL.text := cfg.monitorRes
		}
	}
	ui.themeEditorButton := ui.mainGui.addPicture("x275 y161 w35 h35 section backgroundTrans","./img/color_swatches.png")
	ui.themeEditorLabel := ui.mainGui.addText("x+8 ys+4 w150 h35 section background" cfg.themePanel1Color,"Theme Editor")
	ui.themeEditorLabel.setFont("s14")
	ui.themeEditorButton.onEvent("click",showThemeEditor)
	
  	AutoClickerSpeedChanged(*) {
	cfg.AutoClickerSpeed := (ui.AutoClickerSpeedSlider.Value/0.128)

}

ui.defaultThemes := "
(
[Interface]
ThemeList=Modern Class,Cold Steel,Militarized,Neon,Ocean
[Modern Class]
ThemeBorderLightColor=C0C0C0
ThemeBorderDarkColor=333333
ThemeBright1Color=1D1D1D
ThemeBright2Color=19F9F
ThemeBackgroundColor=4A5A60
ThemeFont1Color=1FFFF
ThemeFont2Color=FCC84B
ThemePanel1Color=355051
ThemePanel2Color=674704
ThemePanel3Color=355051
ThemePanel4Color=1D5852
ThemeEditboxColor=292929
ThemeDisabledColor=212121
ThemeButtonOnColor=FF01FF
ThemeButtonReadyColor=1FFFF
ThemeButtonAlertColor=FFCC00
[Cold Steel]
ThemeBorderLightColor=888888
ThemeBorderDarkColor=333333
ThemeBright1Color=313131
ThemeBright2Color=C0C0C0
ThemeBackgroundColor=414141
ThemeFont1Color=1FFFF
ThemeFont2Color=FAE7AD
ThemePanel1Color=204040
ThemePanel2Color=984C01
ThemePanel3Color=70D1C8
ThemePanel4Color=654901
ThemeEditboxColor=292929
ThemeDisabledColor=212121
ThemeButtonOnColor=FF01FF
ThemeButtonReadyColor=1FFFF
ThemeButtonAlertColor=FFCC00
[Militarized]
ThemeBorderLightColor=888888
ThemeBorderDarkColor=333333
ThemeBright1Color=66B1FE
ThemeBright2Color=FEFE98
ThemeBackgroundColor=606060
ThemeFont1Color=98CBFE
ThemeFont2Color=FE8001
ThemePanel1Color=202020
ThemePanel2Color=984C01
ThemePanel3Color=355051
ThemePanel4Color=70D1C8
ThemeEditboxColor=292929
ThemeDisabledColor=212121
ThemeButtonOnColor=01FE80
ThemeButtonReadyColor=CFA645
ThemeButtonAlertColor=FFCC00
[Ocean]
ThemeBorderLightColor=446466
ThemeBorderDarkColor=333333
ThemeBright1Color=365154
ThemeBright2Color=3C3C3C
ThemeBackgroundColor=2C3537
ThemeFont1Color=1FFFF
ThemeFont2Color=256D65
ThemePanel1Color=355051
ThemePanel2Color=70D1C8
ThemePanel3Color=355051
ThemePanel4Color=70D1C8
ThemeEditboxColor=292929
ThemeDisabledColor=212121
ThemeButtonOnColor=1FFFF
ThemeButtonReadyColor=9D9D9D
ThemeButtonAlertColor=FFCC00
[LCD]
ThemeBackgroundColor=B0C6B6
ThemeBorderLightColor=5B8471
ThemeBorderDarkColor=5E5E01
ThemeBright1Color=1D1D1D
ThemeBright2Color=19F9F
ThemeFont1Color=E9F977
ThemeFont2Color=303030
ThemePanel1Color=6D8B87
ThemePanel2Color=73714D
ThemePanel3Color=6D8B87
ThemePanel4Color=73714D
ThemeEditboxColor=CEAFD1
ThemeDisabledColor=212121
ThemeButtonOnColor=FF01FF
ThemeButtonReadyColor=D7FF82
ThemeButtonAlertColor=FFCC00
[Neon]
ThemeBackgroundColor=414141
ThemeBorderLightColor=888888
ThemeBorderDarkColor=333333
ThemeBright1Color=C0C0C0
ThemeBright2Color=FFFFFF
ThemeFont1Color=1FFFF0
ThemeFont2Color=FBD58E
ThemePanel1Color=204040
ThemePanel2Color=804001
ThemePanel3Color=204040
ThemePanel4Color=804001
ThemeEditboxColor=292929
ThemeDisabledColor=212121
ThemeButtonOnColor=FF01FF
ThemeButtonReadyColor=1FFFF0
ThemeButtonAlertColor=FFCC00
)"
}