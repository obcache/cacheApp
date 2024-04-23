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
	ui.MainGui.SetFont("s09")
	ui.AutoClickerSpeedSlider := ui.MainGui.AddSlider("x40 y40 w25 h160 Range1-64 Vertical Left TickInterval8 Invert ToolTipTop",cfg.AutoClickerSpeed)
	ui.AutoClickerSpeedSlider.ToolTip := "AutoClicker Speed"
	ui.AutoClickerSpeedSliderLabel2 := ui.MainGui.AddText("x30 y195 w50 r1 Center BackgroundTrans","CPS")
	
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
	ui.labelAfkSnap:= ui.MainGui.AddText("x+3 ys+3 hidden","AFK Snapping")


	; toggleCol1 := ["Tooltips","Always On Top","Confirm Exit","Animations","Start Minimized"]
	; createToggles(ui.mainGui,150,150,toggleCol1,cfg.toggleOn,cfg.toggleOff,cfg.themeButtonOnColor,cfg.themeButtonReadyColor,cfg.file,"Interface")
	
	; createToggles(guiName,posX,posY,toggleNamesArr,toggleOnImg,toggleOffImg,toggleOnColor,toggleOffColor,iniFile,iniSection) {
		; guiName.addText("x" posX " y" posY " hidden section")
		; for thisToggle in toggleNamesArr {
			; toggleName := RegExReplace(thisToggle, "\s")
			; toggleValue := iniRead(iniFile,iniSection,"%toggleName%enabled",false)
			; global toggle%toggleName% := guiName.addPicture("xs+0 y+0 w60 h25 section background" (cfg.%toggleName%enabled) ? (toggleOnColor,toggleOnImg) : (toggleOffColor,toggleOffImg))
			; toggle%toggleName%.onEvent("click", () =>
			; ((%toggleName%enabled := !%toggleName%enabled)
				; ? (toggle%toggleName%.opt("background" toggleOnColor),toggle%toggleName%.value := toggleOnImg)
				; : (toggle%toggleName%.opt("background" toggleOffColor),toggle%toggleName%.value := toggleOffImg),
				; iniWrite(%toggleName%enabled,iniFile,iniSection,%toggleName%enabled)))
		; }
	; }
			
	ui.toggleToolTips := ui.MainGui.AddPicture("xs w60 h25 section vToolTips " ((cfg.ToolTipsEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.ToolTipsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleToolTips.OnEvent("Click", toggleChanged)
	ui.toggleToolTips.ToolTip := "Toggles ToolTips"
	ui.labelToolTips := ui.MainGui.AddText("x+3 ys+3 BackgroundTrans","ToolTips")


	ToggleAlwaysOnTop(*)
	{
		ui.toggleAlwaysOnTop.Opt((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAlwaysOnTop.Redraw()
	}
	ui.toggleAlwaysOnTop := ui.MainGui.AddPicture("xs w60 h25 section vAlwaysOnTop " (cfg.AlwaysOnTopEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AlwaysOnTopEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAlwaysOnTop.OnEvent("Click", ToggleChanged)
	ui.toggleAlwaysOnTop.ToolTip := "Keeps this app on top of all other windows."
	ui.labelAlwaysOnTop:= ui.MainGui.AddText("x+3 ys+3","AlwaysOnTop")	
	

	
	ToggleAnimations(*)
	{
		ui.toggleAnimations.Opt((cfg.AnimationsEnabled := !cfg.AnimationsEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleAnimations.Redraw()
	}
	ui.toggleAnimations := ui.MainGui.AddPicture("xs w60 h25 section vAnimations " (cfg.AnimationsEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.AnimationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAnimations.OnEvent("Click", toggleChanged)
	ui.toggleAnimations.ToolTip := "Keeps this app on top of all other windows."
	ui.labelAnimations:= ui.MainGui.AddText("x+3 ys+3","Animations")
	
	ToggleStartMinimized(*)
	{
		ui.toggleStartMinimized.Opt((cfg.StartMinimizedEnabled := !cfg.StartMinimizedEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		ui.toggleStartMinimized.Redraw()
	}
	ui.toggleStartMinimized := ui.MainGui.AddPicture("xs w60 h25 section vStartMinimized " (cfg.StartMinimizedEnabled ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor)),((cfg.StartMinimizedEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleStartMinimized.OnEvent("Click", toggleChanged)
	ui.toggleStartMinimized.ToolTip := "Keeps this app on top of all other windows."
	ui.labelStartMinimized:= ui.MainGui.AddText("x+3 ys+3","Start Minimized")
	

	ui.checkForUpdatesButton := ui.mainGui.addPicture("xs y+5 w30 h30 section background" cfg.themeButtonReadyColor,"./img/button_update.png")
	ui.checkForUpdatesButton.onEvent("Click",checkForUpdates)
	ui.checkForUpdatesButton.Tooltip := "Checks to see if a more recent version is available"	
	ui.installedVersionText := ui.mainGui.addText("ys x+5 section w100 backgroundTrans","Installed:" ui.installedVersion)
	ui.latestVersionText := ui.mainGui.addText("xs y+-5 w100 backgroundTrans","Latest:" ui.latestVersion)
	ui.monitorResDDL := ui.mainGui.AddDDL("xs-35 w100 r4 choose" cfg.monitorRes " background" cfg.themeBackgroundColor,["Auto","1080","1440","Custom"])
	ui.monitorResDDL.onEvent("change",monitorResChanged)
	ui.monitorResLabel := ui.mainGui.AddText("x+5 w65 c" cfg.themeFont1Color " backgroundTrans","Display")	
	ui.monitorResLabel2 := ui.mainGui.AddText("y+-7 w65 c" cfg.themeFont1Color " backgroundTrans","Resolution")
	ui.monitorResLabel.setFont("s09")
	ui.monitorResLabel2.setFont("s09")

	ui.installedVersionText.setFont("s10")
	ui.latestVersionText.setFont("s10")

	AutoClickerSpeedChanged(*) {
		cfg.AutoClickerSpeed := (ui.AutoClickerSpeedSlider.Value/0.128)
	}
	ui.themeEditorButton := ui.mainGui.addPicture("x485 y160 w40 h40 section","./img/color_swatches.png")
	ui.themeEditorButton.onEvent("click",(*) => 
		(ui.themeEditorVisible := !ui.themeEditorVisible) 
			? guiVis(ui.themeEditorGui,true)
			: guiVis(ui.themeEditorGui,false))
	ui.themeEditorLabel := ui.mainGui.addText("xs-10 y+-70 w60 h40 center backgroundTrans c" cfg.themeFont1Color,"Theme Editor")
	ui.themeEditorLabel.setFont("s9")
{ ;themeUi
	ui.themeEditorGui := gui()
	ui.themeEditorGui.opt("-caption alwaysOnTop owner" ui.mainGui.hwnd)
	ui.themeEditorGui.backColor := cfg.themeBackgroundColor
	ui.themeEditorTitleBar	:= ui.themeEditorGui.addText("x0 y0 w500 h20 background" cfg.themePanel2Color)
	ui.themeEditorTitleBar.onEvent("click", wm_lButtonDown_callback)
	

	
	

	ui.toggleColorSelector := ui.themeEditorGui.AddPicture("y23 x5 section w60 h23 ", (cfg.ColorPickerEnabled) ? ("./Img/toggle_right.png") : ("./Img/toggle_left.png"))
	ui.toggleColorSelector.OnEvent("Click", ToggleColorSelector)
	ui.toggleColorSelector.ToolTip := "Select color picking method for theming features"
	ui.ColorSelectorLabel2 := ui.themeEditorGui.AddText("x+-2 ys+2 h21 section w77 BackgroundTrans c"
		((cfg.ColorPickerEnabled) 
			? cfg.ThemeFont3Color " background" cfg.themePanel3Color 
			: cfg.ThemeFont3Color " background" cfg.themePanel3Color) 
		,((cfg.ColorPickerEnabled) 
			? (" Color App") 
			: (" Swatches ")))

	ui.ColorSelectorLabel2.setFont("s12","calibri bold")

	ui.buttonNewTheme := ui.themeEditorGui.AddPicture("x+0 ys+0  section w23 h22 Background" cfg.ThemeButtonReadyColor,"./Img/button_plus_ready.png")
	ui.buttonNewTheme.OnEvent("Click",addTheme)
	
	ui.ThemeDDL := ui.themeEditorGui.AddDDL("x+0 ys-1 w120 section center Background" cfg.ThemeEditboxColor,cfg.ThemeList)
	;
	ui.ThemeDDL.OnEvent("Change",ThemeChanged)
	ui.ThemeDDL.OnEvent("Focus",RepaintThemeDDL)
	ui.ThemeDDL.OnEvent("LoseFocus",RepaintThemeDDL)
	ui.themeEditorGui.SetFont("s09")
	ui.ThemeDDL.ToolTip := "Select Theme Preset"
	ui.buttonDelTheme := ui.themeEditorGui.AddPicture("ys+1 x+-2 w23 h22 Background" cfg.ThemeButtonReadyColor,"./Img/button_minus_ready.png")	
	ui.buttonDelTheme.OnEvent("Click",removeTheme)
	drawOutlineNamed("ThemeOutline",ui.themeEditorGui,5,22,302,27,cfg.ThemeBorderLightColor,cfg.ThemeBorderLightColor,3)
	drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,5,22,302,27,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)
	drawOutlineNamed("ThemeOutline",ui.themeEditorGui,5,22,302,27,cfg.ThemeBorderLightColor,cfg.ThemeBorderLightColor,3)
	drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,5,22,302,27,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)
	ui.ThemeDDL.Choose(1)
	Loop cfg.ThemeList.Length {
		if (cfg.ThemeList[A_Index] == cfg.Theme) {
			ui.ThemeDDL.Choose(cfg.Theme)
			Break
		}
	}

	ui.ThemeDDL.SetFont("s11")
	ui.ThemeElements := [
		"ThemePanel1Color",		"ThemePanel2Color",		
		"ThemeFont1Color",		"ThemeFont2Color",
		"ThemeBright1Color",	"ThemeBright2Color",	"ThemeEditboxColor",
		"ThemePanel3Color",		"ThemePanel4Color",
		"ThemeFont3Color",		"ThemeFont4Color",	
		"ThemeDark1Color",		"ThemeDark2Color",		"ThemeProgressColor",		
		"ThemeBackgroundColor",	"ThemeDisabledColor",
		"ThemeBorderDarkColor",	"ThemeBorderLightColor",
		"ThemeButtonReadyColor","ThemeButtonOnColor", 	"ThemeButtonAlertColor"]

	ui.themeEditorGui.SetFont("s10")
	ui.themeEditorGui.AddText("x10 y42 section hidden")



	ToggleColorSelector(*)
	{
		ui.toggleColorSelector.Value := 
			(cfg.ColorPickerEnabled := !cfg.ColorPickerEnabled) 
				? (ui.ColorSelectorLabel2.Opt("c" cfg.ThemeFont3Color " background" cfg.themePanel3Color)
					,ui.ColorSelectorLabel2.Text := " Color App "
					,"./Img/toggle_right.png")
				: (ui.ColorSelectorLabel2.Opt("c" cfg.ThemeFont3Color " background" cfg.ThemePanel3Color)
					,ui.ColorSelectorLabel2.Text := " Swatches "
					,"./Img/toggle_left.png") 
		ui.toggleColorSelector.Redraw()
	}
	
	Loop ui.ThemeElements.Length
	{
		this_color := ui.ThemeElements[A_Index]
		if (A_Index == 8 || A_Index == 15)
			ui.themeEditorGui.AddText("x+5 y42 section hidden")
		ui.%this_color%Picker := ui.themeEditorGui.AddText("xs y+2 section w30 h20 Border Background" cfg.%this_color% " c" cfg.%this_color%,this_color)
		ui.%this_color%Label := ui.themeEditorGui.AddText("x+5 ys+2 c" cfg.ThemeFont1Color,StrReplace(SubStr(this_color,6),"Color"))
		ui.%this_color%Picker.OnEvent("Click",PickColor)
	}

	ControlFocus(ui.toggleColorSelector,ui.themeEditorGui)

	PickColor(Obj,msg,Info*)
	{
		this_color := Obj.Text
		prev_color := cfg.%this_color%
		cfg.%this_color% := ChooseColor(this_color,prev_color)
		IniWrite(cfg.%this_color%,cfg.themeFile,cfg.Theme,this_color)
		;ui.ThemeDDL.Choose("Custom")
		;Sleep(1000)
		Reload()
	}
  

	RepaintThemeDDL(*) {
		ui.themeDDL.choose(ui.themeDDL.value)
		drawOutlineNamed("ThemeOutline",ui.themeEditorGui,305,34,222,27,cfg.ThemeBorderLightColor,cfg.ThemeBorderLightColor,3)
		drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,305,34,222,27,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)
	}
	
	ThemeChanged(*) {
		Reload()
	}

	ChooseColor(ColorType,prev_color)
	{
		if (cfg.ColorPickerEnabled)
		{
			DialogBox("Click the color youd like to use for " ColorType "`non the Color Chart","Selecting Color for " ColorType)
			ChosenColor := Format("{:X}", RunWait('./lib/ColorChooser.exe 0x' cfg.%ColorType% ' ' cfg.GuiX ' ' cfg.GuiY))
		
			DialogBoxClose()
			if (ChosenColor == 0) || (ChosenColor == "")
			{
				NotifyOSD("No Color Chosen",3000)
				Return prev_color
			} else {
				NotifyOSD("You have selected: " ChosenColor "`nfor the " ColorType " category.",3000)
				if (InStr(ChosenColor,"0x")) {
					ChosenColor := SubStr(ChosenColor,3,6)
				}
				Return ChosenColor	
			}
		} else {
			winGetPos(&DialogX,&DialogY,&DialogW,&DialogH,ui.themeEditorGui)
			ui.colorGui := Gui()
			ui.colorGui.Opt("+AlwaysOnTop -Caption +Owner" ui.themeEditorGui.Hwnd)
			ui.ColorPicker := ui.colorGui.AddPicture("w515 h1000","./Img/color_swatches.png")
			ui.colorGui.Show("x" DialogX " y" DialogY+DialogH " NoActivate")
			Sleep(1000)
			ClickReceived := KeyWait("LButton","D T15")
			
			if (ClickReceived)
			{
				MouseGetPos(&MouseX,&MouseY)
				ChosenColor := PixelGetColor(MouseX,MouseY)
				if (ChosenColor == 0) || (ChosenColor == "")
				{
					DialogBox("No Color Chosen")
					SetTimer(DialogBoxClose,-3000)
					Return prev_color
				} else {
					DialogBox("You have selected: " ChosenColor "`nfor the " ColorType " category.")
					SetTimer(DialogBoxClose,-3000)
					if (InStr(ChosenColor,"0x")) {
						ChosenColor := SubStr(ChosenColor,3,6)
					}
					Return ChosenColor	
				}
			} else {
				DialogBoxClose()
				DialogBox("No Color Chosen. `nReturning to App.")
				SetTimer(DialogBoxClose,-3000)
			}
			
			ui.colorGui.Destroy()
		}
	}
} ;end themeUI


	{ ;Functions for Game Profile List Management (Including Modal Pop-up Interaces)
		addTheme(*) {
			Global
			ui.newThemeGui := Gui(,"Add New Theme")
			ui.newThemeGui.BackColor := "505050"
			ui.newThemeGui.Color := "212121"
			ui.newThemeGui.Opt("-Caption -Border +AlwaysOnTop")
			ui.newThemeGui.SetFont("s16 cFF00FF", "Calibri Bold")
			
			ui.newThemeGui.AddText("x10 y10 section","Choose Name for New Custom Theme")
			ui.newThemeEdit := ui.newThemeGui.AddEdit("xs section w180","")
			ui.newThemeOkButton := ui.newThemeGui.AddPicture("x+-7 ys w40 h40 Background" cfg.ThemeButtonReadyColor,"./Img/button_save_up.png")
			ui.newThemeOkButton.OnEvent("Click",addThemeToDDL)
			ui.newThemeGui.Show("w260 h110 NoActivate")
			drawOutline(ui.newThemeGui,5,5,250,100,cfg.ThemeBright2Color,cfg.ThemeBright1Color,2)	;New App Profile Modal Outline

			addThemeToDDL(*) {
				Global
				cfg.themeList.Push(ui.newThemeEdit.Value)
				currentTheme := cfg.Theme
				newThemeName := ui.newThemeEdit.value
				ui.themeDDL.Delete()
				ui.themeDDL.Add(cfg.themeList)
				ui.themeDDL.Choose(ui.newThemeEdit.value)

				{ ;write new Theme to ini
				IniWrite(cfg.ThemeBright2Color,cfg.file,ui.newThemeEdit.Value,"ThemeBright2Color")
				IniWrite(cfg.ThemeBright1Color,cfg.file,ui.newThemeEdit.Value,"ThemeBright1Color")
				IniWrite(cfg.ThemeDark2Color,cfg.file,ui.newThemeEdit.Value,"ThemeDark2Color")
				IniWrite(cfg.ThemeDark1Color,cfg.file,ui.newThemeEdit.Value,"ThemeDark1Color")
				IniWrite(cfg.ThemeBorderDarkColor,cfg.file,ui.newThemeEdit.Value,"ThemeBorderDarkColor")
				IniWrite(cfg.ThemeBorderLightColor,cfg.file,ui.newThemeEdit.Value,"ThemeBorderLightColor")
				IniWrite(cfg.ThemeBackgroundColor,cfg.file,ui.newThemeEdit.Value,"ThemeBackgroundColor")
				IniWrite(cfg.ThemeFont1Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont1Color")
				IniWrite(cfg.ThemeFont2Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont2Color")
				IniWrite(cfg.ThemeFont3Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont3Color")
				IniWrite(cfg.ThemeFont4Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont4Color")
				IniWrite(cfg.ThemePanel1Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel1Color")
				IniWrite(cfg.ThemePanel3Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel3Color")
				IniWrite(cfg.ThemePanel2Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel2Color")
				IniWrite(cfg.ThemePanel4Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel4Color")
				IniWrite(cfg.ThemeEditboxColor,cfg.file,ui.newThemeEdit.Value,"ThemeEditboxColor")
				IniWrite(cfg.ThemeProgressColor,cfg.file,ui.newThemeEdit.Value,"ThemeProgressColor")
				IniWrite(cfg.ThemeDisabledColor,cfg.file,ui.newThemeEdit.Value,"ThemeDisabledColor")
				IniWrite(cfg.ThemeButtonOnColor,cfg.file,ui.newThemeEdit.Value,"ThemeButtonOnColor")
				IniWrite(cfg.ThemeButtonReadyColor,cfg.file,ui.newThemeEdit.Value,"ThemeButtonReadyColor")
				IniWrite(cfg.ThemeButtonAlertColor,cfg.file,ui.newThemeEdit.Value,"ThemeButtonAlertColor")
				} ;end writing theme to ini
				
				ui.newThemeGui.Destroy()
				
			}
		}

		removeTheme(*) {
			if cfg.themeList.Length == 1 {
			{
				ResetDefaultThemes()
			} else {
				cfg.themeList.RemoveAt(ui.themeDDL.value)
				ui.themeDDL.Delete()
				ui.themeDDL.Add(cfg.themeList)
				ui.themeDDL.Choose(1)
			}
		}

	} ;End Game Profile List Modal Gui

	}
	guiVis(ui.themeEditorGui,false)
	ui.themeEditorGui.show("autoSize noActivate")
	ui.mainGui.move(cfg.guiX,cfg.guiY)
	
