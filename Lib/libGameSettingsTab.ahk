#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}


inputHookAllowedKeys := "{All}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Left}{Right}{Up}{Down}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}{Tab}{Enter}{ScrollLock}{LButton}{MButton}{RButton}"	

ui.d2FlashingIncursionNotice := false
ui.d2ShowingIncursionNotice := false
ui.incursionDebug := false

ui.d2FlyEnabled := false


d2drawPanel1(*) {
	guiName := ui.gameSettingsGui
	ui.d2KeybindWidth := 60
	labelX := 280
	labelY := 44
	labelW := 80
	labelH := 23
	backColor := cfg.themePanel2Color
	fontColor := cfg.themeFont2Color
	outlineColor := cfg.themeDark2Color
	labelText := "Keybinds"
	ui.d2keybindAppTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
		     
	labelX := 360
	labelY := 44
	labelW := 900
	labelH := 23
	backColor := cfg.themePanel4Color
	fontColor := cfg.themeFont4Color
	outlineColor := cfg.themeBright1Color
	labelText := "Game Settings"	
	
	
	ui.d2keybindGameTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
	ui.d2Panel1Tab1Bg := ui.gameSettingsGui.addText("x39 y10 w411 h43 background" cfg.themeBright1Color,"")
	ui.d2Panel1Tab1Bg2 := ui.gameSettingsGui.addText("x39 y10 w410 h42 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
	ui.d2Panel1Tab1Bg3 := ui.gameSettingsGui.addText("x40 y11 w407 h40 background" cfg.themeDark1Color,"")
	ui.d2Panel1Tab1Bg4 := ui.gameSettingsGui.addText("x41 y12 w407 h40 background" cfg.themePanel2Color,"")
	
	ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("hidden x19 y10 w438 h43 background" cfg.themeBright1Color,"")
	ui.d2Panel1Tab2Bg2 := ui.gameSettingsGui.addText("hidden x19 y10 w437 h42 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
	ui.d2Panel1Tab2Bg3 := ui.gameSettingsGui.addText("hidden x20 y11 w434 h40 background" cfg.themeDark1Color,"")
	ui.d2Panel1Tab2Bg4 := ui.gameSettingsGui.addText("hidden x21 y12 w434 h40 background" cfg.themePanel2Color,"")
	
	;ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("x42 y10 w406 h42 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
	;drawOutlineNamed("gameSettings",ui.gameSettingsGui,43,11,404,42,cfg.themeDark1Color,cfg.themeBright1Color,1)
	ui.currKey := cfg.d2AppPauseKey
	ui.d2AppPauseKey			:= ui.gameSettingsGui.addPicture("x46 y17 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2AppPauseKeyData 	:= ui.gameSettingsGui.addText("xs-2 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppPauseKey),1,8))
	ui.d2AppPauseKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h20 center c" cfg.themeFont1Color " backgroundTrans","Pause App")
	
	ui.keybindSpacer	:= ui.gameSettingsGui.addText("x+6 y+-18 w1 h40 background" cfg.themeBright2Color)		
	ui.keybindSpacer2	:= ui.gameSettingsGui.addText("x+0 y+-40 w1 h40 background" cfg.themeBorderLightColor)
	
	ui.currKey := cfg.d2AppToggleSprintKey
	ui.d2AppToggleSprintKey			:= ui.gameSettingsGui.addPicture("x+4 y17 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2AppToggleSprintKeyData 	:= ui.gameSettingsGui.addText("xs-2 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppToggleSprintKey),1,8))
	ui.d2AppToggleSprintKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h20 center c" cfg.themeFont1Color " backgroundTrans","Sprint")
	
	ui.currKey := cfg.d2AppHoldToCrouchKey
	ui.d2AppHoldToCrouchKey					:= ui.gameSettingsGui.AddPicture("x+5 ys w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2AppHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppHoldToCrouchKey),1,8))
	ui.d2AppHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h20 center c" cfg.themeFont1Color " backgroundTrans","Crouch")

	ui.currKey := cfg.d2AppReloadKey
	ui.d2AppReloadKey						:= ui.gameSettingsGui.addPicture("x+5 ys w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2AppReloadKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppReloadKey),1,8))
	ui.d2AppReloadKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h20 center c" cfg.themeFont1Color " backgroundTrans","Reload")

	ui.currKey := cfg.d2AppLoadoutKey
	ui.d2AppLoadoutKey				:= ui.gameSettingsGui.addPicture("x+5 ys w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		"  h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2AppLoadoutKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		"  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2AppLoadoutKey),1,8))
	ui.d2AppLoadoutKeyLabel 		:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		"  h20 center c" cfg.themeFont1Color " backgroundTrans","Loadout")
	
	ui.currKey 					:= cfg.d2AppSwordFlyKey
	ui.d2AppSwordFlyKey			:= ui.gameSettingsGui.addPicture("x+11 ys w36 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2AppSwordFlyKeyData 	:= ui.gameSettingsGui.addText("xs+0 y+-24 w36 h21 center c" cfg.themeButtonAlertColor " backgroundTrans"
		,subStr(strUpper(cfg.d2AppSwordFlyKey),1,8))
	ui.d2AppSwordFlyKeyLabel 	:= ui.gameSettingsGui.addText("xs+0 y+-34 w36 h20 center c" cfg.themeFont1Color " backgroundTrans","Fly")
	ui.d2ClassSelectOutline		:= ui.gameSettingsGui.addText("xs+40 y+-20 w41 h42 background" cfg.themeDark2Color)
	ui.d2ClassSelectOutline2	:= ui.gameSettingsGui.addText("xs+41 y+-41 w40 h42 background" cfg.themeBright1Color)
	ui.d2ClassSelectBg			:= ui.gameSettingsGui.addText("x+-39 y+-42 w38 h41 background" cfg.themePanel2Color)
	ui.d2ClassSelectBg2			:= ui.gameSettingsGui.addText("hidden xs y+-14 w38 h16 background" cfg.themeDark1Color)
	ui.d2ClassSelectBgLine		:= ui.gameSettingsGui.addText("xs+40 y+-19 w40 h1 background" cfg.themeBright2Color)
	; ui.d2ClassSelectBg3			:= ui.gameSettingsGui.addText("xs+40 y+-13 w38 h12 background" cfg.themePanel2Color)
	ui.d2ClassIcon				:= ui.gameSettingsGui.addPicture("x441 y10 w37 h26 center backgroundTrans","")
	ui.d2ClassIconDown			:= ui.gameSettingsGui.addText("x441 y37 w18 h13 center backgroundTrans c" cfg.themeButtonOnColor,"←")
	ui.d2ClassIconUp			:= ui.gameSettingsGui.addText("x460 y37 w19 h13 center backgroundTrans c" cfg.themeButtonOnColor,"→")
	ui.d2ClassSelectSpacer 		:= ui.gameSettingsGui.addText("hidden x459 y36 w1 h15 background" cfg.themeBright2Color)
	ui.d2KeyBindHelpMsg			:= ui.gameSettingsGui.addText("x45 y54 w350 h12 backgroundTrans c" cfg.themeFont1Color,"")
	ui.d2ClassIcon.toolTip 		:= "Click to Enable/Disable the Fly Macro"
	ui.d2ClassIconDown.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.d2ClassIconUp.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.keybindSpacer3			:= ui.gameSettingsGui.addText("x393 y11 w1 h41 background" cfg.themeBright2Color)		
	ui.keybindSpacer4			:= ui.gameSettingsGui.addText("x394 y11 w1 h41 background" cfg.themeBorderLightColor)
	ui.d2ClassIconSpacer		:= ui.gameSettingsGui.addText("x439 y11 w1 h41 background" cfg.themeBright2Color,"")
	ui.d2ClassIconSpacer2		:= ui.gameSettingsGui.addText("x440 y11 w1 h41 background" cfg.themeBorderLightColor,"")
	ui.d2ClassIconDown.setFont("s9")
	ui.d2ClassIconDown.onEvent("click",d2ClassIconDownChanged)
	ui.d2ClassIconUp.setFont("s9")
	ui.d2ClassIconUp.onEvent("click",d2ClassIconUpChanged)
	ui.d2KeyBindHelpMsg.setFont("s8")
	ui.d2ClassIcon.onEvent("click",d2ToggleFly)

	d2ToggleFly()
	d2ToggleFly(*) {
		(ui.d2FlyEnabled := !ui.d2FlyEnabled)

		switch cfg.d2CharacterClass {
			case 1: 
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img2/d2ClassIconWarlock_on.png",ui.d2ClassSelectBg.opt("background" cfg.themePanel3Color))
					: (ui.d2ClassIcon.value := "./img2/d2ClassIconWarlock_off.png",ui.d2ClassSelectBg.opt("background" cfg.themeFont3Color))
			case 2:
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img2/d2ClassIconHunter_on.png",ui.d2ClassSelectBg.opt("background" cfg.themePanel3Color))
					: (ui.d2ClassIcon.value := "./img2/d2ClassIconHunter_off.png",ui.d2ClassSelectBg.opt("background" cfg.themeFont3Color))
			case 3:
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img2/d2ClassIconTitan_on.png",ui.d2ClassSelectBg.opt("background" cfg.themePanel3Color))
					: (ui.d2ClassIcon.value := "./img2/d2ClassIconTitan_off.png",ui.d2ClassSelectBg.opt("background" cfg.themeFont3Color))
			default:
		}
	}

	switch cfg.d2CharacterClass { 
		case 1:
		case 2:
		hotif(d2ReadyToSwordFly)
			hotkey("~*" cfg.d2AppSwordFlyKey,d2SwordFly)
		hotif()
		case 3:
		hotif(d2ReadyToSwordFly)
			hotkey("~*" cfg.d2AppSwordFlyKey,d2MorgethWarlock)
		hotif()
		default:
	}
	
	d2ClassIconUpChanged()

	ui.d2AppPauseKey.ToolTip 				:= "Click to Assign"
	ui.d2AppHoldToCrouchKey.ToolTip 		:= "Click to Assign"
	ui.d2AppHoldToCrouchKeyData.ToolTip 	:= "Click to Assign"
	ui.d2AppHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"
	ui.d2AppLoadoutKey.ToolTip				:= "Click to Assign"
	ui.d2AppLoadoutKeyData.ToolTip  		:= "Click to Assign"
	ui.d2AppLoadoutKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2AppToggleSprintKey.ToolTip			:= "Click to Assign"
	ui.d2AppToggleSprintKeyData.ToolTip  	:= "Click to Assign"
	ui.d2AppToggleSprintKeyLabel.ToolTip	:= "Click to Assign"
	ui.d2AppHoldToCrouchKey.ToolTip			:= "Click to Assign"
	ui.d2AppHoldToCrouchKeyData.ToolTip  	:= "Click to Assign"
	ui.d2AppHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"
	ui.d2AppReloadKey.ToolTip				:= "Click to Assign"
	ui.d2AppReloadKeyData.ToolTip  			:= "Click to Assign"
	ui.d2AppReloadKeyLabel.ToolTip			:= "Click to Assign"

	ui.d2AppLoadoutKeyData.setFont("s11")
	ui.d2AppPauseKeyData.setFont("s11")
	ui.d2AppPauseKeyLabel.setFont("s9")
	ui.d2AppReloadKeyData.setFont("s11")
	ui.d2AppReloadKeyLabel.setFont("s9")
	ui.d2AppHoldToCrouchKeyData.setFont("s11")
	ui.d2AppToggleSprintKeyData.setFont("s11")
	ui.d2AppHoldToCrouchKeyLabel.setFont("s9")
	ui.d2AppLoadoutKeyLabel.setFont("s9")
	ui.d2AppToggleSprintKeyLabel.setFont("s9")
	ui.d2AppSwordFlyKeyData.setFont("s11")
	ui.d2AppSwordFlyKeyLabel.setFont("s9")

	ui.d2AppPauseKey.onEvent("click",d2AppPauseKeyClicked)
	ui.d2AppHoldToCrouchKey.onEvent("click",d2AppHoldToCrouchKeyClicked)
	ui.d2AppHoldToCrouchKeyData.onEvent("click",d2AppHoldToCrouchKeyClicked)
	ui.d2AppSwordFlyKey.onEvent("click",d2AppSwordFlyKeyClicked)
	ui.d2AppSwordFlyKeyData.onEvent("click",d2AppSwordFlyKeyClicked)
	ui.d2AppReloadKey.onEvent("click",d2AppReloadKeyClicked)
	ui.d2AppReloadKeyData.onEvent("click",d2AppReloadKeyClicked)
	ui.d2AppReloadKey.onEvent("click",d2AppReloadKeyClicked)
	
	ui.currKey := cfg.d2GameToggleSprintKey
	ui.currKeyLabel := "Toggle Sprint"
	
	ui.d2GameToggleSprintKey				:= ui.gameSettingsGui.AddPicture("x25 y17 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameToggleSprintKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameToggleSprintKey),1,8))
	ui.d2GameToggleSprintKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Toggle Sprint")
	
	ui.currKey := cfg.d2GameHoldToCrouchKey
	ui.currKeyLabel := "Hold Crouch"
	ui.d2GameHoldToCrouchKey					:= ui.gameSettingsGui.AddPicture("x+2 ys w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameHoldToCrouchKey),1,8))
	ui.d2GameHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Hold Crouch")

	ui.currKey := cfg.d2GameReloadKey
	ui.currKeyLabel := "Reload"
	ui.d2GameReloadKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameReloadKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameReloadKey),1,8))
	ui.d2GameReloadKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Reload")		
	
	ui.currKey := cfg.d2GameGrenadeKey
	ui.currKeyLabel := "Reload"
	ui.d2GameGrenadeKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameGrenadeKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameGrenadeKey),1,8))
	ui.d2GameGrenadeKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Grenade")		
	
	ui.currKey := cfg.d2GameSuperKey
	ui.currKeyLabel := "Super"
	ui.d2GameSuperKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameSuperKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameSuperKey),1,8))
	ui.d2GameSuperKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Super")		
	
	;cfg.d2AutoGameConfigEnabled := true
	ui.d2ToggleAutoGameConfig := ui.gameSettingsGui.addPicture("x463 y10 w20 h35 section "
	((cfg.d2AutoGameConfigEnabled) 
		? ("Background" cfg.ThemeButtonOnColor) 
			: ("Background" cfg.themeButtonReadyColor)),
	((cfg.d2AutoGameConfigEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAutoGameConfig.toolTip := "Enable to attempt to automatically`nImport your game settings."
	ui.d2ToggleAutoGameConfigOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h30 background" cfg.themeDark2Color)
	ui.d2ToggleAutoGameConfigLabel := ui.gameSettingsGui.addText("xs-1 y+0 w28 h10 backgroundTrans","Auto")
	ui.d2ToggleAutoGameConfigLabel.setFont("s8")
	ui.d2gameToggleSprintKey.onEvent("click",d2gameToggleSprintKeyClicked)
	ui.d2gameToggleSprintKeyData.onEvent("click",d2gameToggleSprintKeyClicked)
	ui.d2GameReloadKey.onEvent("click",d2GameReloadKeyClicked)
	ui.d2GameReloadKeyData.onEvent("click",d2GameReloadKeyClicked)
	ui.d2GameSuperKey.onEvent("click",d2GameSuperKeyClicked)
	ui.d2GameSuperKeyData.onEvent("click",d2GameSuperKeyClicked)
	ui.d2GameGrenadeKey.onEvent("click",d2GameGrenadeKeyClicked)
	ui.d2GameGrenadeKeyData.onEvent("click",d2GameGrenadeKeyClicked)
	ui.d2GameHoldToCrouchKey.onEvent("click",d2GameHoldToCrouchKeyClicked)
	ui.d2GameHoldToCrouchKeyData.onEvent("click",d2GameHoldToCrouchKeyClicked)

	ui.d2gameToggleSprintKey.ToolTip		:= "Click to Assign"
	ui.d2gameToggleSprintKeyData.ToolTip  	:= "Click to Assign"
	ui.d2gameToggleSprintKeyLabel.ToolTip	:= "Click to Assign"
	ui.d2GameReloadKey.ToolTip				:= "Click to Assign"
	ui.d2GameReloadKeyData.ToolTip  		:= "Click to Assign"
	ui.d2GameReloadKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2GameSuperKey.ToolTip				:= "Click to Assign"
	ui.d2GameSuperKeyData.ToolTip  		:= "Click to Assign"
	ui.d2GameSuperKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2GameGrenadeKey.ToolTip				:= "Click to Assign"
	ui.d2GameGrenadeKeyData.ToolTip  		:= "Click to Assign"
	ui.d2GameGrenadeKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2GameHoldToCrouchKey.ToolTip		:= "Click to Assign"
	ui.d2GameHoldToCrouchKeyData.ToolTip  	:= "Click to Assign"
	ui.d2GameHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"

	ui.d2gameToggleSprintKeyLabel.setFont("s9")
	ui.d2gameToggleSprintKeyData.setFont("s11")
	ui.d2GameReloadKeyData.setFont("s11")
	ui.d2GameReloadKeylabel.setFont("s9")
	ui.d2GameSuperKeyData.setFont("s11")
	ui.d2GameSuperKeylabel.setFont("s9")
	ui.d2GameGrenadeKeyData.setFont("s11")
	ui.d2GameGrenadeKeylabel.setFont("s9")
	ui.d2GameHoldToCrouchKeyData.setFont("s11")
	ui.d2GameHoldToCrouchKeyLabel.setFont("s9")

	labelX := 280
	labelY := 44
	labelW := 66
	labelH := 23
	backColor := cfg.themePanel4Color
	fontColor := cfg.themeFont4Color
	outlineColor := cfg.themeDark1Color
	labelText := "Keybinds"
	
	ui.d2keybindAppTab2 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " h" labelH-1 " background" backColor " center c" fontColor) 
	ui.d2keybindAppTab3 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " h" labelH " backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindAppTab3.setFont("s10","thin")

	labelX := 344
	labelY := 44
	labelW := 96
	labelH := 23
	backColor := cfg.themePanel2Color
	fontColor := cfg.themeFont1Color
	outlineColor := cfg.themeBright2Color
	labelText := "Game Settings"
	ui.d2keybindGameTab2 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " h" labelH " background" backColor " center c" fontColor) 
	ui.d2keybindGameTab3 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindGameTab3.setFont("s10","bold")

	ui.d2keybindAppTab1.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab2.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab3.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindGameTab1.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab2.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab3.onEvent("click",d2keybindGameTabClicked)
	ui.d2AppFunctionsEnabled := true
	ui.d2ToggleAppFunctions := ui.gameSettingsGui.addPicture("x13 y10 w20 h35 section "
	((ui.d2AppFunctionsEnabled) 
		? ("Background" cfg.ThemeButtonOnColor) 
			: ("Background" cfg.themeButtonReadyColor)),
	((ui.d2AppFunctionsEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAppFunctionsOutline := ui.gameSettingsGui.addText("ys+2 x+0 w1 h32 background" cfg.themeDark2Color)
	ui.d2ToggleAppFunctionsLabel := ui.gameSettingsGui.addText("xs-4 y+-1 w28 h10 backgroundTrans center","Pause")
	ui.d2ToggleAppFunctionsLabel.setFont("s8")
}


d2AutoGameConfigOverride(*) {
	if (cfg.d2AutoGameConfigEnabled) {
		ui.d2ConfigFile := a_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
		curr_value := "none"
		loop read ui.d2ConfigFile {
			try {
				curr_key := strSplit(a_loopReadline,'"')[2]
				curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
			}
			switch curr_key {
				case "grenade":
					try	{

						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
									break
							}
						}
						
						if curr_value == "none"
							return
						else {
							;msgBox(curr_value)
							cfg.d2GameGrenadeKey := curr_value
							ui.d2GameGrenadeKeyData.text := strUpper(curr_value)
							ui.d2GameGrenadeKeyData.redraw()
						}
					}
			
				case "super":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameSuperKey := curr_value
							ui.d2GameSuperKeyData.text := strUpper(curr_value)
							ui.d2GameSuperKeyData.redraw()
						}
					}
				case "hold_crouch":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameHoldToCrouchKey := curr_value
							ui.d2GameHoldToCrouchKeyData.text := strUpper(curr_value)
							ui.d2GameHoldToCrouchKeyData.redraw()
						}
					}
				case "reload":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameReloadKey := curr_value
							ui.d2GameReloadKeyData.text := strUpper(curr_value)
							ui.d2GameReloadKeyData.redraw()
						}
					}
				case "toggle_sprint":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameToggleSprintKey := curr_value
							ui.d2GameToggleSprintKeyData.text := strUpper(curr_value)
							ui.d2GameToggleSprintKeyData.redraw()
						}
					}
				}
			}
	}
}

