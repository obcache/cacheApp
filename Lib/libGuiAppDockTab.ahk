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

; launchApp(processPath) {
	; switch appName {
		; case "discord":
			; run('C:\Users\cashm\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\5) Utilities\Discord.lnk')
			; launchSuccessful := false
			; timeoutCount := 0
			; while !launchSuccessful and timeoutCount < 60 {
				; timeoutCount += 1
				; sleep(1000)
				; if winExist("ahk_exe discord.exe")
					; launchSuccessful := true
			; }
			; if (launchSuccessful) {
				; winActivate("ahk_exe discord.exe")
			; } else {
				; notifyOSD("Problems launching Discord",2000)
				; Return
			; }
		; case "foobar2000":
			; run('E:\Music\foobar2000\foobar2000.exe')
			; launchSuccessful := false
			; timeoutCount := 0
			; while !launchSuccessful and timeoutCount < 60 {
				; timeoutCount += 1
				; sleep(1000)
				; if winExist("ahk_exe foobar2000.exe") {
					; launchSuccessful := true
				; }fffffffffffffffffdddddddddddg
			; }
			; if (launchSuccessful) {
			; winActivate("ahk_exe foobar2000.exe")
		; } else {
			; notifyOSD("Problems launching Foobar2000",2000)
			; Return
		; }
		; case "obsstudio":
			; run('C:\Program Files\obs-studio\bin\64bit\obs64.exe','C:\Program Files\obs-studio\bin\64bit\')
			; launchSuccessful := false
			; timeoutCount := 0
			; while !launchSuccessful and timeoutCount < 60 {
				; timeoutCount += 1
				; sleep(1000)
				; if winExist("ahk_exe obs64.exe") {
					; launchSuccessful := true
				; }	
			; }
			; if (launchSuccessful) {
				; winActivate("ahk_exe obs64.exe")
			; } else {
				; notifyOSD("Problems launching OBS")
			; }
	; }
; }

workspaceChanged(*) {
	lvColSizes := [70,40,40,40,40,153]
	lvColNames := [" Title","X","Y","W","H","Process Path"]

	iniWrite(ui.workspaceDDL.value,cfg.file,"AppDock","SelectedWorkspace")
	sqliteQuery(cfg.dbFilename,"SELECT Title,winX,winY,winW,winH,ProcessPath FROM winPositions WHERE workspace='" ui.workspaceDDL.text "'",&sqlResult)
	;sqliteShowResult(ui.winPosLV,sqlResult,lvColNames,lvColSizes)
	ui.winPosLV.delete()
	loop ui.winPoslv.getCount("col") 
		ui.winPoslv.deleteCol(1)
	loop lvColNames.length {
		ui.winPoslv.insertCol(a_index, "", lvColNames[a_index])
		if a_index == 1
			ui.winPoslv.modifyCol(a_index,lvColSizes[a_index]-1)
		else
			ui.winPoslv.modifyCol(a_index,lvColSizes[a_index]+1)
			
	}
	if (sqlResult.hasRows) {
		ui.mainGui.setFont("s8","Arial")
		loop sqlResult.rows.length
			ui.winPoslv.add("", sqlResult.rows[a_index]*)
		drawGridLines()
	}
}	

GuiDockTab(&ui) {
	selectedRow := ""
	ui.MainGuiTabs.UseTab("AppDock")
	ui.mainGui.setFont("s10.6 Bold")
	lvColSizes := [70,40,40,40,40,153]
	lvColNames := [" Title","X","Y","W","H","Process Path"]
	drawPanel(ui.mainGui,40,40,400,170,cfg.themePanel1Color,cfg.themeBright2Color,cfg.themeDark2Color,1,1,.75,85,"Window Sets","Calibri",cfg.themeFont1Color )
	drawPanel(ui.mainGui,442,40,85,170,cfg.themePanel1Color,cfg.themeBright2Color,cfg.themeDark2Color,1,1,1.75,40,"Actions","Calibri",cfg.themeFont1Color)

	workspaceArr := array()

	ui.selectedWorkspace := iniRead(cfg.file,"AppDock","SelectedWorkspace",1)
	sqliteQuery(cfg.dbFilename,"SELECT name FROM workspaces",&sqlResult)
	
	if (sqlResult.hasRows) {
		rowNum := a_index
		loop sqlResult.rows.length {
			workspaceArr.push(sqlResult.rows[a_index][1])
		}
	}
	
	ui.workspaceDDL := ui.mainGui.addComboBox("x45 y45 w150 r6 section altSubmit choose" ui.selectedWorkspace " c" cfg.themeFont1Color " background" cfg.themePanel1Color,workspaceArr) 
	drawOutlineNamed("AppListView",ui.mainGui,45,73,390,19,cfg.themeBright2Color,cfg.themeBorderDarkColor,2)
	drawOutlineNamed("AppListView",ui.mainGui,46,74,388,17,cfg.themeBorderLightColor,cfg.themeDark1Color,1)

	ui.workspaceDDL.onEvent("change",workspaceChanged)
	
	ui.mainGui.AddText("xs-8 y+-17 section hidden")
	ui.mainGui.setFont("s10 bold")
	for width in lvColSizes {
		ui.mainGui.AddText("x+0 ys+0 w" width " h18 center c" cfg.themeFont2Color " background" cfg.themePanel2Color, lvColNames[a_index])
		if a_index < lvColSizes.length 
			ui.mainGui.AddText("x+0 ys+0 w1 h18 background" cfg.themeBright2Color,"")
	}
	ui.mainGui.setFont("s8","Calibri Light")
	ui.winPosLV := ui.mainGui.addListView("x45 y92 w390 h114 0x3 0x2000 -Hdr c" cfg.themeFont2Color " background" cfg.themePanel2Color)
	ui.winPosLV.setFont("s9","Calibri")
	ui.winPosLV.onEvent("itemFocus",drawGridLines)
	
	drawGridLines(*) {
		ui.mainGui.setFont("s8","Arial")
		ui.mainGui.AddText("x45 y80 hidden section")
		loop sqlResult.rows.length
			ui.mainGui.addText("x46 y+17 w390 h1 background" cfg.themeFont2Color)
	}


	winPosAdd(*) {
		DialogBox("Click Any Window`nTo Add Current Positioning`nTo Workspace " ui.workspaceDDL.text)
		keyWait("LButton","D")
		mouseGetPos(,,&winClicked)
		splitPath(winGetProcessPath(winClicked),,,,&winName)
		winGetPos(&currWinX,&currWinY,&currWinW,&currWinH,winClicked)
		sqliteExec(cfg.dbFilename,"INSERT into winPositions VALUES ('" ui.workspaceDDL.text "','" winName "','" currWinX "','" currWiny "','" currWinW "','" currWinH "','','" winGetProcessPath(winClicked) "')",&insertResult)
		workspaceChanged(lvColNames,lvColSizes)
		drawGridlines()
		DialogBoxClose()
	}
	
	winPosUpdate(*) {
	
	}
	
	winPosDelete(*) {
			sqliteExec(cfg.dbFilename,"DELETE from winPositions WHERE [Title]='" ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),1) "'",&sqlExecResult)
			workspaceChanged()
			setTimer () => drawGridLines(),-300
	}
	
	ui.mainGui.setFont("s9","calibri")

	ui.MainGui.AddText("x428 y50 section backgroundTrans w60 Right backgroundTrans","Add")
	ui.winPosAdd := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 vWin1 background" cfg.themeDisabledColor,"")
	ui.winPosAdd.OnEvent("Click",winPosAdd)
	ui.winPosAdd.Value := "./Img/button_down.png"
	cfg.Win1Coords := strSplit(iniRead(cfg.file,"AppDock","Win1Coords"),",")
	ui.winPosAdd.toolTipData := "Current Position:`nx: " cfg.win1coords[1] ", y: " cfg.win1coords[2] ", w: " cfg.win1coords[3] ", h: " cfg.win1coords[4] "`nClick to change"
	; ui.MainGui.AddText("xs+0 y+4 section backgroundTrans w60 Right backgroundTrans","Update")
	; ui.winPosUpdate := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 vWin2 background" cfg.themeDisabledColor,"")
	; ui.winPosUpdate.OnEvent("Click",winPosUpdate)
	; ui.winPosUpdate.Value := "./Img/button_down.png"
	cfg.Win2Coords := strSplit(iniRead(cfg.file,"AppDock","Win2Coords"),",")
	; ui.winPosUpdate.toolTipData := "Current Position:`nx: " cfg.win2coords[1] ", y: " cfg.win2coords[2] ", w: " cfg.win2coords[3] ", h: " cfg.win2coords[4] "`nClick to change"
	ui.MainGui.AddText("xs+0 y+0 section backgroundTrans w60 Right backgroundTrans","Delete")
	ui.winPosDelete := ui.MainGui.AddPicture("x+5 ys+0 w30 h20 vWin3 background" cfg.themeDisabledColor,"")
	ui.winPosDelete.OnEvent("Click",winPosDelete)
	ui.winPosDelete.Value := "./Img/button_down.png"
	cfg.Win3Coords := strSplit(iniRead(cfg.file,"AppDock","Win3Coords"),",")
	ui.winPosDelete.toolTipData := "Current Position:`nx: " cfg.win3coords[1] ", y: " cfg.win3coords[2] ", w: " cfg.win3coords[3] ", h: " cfg.win3coords[4] "`nClick to change"
	ui.RestoreWinPosLabel := ui.mainGui.addText("xs+0 y+20 w60 right section backgroundTrans","Apply")
	ui.restoreWinPosButton := ui.mainGui.addPicture("x+5 ys+1 w30 h20 background" cfg.themeDisabledColor,"./img/button_down.png")
	ui.restoreWinPosButton.onEvent("click",applyWinPos)
	applyWinPos(*) {
		
		sqliteQuery(cfg.dbFilename,"SELECT * FROM winPositions WHERE workspace='" ui.workspaceDDL.text "'",&sqlResult)
		
		if (sqlResult.hasRows) {
			loop sqlResult.rows.length {
				winNum := a_index
				processPath := sqlResult.rows[winNum][8]
				splitPath(processPath,&processName,&processDir)
				processRunning := false
				timeoutCounter := 0
				while (processRunning == false) || (timeoutCounter < 15) {
					timeoutCounter += 1
					if !(processExist(processName)) {
						run(processPath,processDir)
						sleep(2000)
					} else {
						processRunning := true
					}
				}
				this_win := winGetTitle("ahk_exe " processName)
				winMove(sqlResult.rows[winNum][3],sqlResult.rows[winNum][4],sqlResult.rows[winNum][5],sqlResult.rows[winNum][6],this_win)		
			}
		}
	}
	
	ui.MainGui.SetFont("s9 c" cfg.ThemeFont1Color,"Calibri")
	ui.MainGui.AddText("xs+0 y+27 section backgroundTrans w60 Right backgroundTrans","Caption")
	ui.toggleCaption := ui.MainGui.AddPicture("x+5 ys+0 w30 h20","./Img/button_down.png")
	ui.toggleCaption.toolTip := "Enable/Disable the caption bar on any window."
	ui.toggleCaption.OnEvent("Click",toggleCaption)
	ui.MainGui.AddText("xs+0 y+4 section backgroundTrans w60 Right backgroundTrans","OnTop")
	ui.universalOnTop := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 background" cfg.themeDisabledColor,"")
	ui.universalOnTop.OnEvent("Click",universalOnTop)
	ui.universalOnTop.Value := "./Img/button_down.png"
	ui.universalOnTop.toolTip := "Set any window to AlwaysOnTop"
	
	workspaceChanged(lvColNames,lvColSizes)
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