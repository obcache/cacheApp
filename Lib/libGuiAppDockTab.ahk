#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) {
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}
	
win1 := object()
win2 := object()
win3 := object()

if !(StrCompare(A_LineFile,A_ScriptFullPath)) {
	InstallDir 		:= IniRead("./cacheApp.ini","System","InstallDir",A_MyDocuments "\cacheApp")
	MainScriptName 	:= IniRead("./cacheApp.ini","System","MainScriptName","cacheApp")
	Run(A_ScriptDir "/../" MainScriptName ".ahk")
	ExitApp
}

launchApp(processPath) {
	switch appName {
		case "discord":
			run('C:\Users\cashm\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\5) Utilities\Discord.lnk')
			launchSuccessful := false
			timeoutCount := 0
			while !launchSuccessful and timeoutCount < 60 {
				timeoutCount += 1
				sleep(1000)
				if winExist("ahk_exe discord.exe")
					launchSuccessful := true
			}
			if (launchSuccessful) {
				winActivate("ahk_exe discord.exe")
			} else {
				notifyOSD("Problems launching Discord",2000)
				Return
			}
		case "foobar2000":
			run('E:\Music\foobar2000\foobar2000.exe')
			launchSuccessful := false
			timeoutCount := 0
			while !launchSuccessful and timeoutCount < 60 {
				timeoutCount += 1
				sleep(1000)
				if winExist("ahk_exe foobar2000.exe") {
					launchSuccessful := true
				}
			}
			if (launchSuccessful) {
			winActivate("ahk_exe foobar2000.exe")

		} else {
			notifyOSD("Problems launching Foobar2000",2000)
			Return
		}
		case "obsstudio":
			run('C:\Program Files\obs-studio\bin\64bit\obs64.exe','C:\Program Files\obs-studio\bin\64bit\')
			launchSuccessful := false
			timeoutCount := 0
			while !launchSuccessful and timeoutCount < 60 {
				timeoutCount += 1
				sleep(1000)
				if winExist("ahk_exe obs64.exe") {
					launchSuccessful := true
				}	
			}
			if (launchSuccessful) {
				winActivate("ahk_exe obs64.exe")
			} else {
				notifyOSD("Problems launching OBS")
			}
	}
}

workspaceChanged(*) {
	iniWrite(ui.workspaceDDL.value,cfg.file,"AppDock","SelectedWorkspace")
	sqliteQuery(cfg.dbFilename,"SELECT * FROM winPositions WHERE workspace='" ui.workspaceDDL.text "'",&sqlResult)
	sqliteShowResult(ui.winPosLV,sqlResult)
}	

GuiDockTab(&ui) {
	ui.MainGuiTabs.UseTab("AppDock")
	ui.mainGui.setFont("s9")
	drawPanel(ui.mainGui,40,40,400,170,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,.75,85,"Window Sets","Calibri",cfg.themeFont1Color )
	drawPanel(ui.mainGui,442,40,85,170,cfg.themePanel1Color,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1,1,1.75,40,"Actions","Calibri",cfg.themeFont1Color)

	workspaceArr := array()
	ui.selectedWorkspace := iniRead(cfg.file,"AppDock","SelectedWorkspace",1)
	sqliteQuery(cfg.dbFilename,"SELECT name FROM workspaces",&sqlResult)
	
	if (sqlResult.hasRows) {
		loop sqlResult.rows.length {
			workspaceArr.push(sqlResult.rows[a_index][1])
		}
	}
	ui.workspaceDDL := ui.mainGui.addComboBox("x50 y45 w100 r6 section altSubmit choose" ui.selectedWorkspace " c" cfg.themeFont1Color " background" cfg.themePanel1Color,workspaceArr) 

	ui.workspaceDDL.onEvent("change",workspaceChanged)


	
	ui.winPosLV := ui.mainGui.addListView("xs w380 h135 section vResultsLV +LV0x00010000  c" cfg.themeFont2Color " background" cfg.themePanel2Color,["Win Title","x","y","w","h","ProcessPath"])
	ui.winPosLV.modifyCol()
	
	ui.MainGui.AddText("x428 y50 section backgroundTrans w60 Right backgroundTrans","Win1")
	ui.getWin1Pos := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 vWin1 background" cfg.themeDisabledColor,"")
	ui.getWin1Pos.OnEvent("Click",getWinPos)
	ui.getWin1Pos.Value := "./Img/button_down.png"
	cfg.Win1Coords := strSplit(iniRead(cfg.file,"AppDock","Win1Coords"),",")
	ui.getWin1Pos.toolTipData := "Current Position:`nx: " cfg.win1coords[1] ", y: " cfg.win1coords[2] ", w: " cfg.win1coords[3] ", h: " cfg.win1coords[4] "`nClick to change"
	ui.MainGui.AddText("xs+0 y+4 section backgroundTrans w60 Right backgroundTrans","Win2")
	ui.getWin2Pos := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 vWin2 background" cfg.themeDisabledColor,"")
	ui.getWin2Pos.OnEvent("Click",getWinPos)
	ui.getWin2Pos.Value := "./Img/button_down.png"
	cfg.Win2Coords := strSplit(iniRead(cfg.file,"AppDock","Win2Coords"),",")
	ui.getWin2Pos.toolTipData := "Current Position:`nx: " cfg.win2coords[1] ", y: " cfg.win2coords[2] ", w: " cfg.win2coords[3] ", h: " cfg.win2coords[4] "`nClick to change"
	ui.MainGui.AddText("xs+0 y+4 section backgroundTrans w60 Right backgroundTrans","Win3")
	ui.getWin3Pos := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 vWin3 background" cfg.themeDisabledColor,"")
	ui.getWin3Pos.OnEvent("Click",getWinPos)
	ui.getWin3Pos.Value := "./Img/button_down.png"
	cfg.Win3Coords := strSplit(iniRead(cfg.file,"AppDock","Win3Coords"),",")
	ui.getWin3Pos.toolTipData := "Current Position:`nx: " cfg.win3coords[1] ", y: " cfg.win3coords[2] ", w: " cfg.win3coords[3] ", h: " cfg.win3coords[4] "`nClick to change"
	ui.RestoreWinPosLabel := ui.mainGui.addText("xs+0 y+8 w60 right section backgroundTrans","Apply")
	ui.restoreWinPosButton := ui.mainGui.addPicture("x+5 ys+1 w30 h20 background" cfg.themeDisabledColor,"./img/button_down.png")
	ui.restoreWinPosButton.onEvent("click",applyWinPos)
	applyWinPos(*) {
		if !winExist("ahk_exe discord.exe")
			setTimer () => launchApp("discord"),-100
		if !winExist("ahk_exe foobar2000.exe")
			setTimer () => launchapp("foobar2000"),-100
		if !winExist("obs64.exe")
			setTimer () => launchApp("obsstudio"),-100
		
		winMove(cfg.win1coords[1],cfg.win1coords[2],cfg.win1coords[3],cfg.win1coords[4],"ahk_exe " cfg.win1coords[5])
		winMove(cfg.win2coords[1],cfg.win2coords[2],cfg.win2coords[3],cfg.win2coords[4],"ahk_exe " cfg.win2coords[5])
		winMove(cfg.win3coords[1],cfg.win3coords[2],cfg.win3coords[3],cfg.win3coords[4],"ahk_exe " cfg.win3coords[5])
	}
	ui.MainGui.SetFont("s9 c" cfg.ThemeFont1Color,"Calibri")
	ui.MainGui.AddText("xs+0 y+4 section backgroundTrans w60 Right backgroundTrans","Caption")
	ui.toggleCaption := ui.MainGui.AddPicture("x+5 ys+1 w30 h20","./Img/button_down.png")
	ui.toggleCaption.toolTip := "Enable/Disable the caption bar on any window."
	ui.toggleCaption.OnEvent("Click",toggleCaption)
	ui.MainGui.AddText("xs+0 y+4 section backgroundTrans w60 Right backgroundTrans","OnTop")
	ui.universalOnTop := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 background" cfg.themeDisabledColor,"")
	ui.universalOnTop.OnEvent("Click",universalOnTop)
	ui.universalOnTop.Value := "./Img/button_down.png"
	ui.universalOnTop.toolTip := "Set any window to AlwaysOnTop"
	
}

getWinPos(this_button,*) {
		DialogBox("Click a window to`nRecord its position.")
		keyWait("LButton","D")
		mouseGetPos(,,&winClicked)
		winGetPos(&remWinX,&remWinY,&remWinW,&remWinH,winClicked)
		iniWrite(%this_button.name%.x := remWinX "," %this_button.name%.y := remWinY "," %this_button.name%.w := remWinW "," %this_button.name%.h := remWinH "," winGetProcessName(winClicked),cfg.file,"AppDock",this_button.name "Coords")
		iniWrite(%this_button.name%.winGetProcessPath(winClicked),cfg.file,"AppDock",this_button_name "ProcessPath")
		DialogBoxClose()
		ui.get%this_button.name%Pos.toolTipData := "Current Position:`nx: " remWinX ", y: " remWinY ", w: " remWinW ", h: " remWinH "`nClick to change" 
}

toggleCaption(*) {
	ui.toggleCaption.value := "./img/button_down.png"
	ui.toggleCaption.opt("background" cfg.themeButtonAlertColor)
	SetTimer(releaseButton1,-400)
	releaseButton1(*) {
		ui.toggleCaption.value := "./img/button_up.png"
		ui.toggleCaption.opt("background" cfg.themeButtonReadyColor)
	}
	DialogBox("Click anywhere on the window you'd like to toggle caption on.")
	Sleep(750)
	ClickStatus := KeyWait("LButton", "D T15")
	if (ClickStatus = 0) {	
		MsgBox("A window was not selected in time.`nPlease try again.")
		DialogBoxClose()
	} else {
		WinSetStyle("^0xC00000","A")
		DialogBoxClose()
	}
}	
	
universalOnTop(*) {
	ui.universalOnTop.value := "./img/button_down.png"
	ui.universalOnTop.opt("background" cfg.themeButtonAlertColor)
	SetTimer(releaseButton,-400)
	releaseButton(*) {
		ui.universalOnTop.value := "./img/button_up.png"
		ui.universalOnTop.opt("background" cfg.themeButtonReadyColor)
	}	
	DialogBox("Click anywhere on the window you'd like to toggle AlwaysOnTop on.")
	Sleep(750)
	ClickStatus := KeyWait("LButton", "D T15")
	if (ClickStatus = 0) {	
		MsgBox("A window was not selected in time.`nPlease try again.")
		DialogBoxClose()
	} else {
		WinSetAlwaysOnTop(-1,"A")
		DialogBoxClose()
	}
}
	
drawDivider(DockY) { 
	MonitorGetWorkArea(cfg.AppDockMonitor, &Left, &Top, &Right, &Bottom)
	WorkAreaHeightWhenDocked :=  (Bottom - Top - cfg.DockHeight)
	ui.dividerGui.opt("-caption +alwaysOnTop +ToolWindow +0x4000000")
	ui.dividerGui.backColor := cfg.themeBright1Color
	ui.dividerGui.show("x" Left " y" DockY-8 " w" Right-Left " h12 NoActivate")
	winSetTransparent(255,ui.dividerGui)
}