d2keybindAppTabClicked(*) {
guiName := ui.gameSettingsGui
ui.d2KeyBindHelpMsg.text := "         Assign keys you'd like to use for each function"
		labelX := 280
		labelY := 44
		labelW := 66
		labelH := 23
		ui.d2keybindGameTab1.opt("background" cfg.themeDark2Color)
		ui.d2keybindGameTab2.opt("background" cfg.themePanel4Color) 
		ui.d2keybindGameTab3.setFont("s10 c" cfg.themeFont4Color,"thin")
		ui.d2keybindGameTab1.move(348,labelY+10,92,13)
		ui.d2keybindGameTab2.move(348,labelY+9,90,13)
		ui.d2keybindGameTab3.move(346,labelY+8,,14)

		ui.d2keybindAppTab1.opt("background" cfg.themeBright1Color)
		ui.d2keybindAppTab2.opt("background" cfg.themePanel2Color)
		ui.d2keybindAppTab3.setFont("s10 c" cfg.themeFont1Color,"bold")
		ui.d2keybindAppTab1.move(labelx+0,labelY+6,70,17)
		ui.d2keybindAppTab2.move(labelx+1,labelY+6,66,16)
		ui.d2keybindAppTab3.move(282,labelY+8,,14)
		d2changeKeybindPanelTab(2)
	}


