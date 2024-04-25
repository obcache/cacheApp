#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}

;libGuiSetupTab
monitorResChanged(*) {
	cfg.monitorRes := ui.monitorResDDL.text
	if (cfg.monitorRes == "Auto") {
		ui.monitorResDDL.delete()
		ui.monitorResDDl.add(["Auto (" primaryMonitorBottom ")",1080,1440,"Custom"])
		ui.monitorResDDL.text := "Auto (" primaryMonitorBottom ")"
		}

	d2CreateHotkeys()
}

GuiSetupTab(&ui,&cfg) {
	global
	ui.MainGuiTabs.UseTab("Setup")
	
	drawPanel(ui.mainGui,45,35,210,170,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	drawPanel(ui.mainGui,265,35,210,110,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	drawPanel(ui.mainGui,265,150,210,55,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,"none",100,"Features","Calibri",cfg.themeFont1Color)
	
	ui.MainGui.SetFont("s09")
	ui.AutoClickerSpeedSlider := ui.MainGui.AddSlider("x52 y40 w25 h150 Range1-64 Vertical Left TickInterval8 Invert ToolTipTop",cfg.AutoClickerSpeed)
	ui.AutoClickerSpeedSlider.ToolTip := "AutoClicker Speed"
	ui.AutoClickerSpeedSliderLabel2 := ui.MainGui.AddText("x39 y189 w50 r1 Center BackgroundTrans","CPS")
	drawOutlineNamed("autoClicker",ui.mainGui,52,40,25,150,cfg.themeBorderLightColor,cfg.themeBorderDarkColor,1)
	ui.AutoClickerSpeedSlider.OnEvent("Change",AutoClickerSpeedChanged)
	
	ui.MainGui.SetFont("s10 c" cfg.themeFont1Color)
	drawOutlineMainGui(39,31,499,182,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2)
	
	ui.MainGui.SetFont("s12")
	
	

	
	ToggleAfkSnap(*)
	{
		ui.toggleAfkSnap.Opt((cfg.AfkSnapEnabled := !cfg.AfkSnapEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAfkSnap.Redraw()
	}
	
	ui.toggleAfkSnap := ui.MainGui.AddPicture("x85 y20 w60 h1 section hidden vAfkSnap " (cfg.AfkSnapEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AfkSnapEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAfkSnap.OnEvent("Click", toggleChanged)
	ui.toggleAfkSnap.ToolTip := "Toggles Afk Screen Snapping"
	ui.labelAfkSnap:= ui.MainGui.AddText("x+3 ys+3 hidden backgroundTrans","AFK Snapping")


	ui.toggleToolTips := ui.MainGui.AddPicture("xs w60 h25 section vToolTips " ((cfg.ToolTipsEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.ToolTipsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleToolTips.OnEvent("Click", toggleChanged)
	ui.toggleToolTips.ToolTip := "Toggles ToolTips"
	ui.labelToolTips := ui.MainGui.AddText("x+3 ys+3 BackgroundTrans","ToolTips")


	ToggleAlwaysOnTop(*)
	{
		ui.toggleAlwaysOnTop.Opt((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAlwaysOnTop.Redraw()
	}
	ui.toggleAlwaysOnTop := ui.MainGui.AddPicture("xs y+3 w60 h25 section vAlwaysOnTop " (cfg.AlwaysOnTopEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AlwaysOnTopEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAlwaysOnTop.OnEvent("Click", ToggleChanged)
	ui.toggleAlwaysOnTop.ToolTip := "Keeps this app on top of all other windows."
	ui.labelAlwaysOnTop:= ui.MainGui.AddText("x+3 ys+3 backgroundTrans","AlwaysOnTop")	
	

	
	ToggleAnimations(*)
	{
		ui.toggleAnimations.Opt((cfg.AnimationsEnabled := !cfg.AnimationsEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAnimations.Redraw()
	}
	ui.toggleAnimations := ui.MainGui.AddPicture("xs w60 y+3 h25 section vAnimations " (cfg.AnimationsEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AnimationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAnimations.OnEvent("Click", toggleChanged)
	ui.toggleAnimations.ToolTip := "Keeps this app on top of all other windows."
	ui.labelAnimations:= ui.MainGui.AddText("x+3 ys+3 backgroundTrans","Animations")
	
	ToggleStartMinimized(*)
	{
		ui.toggleStartMinimized.Opt((cfg.StartMinimizedEnabled := !cfg.StartMinimizedEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleStartMinimized.Redraw()
	}
	ui.toggleStartMinimized := ui.MainGui.AddPicture("xs y+3 w60 h25 section vStartMinimized " (cfg.StartMinimizedEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.StartMinimizedEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleStartMinimized.OnEvent("Click", toggleChanged)
	ui.toggleStartMinimized.ToolTip := "Keeps this app on top of all other windows."
	ui.labelStartMinimized:= ui.MainGui.AddText("x+3 ys+3 backgroundTrans","Start Minimized")
	

	ui.toggleconfirmExit := ui.MainGui.AddPicture("xs y+3 w60 h25 section vConfirmExit " (cfg.ConfirmExitEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.ConfirmExitEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleConfirmExit.OnEvent("Click", toggleChanged)
	ui.toggleConfirmExit.ToolTip := "Keeps this app on top of all other windows."
	ui.labelConfirmExit:= ui.MainGui.AddText("x+3 ys+3 backgroundTrans","Confirm Exit")
	
	ToggleDebug(*)
	{
		ui.toggleDebug.Opt((cfg.DebugEnabled := !cfg.DebugEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleDebug.Redraw()
	}
	ui.toggleDebug := ui.MainGui.AddPicture("xs y+3 w60 h25 section vDebug " (cfg.DebugEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.DebugEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleDebug.OnEvent("Click", toggleChanged)
	ui.toggleDebug.ToolTip := "Keeps this app on top of all other windows."
	ui.labelDebug:= ui.MainGui.AddText("x+3 ys+3 backgroundTrans","Debug")
	ui.checkForUpdatesLabel := ui.mainGui.addtext("x275 y42 w160 h30 section backgroundTrans c" cfg.themeFont1Color,"Check For Updates")
	ui.checkForUpdatesLabel.SetFont("s12")
	ui.checkForUpdatesButton := ui.mainGui.addPicture("xs y+-10 w30 h30 section background" cfg.themeButtonReadyColor,"./img/button_update.png")
	ui.checkForUpdatesButton.onEvent("Click",checkForUpdates)
	ui.checkForUpdatesButton.Tooltip := "Checks to see if a more recent version is available"	
	ui.installedVersionText := ui.mainGui.addText("ys x+5 section w100 backgroundTrans","Installed:" ui.installedVersion)
	ui.latestVersionText := ui.mainGui.addText("xs y+0 w100 backgroundTrans","Latest:" ui.latestVersion)
	
	ui.monitorResDDL := ui.mainGui.AddDDL("xs-35 y+10 w100 r4 choose" cfg.monitorRes " background" cfg.themeBackgroundColor,["Auto","1080","1440","Custom"])
	ui.monitorResDDL.onEvent("change",monitorResChanged)
	ui.monitorResLabel := ui.mainGui.AddText("x+5 w65 c" cfg.themeFont1Color " backgroundTrans","Display")	
	ui.monitorResLabel2 := ui.mainGui.AddText("y+-7 w65 c" cfg.themeFont1Color " backgroundTrans","Resolution")
	ui.monitorResLabel.setFont("s09")
	ui.monitorResLabel2.setFont("s09")

	ui.installedVersionText.setFont("s10")
	ui.latestVersionText.setFont("s10")

	ui.themeEditorButton := ui.mainGui.addPicture("x275 y161 w35 h35 section backgroundTrans","./img/color_swatches.png")
	ui.themeEditorLabel := ui.mainGui.addText("x+8 ys+4 w150 h35 section background" cfg.themePanel1Color,"Theme Editor")
	ui.themeEditorLabel.setFont("s14")
	ui.themeEditorButton.onEvent("click",showThemeEditor)
	
  	AutoClickerSpeedChanged(*) {
		cfg.AutoClickerSpeed := (ui.AutoClickerSpeedSlider.Value/0.128)
			
		; Switch
		; {
			
			; case ui.AutoClickerSpeedSlider.Value < 20:
			; {
				; cfg.AutoClickerSpeed := (ui.AutoClickerSpeedSlider.Value * .75)
			; }
			; case ui.AutoClickerSpeedSlider.Value >= 20:
			; {
				; cfg.AutoClickerSpeed := ui.AutoClickerSpeedSlider.Value
			; }
		; }
	}


	{ ;Functions for Game Profile List Management (Including Modal Pop-up Interaces)

	} ;End Game Profile List Modal Gui

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