d2keybindGameTabClicked(*) {
guiName := ui.gameSettingsGui
		
		ui.d2KeybindHelpMsg.text := "Configure these to mirror your in-game bindings"
		labelX := 346
		labelY := 44
		labelW := 96
		labelH := 23
		ui.d2keybindAppTab1.opt("background" cfg.themeDark2Color)
		ui.d2keybindAppTab2.opt("background" cfg.themePanel4Color) 
		ui.d2keybindAppTab3.setFont("s10 c" cfg.themeFont4Color,"thin")
		ui.d2keybindAppTab1.move(280,labelY+10,70,13)
		ui.d2keybindAppTab2.move(281,labelY+9,65,13)
		ui.d2keybindAppTab3.move(280,labelY+8,,14)

		ui.d2keybindGameTab1.opt("background" cfg.themeBright1Color)
		ui.d2keybindGameTab2.opt("background" cfg.themePanel2Color)
		ui.d2keybindGameTab3.setFont("s10 c" cfg.themeFont1Color,"bold")
		ui.d2keybindGameTab1.move(labelx+0,labelY+6,92,17)
		ui.d2keybindGameTab2.move(labelx+1,labelY+6,90,16)
		ui.d2keybindGameTab2.redraw()
	
		ui.d2keybindGameTab3.move(,labelY+8,,14)
	d2changeKeybindPanelTab(1)
}


d2changeKeybindPanelTab(panelNum := 2) {
		ui.d2Panel1Objects := [
			ui.d2AppToggleSprintKey
			,ui.d2AppToggleSprintKeyData
			,ui.d2AppToggleSprintKeyLabel
			,ui.d2AppHoldToCrouchKey
			,ui.d2AppHoldToCrouchKeyData 
			,ui.d2AppHoldToCrouchKeyLabel
			,ui.keybindSpacer
			,ui.keybindSpacer2
			,ui.d2AppLoadoutKey
			,ui.d2AppLoadoutKeyData
			,ui.d2AppLoadoutKeyLabel
			,ui.d2AppSwordFlyKey
			,ui.d2AppSwordFlyKeyData
			,ui.d2AppSwordFlyKeyLabel
			,ui.d2AppReloadKey
			,ui.d2AppReloadKeyData
			,ui.d2AppReloadKeyLabel
			,ui.d2ClassSelectBgLine
			,ui.d2ClassSelectBg
			;,ui.d2ClassSelectBg2
			,ui.d2ClassIcon
			,ui.d2ClassIconUp
			,ui.d2ClassIconDown
			,ui.d2ClassSelectSpacer
			,ui.d2ClassIconSpacer
			,ui.d2ClassIconSpacer2
			,ui.keybindSpacer3
			,ui.keybindSpacer4
			,ui.d2AppPauseKey
			,ui.d2AppPauseKeyData
			,ui.d2AppPauseKeyLabel
			,ui.d2ToggleAppFunctions
			,ui.d2ClassSelectOutline
			,ui.d2ClassSelectOutline2
			,ui.d2ToggleAppFunctionsLabel
			,ui.d2ToggleAppFunctionsOutline
			,ui.d2Panel1Tab1Bg
			,ui.d2Panel1Tab1Bg2
			,ui.d2Panel1Tab1Bg3
			,ui.d2Panel1Tab1Bg4
			]

	ui.d2Panel2Objects := [
			ui.d2GameToggleSprintKey
			,ui.d2GameToggleSprintKeyData
			,ui.d2GameToggleSprintKeyLabel
			,ui.d2GameHoldToCrouchKey
			,ui.d2GameHoldToCrouchKeyData 
			,ui.d2GameHoldToCrouchKeyLabel
			,ui.d2GameReloadKey
			,ui.d2GameReloadKeyData
			,ui.d2GameReloadKeyLabel
			,ui.d2GameGrenadeKey
			,ui.d2GameGrenadeKeyData
			,ui.d2GameGrenadeKeyLabel
			,ui.d2GameSuperKey
			,ui.d2GameSuperKeyData
			,ui.d2GameSuperKeyLabel
			,ui.d2ToggleAutoGameConfig
			,ui.d2ToggleAutoGameConfigLabel
			,ui.d2ToggleAutoGameConfigOutline
			,ui.d2Panel1Tab2Bg
			,ui.d2Panel1Tab2Bg2
			,ui.d2Panel1Tab2Bg3
			,ui.d2Panel1Tab2Bg4
			]

	if panelNum == 1 {
		ui.d2ToggleAppFunctions.opt("-hidden")
		this_panelObjects := ui.d2Panel1Objects
		other_panelObjects := ui.d2Panel2Objects
	} else {
		ui.d2ToggleAppFunctions.opt("hidden")
		this_panelObjects := ui.d2Panel2Objects
		other_panelObjects := ui.d2Panel1Objects
		try {
			ui.labelName1.opt("x215 y46 w100 h17 background" cfg.themePanel4Color)
			ui.labelName3.opt("x320 y46 w80 h19 background" cfg.themePanel2Color)
		}
	}
	
	for panelObj in this_panelObjects {
		panelObj.opt("hidden")
	}
	
	for panelObj in other_panelObjects {
		panelObj.opt("-hidden")
	}
}

d2drawTopPanel(*) {
	ui.d2TopPanelBg := ui.gameSettingsGui.addText("x7 y4 w481 h66 background" cfg.themePanel1Color,"")
	drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,3,484,69,cfg.themeBright2Color,cfg.themeBright1Color,1)
}

d2DrawUi(*) { 
	ui.gameTabs.useTab("Destiny2") 
	ui.d2Sliding := false
	ui.d2HoldingRun := false         
	ui.d2cleanupNeeded := false
	ui.gameSettingsGui.setFont("s10")
	d2drawTopPanel()
	d2drawPanel1()
	d2drawPanel3()
	if d2ActivePanel == 1 
		d2ChangeKeybindPanelTab(1)
	else
		d2ChangeKeybindPanelTab(2)	
}

d2drawPanel3(*) {
	ui.gameSettingsGui.addText("x7 y78 w481 h69 background" cfg.themePanel1Color,"")
	ui.gameSettingsGui.addText("x12 y81 w470 h58 c" cfg.themePanel1Color " background" cfg.themePanel2Color)
	drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,13,82,470,57,cfg.themeDark1Color,cfg.themeBright2Color,1)
	drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,76,484,68,cfg.themeBright1Color,cfg.themeBright1Color,1)
	ui.gameSettingsGui.addText("hidden x19 y21 section")
	ui.d2LaunchDIMbutton				:= ui.gameSettingsGui.addPicture("x25 y+49 section w50 h50 backgroundTrans","./Img2/d2_button_DIM.png")
	ui.d2LaunchLightGGbutton			:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_LightGG.png")
	ui.d2LaunchBlueberriesButton 		:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_bbgg.png")
	ui.d2LaunchD2CheckListButton 		:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_d2CheckList.png")
	ui.d2LaunchDestinyTrackerButton 	:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_DestinyTracker.png")
	ui.d2Launchd2FoundryButton 			:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 backgroundTrans","./Img2/d2_button_d2Foundry.png")
	ui.d2LaunchBrayTechButton 			:= ui.gameSettingsGui.addPicture("x+15 ys w50  h50 vBrayTechButton backgroundTrans","./Img2/d2_button_braytech.png")
}

d2KeybindTabChange(this_button,*) {
}
	
drawKeybind(x,y,bindName,labelText := bindName,gui := ui.mainGui,w := 84,h := 30,buttonImage := "./img/keyboard_key_up.png",textJustify := "center",fontColorReady := cfg.themeButtonAlertColor,fontColorOn := cfg.themeButtonOnColor) {
	global
	%bindName%Key := gui.addPicture("x" x " y" y " w" w " h" h " section backgroundTrans",buttonImage)
	%bindName%KeyData := gui.addText("xs-3 y+-24 w" w " h" h-9 " textJustify c" fontColorOn " backgroundTrans",subStr(strUpper(cfg.d2%bindName%Key),1,8))
	%bindName%KeyLabel := gui.addText("xs-1 y+-34 w" w " h" h-10 " textJustify c" fontColorReady " backgroundTrans",labelText)
}
		
	d2ClassIconUpChanged(*) {
		switch cfg.d2CharacterClass {
			case 1:
				cfg.d2CharacterClass := 2
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img2/d2ClassIconHunter_on.png"
					: ui.d2ClassIcon.value := "./img2/d2ClassIconHunter_off.png"
			case 2:
				cfg.d2CharacterClass := 3
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.d2AppSwordFlyKey,d2SwordFly)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img2/d2ClassIconTitan_on.png"
					: ui.d2ClassIcon.value := "./img2/d2ClassIconTitan_off.png"
			case 3: 
				cfg.d2CharacterClass := 1
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.d2AppSwordFlyKey,d2MorgethWarlock)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img2/d2ClassIconWarlock_on.png"
					: ui.d2ClassIcon.value := "./img2/d2ClassIconWarlock_off.png"
			default:                                          
		}
	}
	
	d2ClassIconDownChanged(*) {
		switch cfg.d2CharacterClass {
			case 3:
				cfg.d2CharacterClass := 2
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img2/d2ClassIconHunter_on.png"
					: ui.d2ClassIcon.value := "./img2/d2ClassIconHunter_off.png"
			case 1:
				cfg.d2CharacterClass := 3
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.d2AppSwordFlyKey,d2SwordFly)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img2/d2ClassIconTitan_on.png"
					: ui.d2ClassIcon.value := "./img2/d2ClassIconTitan_off.png"
			case 2: 
				cfg.d2CharacterClass := 1
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.d2AppSwordFlyKey,d2MorgethWarlock)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img2/d2ClassIconWarlock_on.png"
					: ui.d2ClassIcon.value := "./img2/d2ClassIconWarlock_off.png"
			default:                                          
		}
	}		
	
setTimer(incursionNotice,15000)

toggleIncursionNotice(*) {
	cfg.pushNotificationsEnabled := !cfg.pushNotificationsEnabled
	if cfg.pushNotificationsEnabled == false {
		ui.incursionOptOut.value := "./img2/checkbox_true.png"
		ui.togglePushNotifications.value := cfg.toggleOff
		ui.togglePushNotifications.opt("background" cfg.themeButtonReadyColor)
	} else {
		ui.incursionOptOut.value := "./img2/checkbox_false.png"
		ui.togglePushNotifications.value := cfg.toggleOn
		ui.togglePushNotifications.opt("background" cfg.themeButtonOnColor)
	}
}

closeIncursionNotice(*) {
	ui.d2FlashingIncursionNotice := false
	ui.d2ShowingIncursionNotice := false
	setTimer(d2FlashIncursionNoticeA,0)
	setTimer(d2FlashIncursionNoticeB,0)

	ui.incursionGui.hide()
	ui.incursionGui.destroy()
}

incursionNotice(*) {
	(cfg.pushNotificationsEnabled)
		? bail()
		: 0
	cfg.lastIncursion := iniRead(cfg.file,"Game","LastIncursion","000000000000")	
	ui.latestIncursion := cfg.lastIncursion
	
	try {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET","http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
		whr.Send()
		whr.WaitForResponse()
		ui.latestIncursion := whr.ResponseText
	}
	
	if ((ui.latestIncursion != cfg.lastIncursion) && cfg.pushNotificationsEnabled) || (ui.incursionDebug == true) {
		if ui.d2ShowingIncursionNotice == true
			closeIncursionNotice()

		ui.incursionGui := gui()
		ui.incursionNoticeHwnd := ui.incursionGui.hwnd
		ui.incursionGui.opt("-caption -border toolWindow alwaysOnTop owner" ui.mainGui.hwnd)
		ui.incursionGui.backColor := "010203"
		ui.incursionGuiBg := ui.incursionGui.addText("x3 y3 w344 h44 background" cfg.themeFont3Color)
		ui.incursionGuiBg2 := ui.incursionGui.addText("x5 y5 w340 h40 background" cfg.themePanel3Color)
		drawOutlineNamed("notice",ui.incursionGui,1,1,348,48,cfg.themeDark2Color,cfg.themeBright2Color,2)			
		drawPanelLabel(ui.incursionGui,224,0,100,20,"Destiny2 Event",cfg.themeFont3Color,cfg.themeBright2Color,cfg.themePanel3Color)
		ui.incursionNotice := ui.incursionGui.addText("x10 y5 w339 h70 backgroundTrans c" cfg.themeFont3Color,"Vex Incursion!")
		ui.incursionGui.setFont("s9 c" cfg.themeFont3Color,"Cascadia Code")
		ui.incursionTime := ui.incursionGui.addText("x15 y27 w260 h16 backgroundTrans"," Timestamp:" formatTime("T12"," MM/dd hh:mm:ss "))
		ui.incursionClose := ui.incursionGui.addPicture("x330 y0 w20 h20 background" cfg.themeButtonAlertColor,"./img/button_quit.png")
		drawOutlineNamed("incursionClose",ui.incursionGui,329,-2,21,22,cfg.themeBright2Color,cfg.themeBright2Color,1)
		ui.incursionGui.setFont("s12","Arial")
		ui.incursionOptOut := ui.incursionGui.addPicture("x224 y27 w13 h13 section backgroundTrans c" cfg.themeFont3Color,)
				
		if cfg.pushNotificationsEnabled	== true {
			ui.incursionOptOut.value := "./img2/checkbox_false.png"
		} else {
			ui.incursionOptOut.value := "./img2/checkbox_true.png"
		}
				
		ui.incursionOptOutLabel := ui.incursionGui.addText("x+6 ys-1 w359 backgroundTrans c" cfg.themeFont3Color,"Dont Show Again")
		ui.incursionOptOutLabel.setFont("s9","Arial")
		ui.incursionClose.onEvent("click", closeIncursionNotice)
		ui.incursionOptOut.onEvent("click",toggleIncursionNotice)
		ui.incursionNotice.setFont("s19 c" cfg.themeFont3Color,"Courier")

		try {
			cfg.dockbarMonitor := iniRead(cfg.file,"Interface","DockbarMonitor",monitorGetPrimary())
			if monitorGetCount() < cfg.dockbarMonitor {
				cfg.dockbarMonitor := 1
			}
		}
		
		try {
			if cfg.topDockEnabled {
				monitorGet(cfg.dockbarMonitor,&dockbarMonitorL,&dockbarMonitorT,&dockbarMonitorR,&dockbarMonitorB,)
				incursionGuix := ((dockbarMonitorL + dockbarMonitorR)/2)-175
				dockbarPosY := dockbarMonitorT
				if cfg.animationsEnabled {
					ui.incursionGui.show("x" incursionGuix " y" dockbarPosY+31 " w350 h0 noActivate")
					posH := 0
					while posH < 60 {
						posH += 10
						ui.incursionGui.move(incursionGuix,dockbarPosY+31,,posH)
						sleep(1)
					}
				}
				ui.incursionGui.show("x" incursionGuix " y" dockbarPosY+31 " w352 h51 noActivate")
				ui.d2ShowingIncursionNotice := true
			} else {
				transLevel := 0
				if cfg.animationsEnabled {
					guiVis(ui.incursionGui,false)
					ui.incursionGui.show("y150 w350 h51 noActivate")
					while transLevel < 255 {
						transLevel += 5
						winSetTransparent(transLevel,ui.incursionGui)
						sleep(1)
					}
				}		
				ui.incursionGui.show("y150 w352 h51 noActivate")
				ui.d2ShowingIncursionNotice := true
			}
			winSetTransColor("010203",ui.incursionGui)
			soundPlay("./redist/incursionAudio.mp3")
			ui.d2FlashIncursionNoticeActive := true
			setTimer(d2FlashIncursionNoticeA,2000)
			sleep(1000)
			setTimer(d2FlashIncursionNoticeB,2000)
			cfg.lastIncursion := ui.latestIncursion
			iniWrite(cfg.lastIncursion,cfg.file,"Game","LastIncursion")
		}
	}
}

d2FlashIncursionNoticeA(*) {
	ui.incursionGuiBg.opt("background" cfg.themeProgressColor)
	ui.incursionGuiBg.redraw()
	}

d2FlashIncursionNoticeB(*) {
	ui.incursionGuiBg.opt("background" cfg.themeFont3Color)
	ui.incursionGuiBg.redraw()
}

GuiGameTab() {
	global	
	loop cfg.gameModuleList.length {
		if fileExist("./lib/lib" cfg.gameModuleList[A_Index])
			runWait("./lib/lib" cfg.gameModuleList[A_Index])
	}
	try
		ui.gameSettingsGui.destroy()
		
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
	drawGameTabs(cfg.activeGameTab)
	d2drawUi()
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
	drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,227,29
		,cfg.themeBright1Color,cfg.themeBright1Color,1)
	
	winSetTransColor(ui.transparentColor,ui.gameTabGui)
			drawOutlineNamed("gameTabs",ui.gameTabGui,ui.gameTabWidth-0,0,498-ui.gameTabWidth,32,cfg.themeBright1Color,cfg.themeDark1Color,1)
	ui.gameTabGui.addText("x1 y0 w0 h27 section background" cfg.themeBright1Color,"")
	((tabNum == 1)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x+0 y+-1 w110 h26 background" cfg.themeBright1Color,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x+0 y+-1 w110 h26 background" cfg.themeDark2Color,""))
	ui.gameTab1Skin := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "ys+0 h28" 
			: "ys+1 h27")
				" x+-110 w110 section center background" 
		((tabNum == 1) 
			? cfg.themeBackgroundColor 
			: cfg.themePanel4Color) 
		" c" ((tabNum == 1) 
			? cfg.themeFont1Color 
			: cfg.themeFont4Color)
		,"")
	ui.gameTab1Skin.setFont((tabNum == 1 
		? "s14" 
		: "s12"),"Impact")
	ui.gameTab1Label := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "ys+0 h25" 
			: "ys+1 h24")
				" x+-110 w110 section center backgroundTrans c" 
		((tabNum == 1) 
			? cfg.themeFont1Color 
			: cfg.themeFont4Color)
				,"Destiny 2")
	ui.gameTab1Label.setFont((tabNum == 1 
		? "s14" 
		: "s12")
			,"Impact")
	ui.gameTabWidth += 113
	((tabNum == 1)
		? ui.gameTabGui.addText("ys x+-2 w2 h29 section background" cfg.themeBright1Color,"")
		: ui.gameTabGui.addText("ys-1 x+-2 w2 h29 section background" cfg.themeBright1Color,""))
	((tabNum == 2)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x+0 y+-1 w115 h28 background" cfg.themeBright1Color,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x+0 y+-1 w115 h28 background" cfg.themeDark2Color,""))
	ui.gameTab2Skin := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "ys-1 h28" 
			: "ys+2 h26")
				" x+-115 w115 section center background" 
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
			? "ys+0 h24" 
			: "ys+0 h26")
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
		? ui.gameTabGui.addText("ys-1 x+-1 w2 h30 section background" cfg.themeDark2Color,"")
		: ui.gameTabGui.addText("ys+1 x+-1 w2 h30 section background" cfg.themeBright1Color,""))
	guiVis(ui.gameTabGui,false)
	if (winGetTransparent(ui.gameTabGui)) == 0 {
		ui.gameTabGui.addText("ys+1 x+0 w" 498-(ui.gameTabWidth+3) " h26 background" cfg.themePanel1Color)

		winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
		ui.gameTabGui.show("w495 h30 x" mainGuiX+33 " y" mainGuiY+184 " noActivate")
	} else {
		winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
		ui.gameTabGui.show("w228 h30 x" mainGuiX+35 " y" mainGuiY+185 " noActivate") 
	}
}
			
cfg.d2LoadoutCoords1920x1080 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords1920x1080"
,"145:3e	80,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790,145:910,240:910"),",")
	
cfg.d2LoadoutCoords1920x1200 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords1920x1200"
,"145:380,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790,145:890,240:890"),",")
	
cfg.d2LoadoutCoords2560x1440 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords2560x1440"
,"190:460,320:460,190:590,320:590,190:720,320:720,190:850,320:850,190:980,320:980,190:1100,320:1100"),",")	

cfg.d2LoadoutCoords3440x1440 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords3440x1440"
,"636:460,760:460,636:590,760:590,636:720,760:720,636:850,760:850,636:980,760:980,636:1100,760:1100"),",")	
				
cfg.d2LoadoutCoordsCustom := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoordsCustom"
,"145:380,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790,145:910,240:910"),",")

ui.d2IsReloading := false
ui.d2IsSprinting := false
ui.d2PhAfkActive := false

toggleD2PhAfk(*) {
	(ui.d2PhAfkActive := !ui.d2PhAfkActive)
		? startD2PhAfk()
		: stopD2PhAfk()
}

startD2PhAfk(*) {
	ui.d2PhAfkActive := true
	debugLog("Starting: Pale Heart AFK")
	setTimer(timerD2PhAfk,60000)
	timerD2PhAfk()
}

stopD2PhAfk(*) {
	ui.d2PhAfkActive := false
		debugLog("Stopping: Pale Heart AFK")
		setTimer(timerD2PhAfk,0)
	}
loopTimerD2PhAfk(*) {
	setTimer(timerD2PhAfk,60000)
}

timerD2PhAfk(*) {
	if !ui.d2PhAfkActive
		return
	winActivate("ahk_exe destiny2.exe")
	if !ui.d2PhAfkActive
		return	sleep(500)
	debugLog("Pale Heart AFK: Open Menu")
	send("{3}")
	if !ui.d2PhAfkActive
		return	
	sleep(1000)
	debugLog('Pale Heart AFK: Selecting "The Landing"')
	if !ui.d2PhAfkActive
		return	
	mouseMove(-(a_screenwidth/2)+200,0,50,"R")
	if !ui.d2PhAfkActive
		return	
	sleep(2000)
	mouseMove((a_screenwidth/2)-355,((a_screenHeight-40)/2)-7,50,)
	if !ui.d2PhAfkActive
		return	
	sleep(500)
	send("{LButton Down}")
	if !ui.d2PhAfkActive
		return	
	sleep(1800)
	send("{LButton Up}")
	debugLog("Pale Heart AFK: Waiting to Spawn")
	loop 8 {
		if !ui.d2PhAfkActive
			return
		sleep(1000)
	}
	debugLog("Pale Heart AFK: Walking Forward")
	send("{w down}")
	loop 9 {
		if !ui.d2PhAfkActive
			return	
		sleep(1000)
	}
	sleep(500)
	send("{w up}")
	sleep(250)
	debugLog("Pale Heart AFK: Turning Left")
	dllCall("mouse_event","UInt","0x01","Int",-1600,"Int",0,"UInt",0,"UInt",0)
	if !ui.d2PhAfkActive
		return	
	sleep(250)
	debugLog("Pale Heart AFK: Walking Forward")
	send("{w down}")
	loop 6 {
		if !ui.d2PhAfkActive
			return	
		sleep(1000)
	}
	send("{w up}")
	debugLog("Pale Heart AFK: Turning Around")
	dllCall("mouse_event","UInt","0x01","Int",-3600,"Int",0,"UInt",0,"UInt",0)	
	debugLog("Pale Heart AFK: Waiting for Chest to Spawn")
	loop 30 {
		if !ui.d2PhAfkActive
			return	
		sleep(1000)
	}
	debugLog("Pale Heart AFK: Walking Forward")
	send("{w down}")
	loop 6 {
		if !ui.d2PhAfkActive
			return	
		sleep(1000)
	}
	sleep(500)
	debugLog("Pale Heart AFK: Strafing Right")
	send("{d down}")
	if !ui.d2PhAfkActive
		return	
	sleep(1600)
	send("{d up}")
	debugLog("Pale Heart AFK: Walking Forward")
	loop 6 {
		if !ui.d2PhAfkActive
			return	
		sleep(1000)
	}
	sleep(100)
	send("{w up}")
	dllCall("mouse_event","UInt","0x01","Int",-1600,"Int",0,"UInt",0,"UInt",0)
	debugLog("Pale Heart AFK: Collecting Chest")
	send("{e down}")
	if !ui.d2PhAfkActive
		return	
	sleep(1800)
	send("{e up}")
	if !ui.d2PhAfkActive
		return	
	sleep(1500)
	debugLog("Pale Heart AFK: Waiting to Restart")
}
; timerD2PhAfk(*) {
		; ui.d2PhAfkActive := true
		;toolTip("Starting Pale Heart AFK")
		; Loop {
			; Loop 40 {
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{3}")
				; sleep(2000)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break				
				; mouseMove(a_screenwidth/2,(a_screenheight-40)/2,0)
				; sleep(1500)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; dllCall("mouse_event","UInt","0x01","Int",-600,"Int",0,"UInt",0,"UInt",0)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(1225)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; dllCall("mouse_event","UInt","0x01","Int",175,"Int",0,"UInt",0,"UInt",0)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(500)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{LButton down}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(1200)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{LButton up}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(10000)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{shift down}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{w down}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(8000)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{shift up}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{w up}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; dllCall("mouse_event","UInt","0x01","Int",1360,"Int",0,"UInt",0,"UInt",0)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; loop 30 {
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(1000)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break		
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{shift down}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send ("{w down}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; loop 6 {
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(1000)
					; if !ui.d2PhAfkActive
						; break
				; }
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(400)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; dllCall("mouse_event","UInt","0x01","Int",-330,"Int",0,"UInt",0,"UInt",0)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; loop 3 {
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
					; sleep(1000)
					; if !ui.d2PhAfkActive
						; break
				; }
				; sleep(200)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{shift up}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{w up}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; dllCall("mouse_event","UInt","0x01","Int",-91000,"Int",0,"UInt",0,"UInt",0)
				; if !ui.d2PhAfkActive
					; break
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(500)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{e down}")
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; sleep(1200)
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
				; send("{e up}")	
				; sleep(500)
				; if !ui.d2PhAfkActive
					; break
			; }
			; if !ui.d2PhAfkActive
				; break
				; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
					; break
			; send("{Tab}")
			; sleep(1000)
			; if !ui.d2PhAfkActive
				; break
			; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
			; send("{o down}")
			; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
			; loop 40 {
				; sleep(1000)
				; if !ui.d2PhAfkActive
					; break
			; }	
			; send("{o up}")
			; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
			; loop 10 {
				; sleep(1000)
				; if !ui.d2PhAfkActive
					; break
			; }
			; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
			; send("{3}")
			; sleep(1000)
			; if !ui.d2PhAfkActive
				; break
			; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
			; mouseMove(a_screenwidth/1.2,(a_screenheight-40)/1.15,0)
			; sleep(500)
			; if !ui.d2PhAfkActive
				; break
			; if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500)
				; send("{LButton}")
			; loop 30 {
				; sleep(1000)
				; if !ui.d2PhAfkActive
					; break
			; }
		; }
	; }
; }
	
	; stopD2PhAfk(*) {
		; ui.d2PhAfkActive := false
	;toolTip("Stopping Pale Heart AFK")
		; send("{w up}")
		; send("{shift up}")
		; send("{LButton up}")
		; reload()




hotIfWinActive("ahk_exe destiny2.exe")
	hotKey(cfg.d2AppToggleSprintKey,d2ToggleAlwaysSprint)
	hotKey(cfg.d2AppPauseKey,d2ToggleAppFunctions)
	hotkey("Ins",toggleGlyphWindow)
	hotkey("Del",toggleCodeWindow)
	hotkey("Home",startD2PhAfk)
	hotkey("End",stopD2PhAfk)

hotkey("PgDn",toggleJoinShuroChi)
hotIf()


toggleJoinShuroChi(*) {
	static joinShuroChiActive := false
	(joinShuroChiActive := !joinShuroChiActive)
		? (trayTip("Starting JoinShuroChi"),setTimer(macroJoinShuroChi,3500))
		: (trayTip("Stopping JoinShuroChi"),setTimer(macroJoinShuroChi,0))
}

macroJoinShuroChi(*) {
	if winActive("ahk_exe destiny2.exe") {
		send("{Enter}")
		sleep(500)
		sendText("/join checkpointbot#0422")
		send("{Enter}")
		sleep(1500)
		send("{Enter}")
		sleep(1000)
	}
}
hotIf(d2RemapCrouchEnabled)
	hotkey("~*$" cfg.d2AppHoldToCrouchKey,d2HoldToCrouch)
hotIf()

hotIf(d2ReadyToReload)
	hotKey("~*" cfg.d2AppReloadKey,d2reload)
hotIf()

hotIf(d2ReadyToSprint)
	hotKey("~*w",d2StartSprinting)
hotIf()

hotIf()

togglePrismatic(*) {
	send("{F1}")
	sleep(550)
	mouseGetPos(&mouseX,&mouseY)
	click(1300,315,0)
	sleep(250)
	send("{LButton}")
	click(mouseX,mouseY,0)
	sleep(300)
	send("{F1}")
}

d2AppPause(*) {
	(cfg.d2AppPaused := !cfg.d2AppPaused)
	
}
	
d2RemapCrouchEnabled(*) {
	return ((winActive("ahk_exe destiny2.exe") && !cfg.d2AppPaused)
		? cfg.d2AlwaysRunEnabled
			? 1
			: 0
		: 0)
}	

d2SwordFly(*) {
	while getKeyState(cfg.d2AppSwordFlyKey) {
		send("{LButton Down}")
		sleep(100)
		send("{LButton Up}")
		sleep(800)
		send("{space down}")
		sleep(80)
		send("{space up}")
		sleep(80)
		send("{space down}")
		sleep(80)
		send("{space up}")
		sleep(700)
	}
}

d2MorgethWarlock(*) {
	while getKeyState(cfg.d2AppSwordFlyKey) && getKeyState("w") {
		send("{" cfg.d2GameGrenadeKey " down}")
		sleep(1700)
		send("{" cfg.d2GameGrenadeKey " up}")
		send("{" strLower(cfg.d2GameToggleSprintKey) "}")
		sleep(800)
		send("{space down}{space up}")
		sleep(80)
		send("{space down}{space up}")
		sleep(11000)
		send("{" cfg.d2GameSuperKey " down}")
		sleep(300)
		send("{" cfg.d2GameSuperKey " up}")
		sleep(300)
		send("{" cfg.d2GameSuperKey " down}")
		sleep(300)
		send("{" cfg.d2GameSuperKey " up}")
		sleep(7000)
		loop 110 {
			sleep(100)
			send("{space}")
			sleep(200)
			send("{space}")
		}
	}
}

d2reload(*) {
	startReload()
	stopReload()
	
	startReload() {
		ui.d2GameReloadKeyData.opt("c" cfg.themeButtonOnColor)
		ui.d2GameReloadKeyData.redraw()
		ui.d2AppReloadKeyData.opt("c" cfg.themeButtonOnColor)
		ui.d2AppReloadKeyData.redraw()
		ui.d2IsReloading := true
		d2ToggleAppFunctionsOff()
	}
	
	stopReload() {
		; ui.d2IsReloading := false
		; d2ToggleAppFunctionsOn()
		; ui.d2AppReloadKeyData.opt("c" cfg.themeButtonAlertcolor)
		; ui.d2GameReloadKeyData.opt("c" cfg.themeButtonAlertColor)
		; ui.d2GameReloadKeyData.redraw()
		setTimer () => (ui.d2IsReloading := false
			,d2ToggleAppFunctionsOn()
			,ui.d2AppReloadKeyData.opt("c" cfg.themeButtonAlertcolor)
			,ui.d2GameReloadKeyData.opt("c" cfg.themeButtonAlertColor)
			,ui.d2GameReloadKeyData.redraw()),-2600
	}
}	

d2HoldToCrouch(*) {
	ui.d2AppHoldToCrouchKeyData.opt("c" cfg.themeButtonOnColor)
	if (cfg.topDockEnabled) {
		ui.dockBarD2HoldToCrouch.opt("background" cfg.themeButtonAlertColor)
		ui.dockBarD2HoldToCrouch.redraw()
	}
	send("{" cfg.d2gameHoldToCrouchKey " down}")
	keywait(cfg.d2AppHoldToCrouchKey)
	ui.d2AppHoldToCrouchKeyData.opt("c" cfg.themeButtonAlertColor)
	if (cfg.topDockEnabled) {
		ui.dockBarD2HoldToCrouch.opt("background" cfg.themeButtonOnColor)
		ui.dockBarD2HoldToCrouch.redraw()
	}
	send("{" cfg.d2gameHoldToCrouchKey " Up}")
}

d2FireButtonClicked(*) {
	send("{LButton Down}")
	keyWait("LButton")

	send("{LButton Up}")
	if ui.d2IsSprinting
		send("{" cfg.d2GameToggleSprintKey "}")
}
d2ReadyToSwordFly(*) {
	if winActive("ahk_exe destiny2.exe") && !cfg.d2AppPaused && ui.d2FlyEnabled
		return 1
	else
		return 0
}

d2ReadyToReload(*) {
	if winActive("ahk_exe destiny2.exe") && !ui.d2IsReloading && !cfg.d2AppPaused
		return 1
	else
		return 0	
}

d2ReadyToSprint(*) {
	if (winActive("ahk_exe destiny2.exe") && cfg.d2AlwaysRunEnabled && !getKeyState("RButton") && !getKeyState("LButton") && !getKeyState(cfg.d2AppHoldToCrouchKey) && !cfg.d2AppPaused)
		return 1
	else
		return 0
}
	
d2startSprinting(*) {
	;msgBox('.')
	ui.d2IsSprinting := true
	;send("{w down}")
	if (cfg.d2AlwaysRunEnabled) {
		send("{" strLower(cfg.d2GameToggleSprintKey) "}")
	}
	setCapsLockState("Off")
	keyWait("w","L")
	send("{w up}")
}

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
	loop cfg.d2LoadoutCoords.length {
		d2LoadOutCoordsStr .= cfg.d2LoadoutCoords[a_index] ","
	}	

	hotIf(d2AppEnabled)
	hotkey("Joy12",d2controllerLoadoutChange)
	hotkey(cfg.d2AppLoadoutKey,d2LoadoutModifier)
	loop cfg.d2LoadoutCoords.length {
		if a_index == 10 {
				hotkey(cfg.d2AppLoadoutKey " & 0",d2LoadoutModifier)
		} else {
					hotKey(cfg.d2AppLoadoutKey " & " substr(a_index,-1),d2LoadoutModifier)
				}
			}
	hotIf()
}

d2AppEnabled(*) {
	if !cfg.d2AppPaused && winActive("ahk_exe destiny2.exe")
		return 1
	else
		return 0
}

d2CreateLoadoutKeys()

d2controllerLoadoutChange(*) {
	osdLog("Controller Loadout Hotkey Pressed")
	joyx := "center"
	joyy := "center"
	while getKeyState("joy12") {
		if getKeyState("JoyX") < 20 
			joyx := "left" 
		if getKeyState("JoyX") > 80
			joyx := "right"
		if getKeyState("JoyX") == 50
			joyx := "center"
		if getKeyState("JoyY") < 35 
			joyy := "up"
		if getKeyState("JoyY") > 75
			joyy := "down"
		if getKeyState("JoyY") == 50
			joyy := "center"
	}
	osdLog("L3 + " joyx " and " joyy " pressed")
	switch {
		case joyy == "up" && joyx == "center":d2LoadoutModifier("prismatic",true)
		case joyx == "right" && joyy == "center":d2LoadoutModifier("`3",true)
		case joyy == "down" && joyx == "center":d2LoadoutModifier("`2",true) 
		case joyx == "left" && joyy == "center":d2LoadoutModifier("`1",true)
		default:return
	}
}

d2LoadoutModifier(hotKeyName,isController := false) {
	d2LoadoutCoordsStr := ""
	if (hotKeyName == "prismatic") {
		cfg.d2AppLoadoutMultiplier := 1.5
		sleep(550*cfg.d2AppLoadoutMultiplier)
		keyWait("joy12")
		send("{F1}")
		togglePrismatic()
		return
	} 
	
	if (hotkeyName == "``" ) {
		if (A_PriorHotkey == "``") And (A_TimeSincePriorHotkey < 200) {
			togglePrismatic()
		}
		return
	}
	
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
		
	if isController {
		cfg.d2AppLoadoutMultiplier := 1.5
		sleep(550*cfg.d2AppLoadoutMultiplier)
		keyWait("joy12")
	}
	;msgBox('here')
	send("{F1}")
	sleep(550*cfg.d2AppLoadoutMultiplier)
	send("{Left}")
	sleep(150*cfg.d2AppLoadoutMultiplier)
	coordMode("mouse","client")
	if isController {
		click(loadoutX+30,loadoutY+30,0)
		click(loadoutX,loadoutY,0)
	} else
		click(loadoutX,loadoutY,0)
	sleep(250*cfg.d2AppLoadoutMultiplier)
	send("{LButton}")
	sleep(100*cfg.d2AppLoadoutMultiplier)
	send("{F1}")
	try {
		ui.dockBarLoadouts.opt("background" cfg.themeButtonOnColor)
		ui.dockBarLoadouts.redraw()
	}
}
	
d2ToggleAlwaysSprint(*) {
	(cfg.d2AlwaysRunEnabled := !cfg.d2AlwaysRunEnabled)
		? (ui.d2AppToggleSprintKeyData.opt("c" cfg.themeButtonOnColor)
			,ui.d2AppToggleSprintKeyData.redraw()
			,ui.d2GameToggleSprintKeyData.opt("c" cfg.themeButtonOnColor)
			,ui.d2GameToggleSprintKeyData.redraw()
			,SetCapsLockState("Off"))
		: (ui.d2IsSprinting := false
			,SetCapsLockState("Off")
			,ui.d2AppToggleSprintKeyData.opt("c" cfg.themeButtonAlertColor)
			,ui.d2AppToggleSprintKeyData.redraw()
			,ui.d2GameToggleSprintKeyData.opt("c" cfg.themebuttonAlertColor)
			,ui.d2GameToggleSprintKeyData.redraw()
			,((ui.d2IsSprinting)
				? send("{" cfg.d2AppToggleSprintKey "}")
				: 0))
}

d2ToggleAppFunctions(*) {
	(cfg.d2AppPaused := !cfg.d2AppPaused)
		? d2ToggleAppFunctionsOff()
		: d2ToggleAppFunctionsOn()
}

d2ToggleAppFunctionsOn() {
	ui.d2ToggleAppFunctions.Opt("Background" cfg.ThemeButtonOnColor)
	ui.d2ToggleAppFunctions.value := "./img/toggle_vertical_trans_on.png"
	try {				
		ui.dockBarD2AlwaysRun.Opt("Background" cfg.ThemeButtonOnColor)
		ui.dockBarD2AlwaysRun.value := "./img/toggle_vertical_trans_on.png"
	}
}

d2ToggleAppFunctionsOff() {
	ui.d2AppFunctionsEnabled := false
	ui.d2ToggleAppFunctions.opt("background" cfg.ThemeButtonReadyColor)
	ui.d2ToggleAppFunctions.value := "./img/toggle_vertical_trans_off.png"
	ui.d2ToggleAppFunctions.redraw()
	try {
		ui.dockBarD2AlwaysRun.opt("background" cfg.ThemeButtonAlertColor)
		ui.dockBarRunIcon.opt("background" cfg.themeButtonOnColor)
		ui.dockBarRunIcon.redraw()
		ui.dockBarD2AlwaysRun.value := "./img/toggle_vertical_trans_off.png"
	}
}

d2ToggleAutoGameConfigOn() {
	;ui.d2Log.text := " start: SPRINT`n rcvd: " strUpper(subStr(cfg.d2AppToggleSprintKey,1,8)) "`n" ui.d2Log.text
	ui.d2ToggleAutoGameConfig.Opt("Background" cfg.ThemeButtonOnColor)
	ui.d2ToggleAutoGameConfig.value := "./img/toggle_vertical_trans_on.png"
}

d2ToggleAutoGameConfigOff() {
	ui.d2AutoGameConfigEnabled := false
	ui.d2ToggleAutoGameConfig.opt("background" cfg.ThemeButtonReadyColor)
	ui.d2ToggleAutoGameConfig.value := "./img/toggle_vertical_trans_off.png"
	ui.d2ToggleAutoGameConfig.redraw()
}
	
ui.d2Log								:= ui.gameSettingsGui.addText("x405 y10 w68 h80 hidden background" cfg.themePanel3color " c" cfg.themeFont3color," Destiny 2`n Log Started`n Waiting for Input")
ui.d2Log.setFont("s7","ariel")

ui.d2ToggleAppFunctions.ToolTip 		:= "Toggles holdToCrouch"
ui.d2LaunchDIMbutton.ToolTip			:= "Launch DIM in Browser"
ui.d2LaunchLightGGbutton.toolTip 		:= "Launch Light.gg in Browser"
ui.d2LaunchBlueberriesButton.toolTip	:= "Launch Blueberries.gg in Browser"
ui.d2Launchd2CheckListButton.toolTip	:= "Launch D2Checklist.com in Browser"
ui.d2LaunchDestinyTrackerButton.toolTip	:= "Launch DestinyTracker.com in Browser"
ui.d2LaunchBrayTechButton.toolTip		:= "Launch Bray.Tech in Browser"
ui.d2Launchd2FoundryButton.toolTip		:= "Launch d2Foundry"

ui.d2ToggleAppFunctions.OnEvent("Click", d2ToggleAppFunctions)
ui.d2ToggleAutoGameConfig.OnEvent("Click", d2ToggleAutoGameConfig)

d2ToggleAutoGameConfig(*) {
	(cfg.d2AutoGameConfigEnabled := !cfg.d2AutoGameConfigEnabled)
		? d2ToggleAutoGameConfigOn()
		: d2ToggleAutoGameConfigOff()
	}
	
ui.d2AppLoadoutKey.onEvent("click",d2AppLoadoutKeyClicked)
ui.d2AppLoadoutKeyData.onEvent("click",d2AppLoadoutKeyClicked)
ui.d2AppToggleSprintKey.onEvent("click",d2AppToggleSprintKeyClicked)
ui.d2AppToggleSprintKeyData.onEvent("click",d2AppToggleSprintKeyClicked)
ui.d2LaunchDIMbutton.onEvent("click",d2launchDIMbuttonClicked)
ui.d2LaunchLightGGbutton.onEvent("click",d2launchLightGGbuttonClicked)
ui.d2LaunchD2checkListButton.onEvent("click",d2launchD2checklistButtonClicked)
ui.d2LaunchBlueberriesButton.onEvent("click",d2launchBlueBerriesButtonClicked)
ui.d2LaunchDestinyTrackerButton.onEvent("click",d2LaunchDestinyTrackerButtonClicked)
ui.d2Launchd2FoundryButton.onEvent("click",toggleGlyphWindow)
ui.d2LaunchBrayTechButton.onEvent("click",d2LaunchBrayTechButtonClicked)


d2RedrawUI(*) {
	reload()
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
		if winActive("ahk_exe destiny2.exe")
	; run("chrome.exe https://www.d2foundry.gg")
		 toggleGlyphWindow()
}	

d2LaunchBrayTechButtonClicked(lparam,wparam*) {
			toggleCodeWindow(lparam)
}

toggleCodeWindow(lparam,wparam*) {
	static codeWindowVisible := false
		(codeWindowVisible := !codeWindowVisible)
			? showCodeWindow()
			: hideCodeWindow()
}
	
showCodeWindow(*) {
	ui.d2LaunchBrayTechButton.value := "./Img2/d2_button_brayTech_down.png"
	d2wwCodesGuiHwnd := false
	try 
		d2wwCodesGuiHwnd := ui.d2wwCodesGui.hwnd
	
	if !d2wwCodesGuiHwnd {
		ui.d2wwCodesGui := gui()
		ui.d2wwCodesGui.opt("alwaysOnTop -caption toolWindow owner" ui.mainGui.hwnd)
		ui.d2wwCodesGui.backColor := "080203"
		winSetTransColor("080203",ui.d2wwCodesGui)
		ui.d2wwCodeImg := ui.d2wwCodesGui.addPicture("x20 y20 w800 h600","./img2/d2CodeMorgeth.png")
		ui.d2CodeExit := ui.d2wwCodesGui.addPicture("x805 y5 w30 h30 background" cfg.themeBright2Color,"./img2/button_quit.png")
		ui.d2CodeExit.onEvent("click",hideCodeWindow)
		ui.d2wwCodeImg.onEvent("click",WM_LBUTTONDOWN_callback)
	}
	ui.d2wwCodesGui.show("x200 y200 w840 h640 noactivate")
}																																																																																																																																																																																																																				

hideCodeWindow(*) {
	ui.d2LaunchBrayTechButton.value := "./Img2/d2_button_brayTech.png"
	ui.d2wwCodesGui.hide()
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
	ui.mouseBindingTarget.onEvent("click",keybindMouseButtonClicked)
	ui.mouseBindingTarget.onEvent("doubleClick",keybindMouseButtonClicked)
	ui.notifyGui.AddText("xs hidden")
	
	keybindMouseButtonClicked(obj,msg*) {
		msgBox(obj.id "`n" msg[1])
	}
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	drawOutlineNotifyGui(1,1,w,h,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2)
	drawOutlineNotifyGui(2,2,w-4,h-4,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)
	
	Transparency := 0
	;ui.mainGui.hide()
	guiVis(ui.mainGui,false)
	;guiVis(ui.titleBarButtonGui,false)
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
	;guiVis(ui.titleBarButtonGui,true)
	guiVis(ui.gameSettingsGui,true)
	guiVis(ui.gameTabGui,true)
}

d2GameHoldToCrouchKeyClicked(*) {
	tmpCrouchKey := ""
	keyBindDialogBox('HoldToCrouch',"Center")
	Sleep(100)
	global d2GameHoldToCrouchKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
	d2GameHoldToCrouchKeyInput.start()
	d2GameHoldToCrouchKeyInput.wait()
	if (d2GameHoldToCrouchKeyInput.endKey == "" && d2GameHoldToCrouchKeyInput.input =="") {
		keyBindDialogBoxClose()
		notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
	} else {
		if (d2GameHoldToCrouchKeyInput.input)
		{
			tmpCrouchKey := d2GameHoldToCrouchKeyInput.input
		} else {
			tmpCrouchKey := d2GameHoldToCrouchKeyInput.endKey
		}
	}
	keyBindDialogBoxClose()
	cfg.d2GameHoldToCrouchKey := tmpCrouchKey
	ui.d2GameHoldToCrouchKeyData.text := subStr(strUpper(cfg.d2GameHoldToCrouchKey),1,8)
	d2CreateLoadoutKeys()
	d2RedrawUI()
}

	d2AppHoldToCrouchKeyClicked(*) {
		tmpCrouchKey := ""
		keyBindDialogBox('HoldToCrouch',"Center")
		Sleep(100)
		global d2AppHoldToCrouchKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
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
		cfg.d2AppHoldToCrouchKey := tmpCrouchKey
		ui.d2AppHoldToCrouchKeyData.text := subStr(strUpper(cfg.d2AppHoldToCrouchKey),1,8)
		ui.d2AppHoldToCrouchKey.opt("w" ui.d2KeybindWidth + max(0,(strLen(ui.d2AppHoldToCrouchKeyData.text)-6))*10)
		ui.d2AppHoldToCrouchKeyData.opt("w" ui.d2KeybindWidth + max(0,(strLen(ui.d2AppHoldToCrouchKeyData.text)-6))*10)
		ui.d2AppHoldToCrouchKeyLabel.opt("w" ui.d2KeybindWidth + max(0,(strLen(ui.d2AppHoldToCrouchKeyData.text)-6))*10)
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}
	
	d2AppSwordFlyKeyClicked(*) {
		tmpCrouchKey := ""
		keyBindDialogBox('Fly Macro',"Center")
		Sleep(100)
		global d2AppSwordFlyKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		d2AppSwordFlyKeyInput.start()
		d2AppSwordFlyKeyInput.wait()
		if (d2AppSwordFlyKeyInput.endKey == "" && d2AppSwordFlyKeyInput.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2AppSwordFlyKeyInput.input)
			{
				tmpd2AppSwordFlyKey := d2AppSwordFlyKeyInput.input
			} else {
				tmpd2AppSwordFlyKey := d2AppSwordFlyKeyInput.endKey
			}
		}
		keyBindDialogBoxClose()
		cfg.d2AppSwordFlyKey := tmpd2AppSwordFlyKey
		ui.d2AppSwordFlyKeyData.text := subStr(strUpper(cfg.d2AppSwordFlyKey),1,8)
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}	
	
	d2AppReloadKeyClicked(*) {
		tmpd2AppReloadKey := ""
		keyBindDialogBox('HoldToCrouch',"Center")
		Sleep(100)
		global d2AppReloadKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		d2AppReloadKeyInput.start()
		d2AppReloadKeyInput.wait()
		if (d2AppReloadKeyInput.endKey == "" && d2AppReloadKeyInput.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2AppReloadKeyInput.input)
			{
				tmpd2AppReloadKey := d2AppReloadKeyInput.input
			} else {
				tmpd2AppReloadKey := d2AppReloadKeyInput.endKey
			}
		}
		keyBindDialogBoxClose()
		cfg.d2AppReloadKey := tmpd2AppReloadKey
		ui.d2AppReloadKeyData.text := subStr(strUpper(cfg.d2AppReloadKey),1,8)
		d2CreateLoadoutKeys()
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
		d2CreateLoadoutKeys()
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
		d2CreateLoadoutKeys()
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
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

	d2AppPauseKeyClicked(*) {
		DialogBox('Assign key for: `n"Reload"',"Center")
		Sleep(100)
		d2AppPauseKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2AppPauseKeyInput.start()
		d2AppPauseKeyInput.wait()
		if (d2AppPauseKeyInput.endKey == "" && d2AppPauseKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2AppPauseKeyInput.input)
			{
				cfg.d2AppPauseKey := d2AppPauseKeyInput.input
			} else {
				cfg.d2AppPauseKey := d2AppPauseKeyInput.endKey
			}
			ui.d2AppPauseKeyData.text := subStr(strUpper(cfg.d2AppPauseKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}	
	
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
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}
	
	d2GameGrenadeKeyClicked(*) {
		DialogBox('Assign key for: `n"Grenade"',"Center")
		Sleep(100)
		d2GameGrenadeKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameGrenadeKeyInput.start()
		d2GameGrenadeKeyInput.wait()
		if (d2GameGrenadeKeyInput.endKey == "" && d2GameGrenadeKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameGrenadeKeyInput.input)
			{
				cfg.d2GameGrenadeKey := d2GameGrenadeKeyInput.input
			} else {
				cfg.d2GameGrenadeKey := d2GameGrenadeKeyInput.endKey
			}
			ui.d2GameGrenadeKeyData.text := subStr(strUpper(cfg.d2GameGrenadeKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}
	
	d2GameSuperKeyClicked(*) {
		DialogBox('Assign key for: `n"Super"',"Center")
		Sleep(100)
		d2GameSuperKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameSuperKeyInput.start()
		d2GameSuperKeyInput.wait()
		if (d2GameSuperKeyInput.endKey == "" && d2GameSuperKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameSuperKeyInput.input)
			{
				cfg.d2GameSuperKey := d2GameSuperKeyInput.input
			} else {
				cfg.d2GameSuperKey := d2GameSuperKeyInput.endKey
			}
			ui.d2GameSuperKeyData.text := subStr(strUpper(cfg.d2GameSuperKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

	; ui.gameTabs.useTab("World//Zero")
	; ui.gameSettingsGui.addText("x10 y7 w475 h65 background" cfg.themePanel1Color,"")
	; drawOutlineNamed("w0AutoTowerOutline",ui.gameSettingsGui,10,6,475,67,cfg.themeBright2Color,cfg.themeDark2Color,1)
	; drawOutlineNamed("w0AutoTowerHorizLine",ui.gameSettingsGui,20,6,70,1,cfg.themeBackgroundColor,cfg.themeBackgroundColor,2)
	; drawOutlineNamed("w0AutoTowerVertLine",ui.gameSettingsGui,20,6,70,7,cfg.themeBackgroundColor,cfg.themeBright2Color,1)
	; ui.gameSettingsGui.addText("x21 y-2 w68 h14 c" cfg.themeFont1Color " background" cfg.themeBackgroundColor," Auto Tower")
	; drawOutlineNamed("w0AutoAfkTabs",ui.gameSettingsGui,20,6,1,7,cfg.themeDark1Color,cfg.themeBright2Color,1)
	; ui.gameSettingsGui.setFont("s10")
	; ui.toggleCelestialTower := ui.gameSettingsGui.AddPicture("x20 y20 w60 h25 section vCelestialTower " (cfg.CelestialTowerEnabled ? ("Background" cfg.ThemeButtonAlertColor) : ("Background" cfg.ThemeButtonAlertColor)),((cfg.CelestialTowerEnabled) ? "./img/towerToggle_celestial.png" : "./img/towerToggle_infinite.png"))
	; ui.toggleCelestialTower.OnEvent("Click", towerToggleChanged)
	; ui.toggleCelestialTower.ToolTip := "Toggles between Infinite and Celestial Towers."
	; ui.towerIntervalSlider := ui.gameSettingsGui.addSlider("x+0 ys-4 w160 h30 tickInterval5 altSubmit vTowerCycleLength thick18 center section Range1-50  background" 
	; cfg.themePanel1Color " ToolTip",cfg.towerInterval)
	; ui.towerIntervalSlider.onEvent("change",towerCycleChange)
	; towerCycleChange(*) {
		; ui.cycleLengthData.value := ui.towerIntervalSlider.value
		; controlFocus(ui.gameTabs)
	; }
	; ui.cycleLengthData := ui.gameSettingsGui.AddText("x+0 ys+3 w35 h30 section center background" cfg.themeBackgroundColor,ui.towerIntervalSlider.value)
	; ui.cycleLengthData.setFont("s18")
	; ui.labelCelestialTower:= ui.gameSettingsGui.AddText("xs-220 y+-1 w60 section backgroundTrans","Tower Type")
	; ui.labelTowerTiming := ui.gameSettingsGui.AddText("ys w160 center section backgroundTrans","Cycle Length")	
	; drawOutlineNamed("towerCycleLength",ui.gameSettingsGui,239,19,36,31,cfg.themeDark2Color,cfg.themeBright2Color,1)
	; ui.towerIntervalSlider.OnEvent("Change",towerIntervalChanged)
	; ui.towerIntervalSlider.ToolTip := "Tower Restart Interval"
	; ToggleCelestialTower(*)
	; {
		; ui.toggleCelestialTower.Opt((cfg.CelestialTowerEnabled := !cfg.CelestialTowerEnabled) ? ("Background" cfg.ThemeButtonOnColor) : ("Background" cfg.ThemeButtonReadyColor))
		; ui.toggleCelestialTower.Redraw()
	; }
		; towerIntervalChanged(*) {
		; cfg.towerInterval := ui.towerIntervalSlider.Value
	; }

if (cfg.d2AlwaysRunEnabled) {
				d2ToggleAppFunctionsOn()
}

drawInfographic("vod")
drawInfographic(infographicName,imageWidth := 150,imageHeight := 150, numColumns := 5) {
	imageTypes := "png,jpg,gif,bmp"
	infographicFolder := "./img2/infogfx"
	transparentColor := "030405"

	if (cfg.topDockEnabled) {
		infoGuiMon := cfg.dockbarMon
	} else { 
		winGetPos(&infoGuiX,&infoGuiY,,,ui.mainGui)
		infoGuiMon := 1
		loop monitorGetCount() {
			monitorGet(a_index,&monLeft,,&monRight,)
			if infoGuiX > monLeft && infoGuiX < monRight {
				infoGuiMon := a_index
				break
			}
		}
	}

	monitorGet(infoGuiMon,&infoGuiMonL,&infoGuiMonT,&infoGuiMonR,&infoGuiMonB)
	
	ui.infoGuiBg := gui()
	ui.infoGuiBg.opt("toolWindow alwaysOnTop -caption")
	ui.infoGuiBg.backColor := "454545"
	winSetTransparent(120,ui.infoGuiBg.hwnd)
	ui.infoGui := gui()
	ui.infoGui.opt("toolWindow -caption AlwaysOnTop owner" ui.gameSettingsGui.hwnd)
	ui.infoGui.backColor := transparentColor
	ui.infoGui.color := transparentColor
	;ui.infoGuiBg := ui.infoGui.addText("x0 y0 w800 h600 background" transparentColor,"")
	;ui.infoGui.addText("x0 y0 x1 y1 section background" transparentColor,"")
	winSetTransColor(transparentColor,ui.infoGui.hwnd)

	

	
;	loop files, sort(infographicFolder "/" infographicName "/*.png") {
;		ui.%infographicName%%ui.infoGui.hwnd% := ui.infoGui.addPicture("x0 y30 section w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" a_loopFilename )

;	}
	rowNum := 0
	columnNum := 1
	fileList := array()
	
	loop files, infographicFolder "/" infographicName "/*.png" {
		fileList.push(a_loopFilename)
	}

	
	for file in fileList {
		if columnNum == 1 {
			ui.%infographicName%%a_index% := ui.infoGui.addPicture("x0 y" 30+(rowNum*imageHeight) " w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" file)
			ui.%infographicName%%a_index%.onEvent("click",d2ClickedGlyph)
			ui.%infographicName%%a_index%.onEvent("doubleclick",d2DoubleClickedGlyph)
			rowNum +=1
		} else {	
			ui.%infographicName%%a_index% := ui.infoGui.addPicture("x" (columnNum*imageWidth)-imageWidth " y" 30+(rowNum*imageHeight)-imageHeight " w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" file)
			ui.%infographicName%%a_index%.onEvent("click",d2ClickedGlyph)
			ui.%infographicName%%a_index%.onEvent("doubleclick",d2DoubleClickedGlyph)
		}
		columnNum += 1
		if columnNum > numColumns
			columnNum := 1
	}
	;msgBox(fileListText)
	ui.%infographicName%QuitButton := ui.infoGui.addPicture("x770 y0 w30 h30 backgroundTrans","./img2/button_quit.png")
	ui.%infographicName%QuitButton.onEvent("click",closeInfographic)
		
	infoGuiWidth := numColumns*imageWidth
	infoGuiHeight := (rowNum*imageHeight)+30
	ui.infoGuiDragZone := ui.infoGuiBg.addText("x0 y0 w" infoGuiWidth " y" infoGuiHeight " background" transparentColor,"")
	winSetTransparent(0,ui.infoGuiBg.hwnd)
	winSetTransparent(0,ui.infoGui.hwnd)
	ui.infoGuiBg.show("x" ((infoGuiMonL+infoGuiMonR)/2)-(infoGuiWidth/2) " y" ((infoGuiMonT+infoGuiMonB)/2)-(infoGuiHeight/2) " w" infoGuiWidth " h" infoGuiHeight " noActivate")
	ui.infoGui.show("x" ((infoGuiMonL+infoGuiMonR)/2)-(infoGuiWidth/2) " y" ((infoGuiMonT+infoGuiMonB)/2)-(infoGuiHeight/2) " w" infoGuiWidth " h" infoGuiHeight " noActivate")
	ui.infoGui.opt("owner" ui.infoGuiBg.hwnd)

}
closeInfographic(*) {
	try 
		ui.infoGui.hide()
	try
		ui.infoGuiBg.hide()
	try
		ui.infoGui.destroy()
	try	
		ui.infoGuiBg.destroy()
}

toggleGlyphWindow(*) {
	static glyphWindowVisible := false
	(glyphWindowVisible := !glyphWindowVisible)
		? showGlyphWindow()		
		: hideGlyphWindow()
}

showGlyphWindow(*) {
	ui.infoGuiBg.show("noActivate") 
	ui.infoGui.show("noActivate")
	ui.d2Launchd2FoundryButton.value := "./Img2/d2_button_d2Foundry_down.png"
	winSetTransparent(255,ui.infoGuiBg.hwnd)
	winSetTransparent(255,ui.infoGui.hwnd)
}

hideGlyphWindow(*) {
	ui.infoGui.hide(), ui.infoGuiBg.hide(),ui.d2Launchd2FoundryButton.value := "./Img2/d2_button_d2Foundry.png"
}


d2DoubleClickedGlyph(lparam,wparam*) {
	winActivate("ahk_exe destiny2.exe")
	d2ClickedGlyph(lparam,wparam)
	winActivate("ahk_exe destiny2.exe")
	send("{Enter}")
	sleep(500)
	send("glyph: " A_Clipboard)
	sleep(250)
	send("{Enter}")
	Sleep(500)
	send("{t}")
	sleep(500)
;	d2Launchd2FoundryButtonClicked()
}	

d2ClickedGlyph(lparam,wparam*) {
	buttonHoldTimerStart := a_now
	WM_LBUTTONDOWN_callback(lparam,wparam)
	keyWait("LButton")
	if a_now-buttonHoldTimerStart > 400
		return
	
	A_Clipboard := (subStr(strSplit(lparam.value,"/")[5],-99,-4))
	TrayTip("Copied glyph name: " a_clipboard " to clipboard")
}


drawPanelLabel(guiName,labelX,labelY,labelW := 100,labelH := 20,labelText := "needs value",backColor := "gray",outlineColor := "white",fontColor := "white") {
		guiName.setFont("s9")
		guiName.addText("x" labelX " y" labelY " w" labelW " h" labelH " background" outlineColor,"")
		guiName.setFont("s10")
		guiName.addText("x" labelX+1 " y" labelY+1 " w" labelW-2 " h" labelH-2 " background" backColor " center c" fontColor) 
		guiName.addText("x" labelX+1 " y" labelY+1 " w" labelW-2 " h" labelH " backgroundTrans center c" fontColor, labelText) 
}
