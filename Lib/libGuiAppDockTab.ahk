#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off


if !(StrCompare(A_LineFile,A_ScriptFullPath)) {
	InstallDir 		:= IniRead("./cacheApp.ini","System","InstallDir",A_MyDocuments "\cacheApp")
	MainScriptName 	:= IniRead("./cacheApp.ini","System","MainScriptName","cacheApp")
	Run(A_ScriptDir "/../" MainScriptName ".ahk")
	ExitApp
}

workspaceChanged(*) {

	iniWrite(ui.workspaceDDL.value,cfg.file,"AppDock","SelectedWorkspace")
	sqliteQuery(cfg.dbFilename,"SELECT '',Title,winX,winY,winW,winH,ProcessPath FROM winPositions WHERE workspace='" ui.workspaceDDL.text "'",&sqlResult)
	;sqliteShowResult(ui.winPosLV,sqlResult,lvColNames,lvColSizes)
	ui.winPosLV.delete()
	loop ui.winPoslv.getCount("col") 
		ui.winPoslv.deleteCol(1)
	for colDef in  ui.lvColDefs {
		ui.winPoslv.insertCol(a_index, "", strSplit(colDef,":")[3] " " strSplit(colDef,":")[1])
		if a_index == 1
			ui.winPoslv.modifyCol(a_index,strSplit(colDef,":")[3] " " strSplit(colDef,":")[2]-1)
		else
			ui.winPoslv.modifyCol(a_index,strSplit(colDef,":")[3] " " strSplit(colDef,":")[2]+1)
			
	}
	if (sqlResult.hasRows) {
		ui.mainGui.setFont("s8","Arial")
		loop sqlResult.rows.length {
			ui.winPoslv.add("", sqlResult.rows[a_index]*)
		drawGridLines()
		}
	}
}

GuiDockTab(&ui) {
	selectedRow := ""
	ui.MainGuiTabs.UseTab("AppDock")
	ui.mainGui.setFont("s9","Arial")
	ui.lvColDefs := [":0:","Title:68:","X:40:Right","Y:40:Right","W:40:Right","H:40:Right","Process Path:159:"]
	drawPanel(ui.mainGui,40,40,400,32,cfg.themePanel1Color,cfg.themeBright2Color,cfg.themeDark2Color,1,1,.75,85,"Window Sets","Calibri",cfg.themeFont1Color )
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
	ui.workspaceDDL.setFont("s9","arial")
	drawOutlineNamed("AppListView",ui.mainGui,41,73,398,19,cfg.themeBright2Color,cfg.themeBorderDarkColor,2)
	drawOutlineNamed("AppListView",ui.mainGui,42,74,396,17,cfg.themeBorderLightColor,cfg.themeDark1Color,1)

	ui.workspaceDDL.onEvent("change",workspaceChanged)
	
	ui.mainGui.AddText("xs-11 y+-17 section hidden")
	ui.mainGui.setFont("s10 bold")
	for colDef in ui.lvColDefs {
		ui.mainGui.AddText("x+0 ys+0 w" strSplit(colDef,":")[2] " h17 center c" cfg.themeFont1Color " background" cfg.themePanel1Color, strSplit(colDef,":")[1])
		if a_index < ui.lvColDefs.length 
			ui.mainGui.AddText("x+0 ys+0 w1 h17 background" cfg.themeBright2Color,"")
		else
			ui.mainGui.AddText("x+0 ys+0 w2 h17 background" cfg.themePanel2Color,"")
	}
	ui.mainGui.setFont("s8","Calibri Light")
	ui.winPosLV := ui.mainGui.addListView("x41 y92 w398 h114 -hdr e0x2000 c" cfg.themeFont2Color " background" cfg.themePanel2Color)
	ui.winPosLV.setFont("s9","Calibri")
	ui.winPosLV.onEvent("itemFocus",changeWinSelected)
		ui.mainGui.setFont("s9","calibri")

	ui.MainGui.AddText("x428 y50 section backgroundTrans w60 Right backgroundTrans","Add")
	ui.winPosAdd := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 vWin1 background" cfg.themeButtonReadyColor,"")
	ui.winPosAdd.OnEvent("Click",winPosAdd)
	ui.winPosAdd.Value := "./Img/button_down.png"
	ui.winPosAdd.toolTipData := "Add window to current workspace" 
	ui.MainGui.AddText("xs+0 y+0 section backgroundTrans w60 Right backgroundTrans","Delete")
	ui.winPosDelete := ui.MainGui.AddPicture("x+5 ys+0 w30 h20 vWin3 background" cfg.themeButtonReadyColor,"")
	ui.winPosDelete.OnEvent("Click",winPosDelete)
	ui.winPosDelete.Value := "./Img/button_down.png"
	ui.winPosDelete.toolTip := "Delete selected window from current workspace"
	ui.RestoreWinPosLabel := ui.mainGui.addText("xs+0 y+20 w60 right section backgroundTrans","Apply")
	ui.restoreWinPosButton := ui.mainGui.addPicture("x+5 ys+1 w30 h20 background" cfg.themeButtonAlertColor,"./img/button_down.png")
	ui.restoreWinPosButton.onEvent("click",applyWinPos)
	ui.MainGui.SetFont("s9 c" cfg.ThemeFont1Color,"Calibri")
	ui.MainGui.AddText("xs+0 y+27 section background w60 Right backgroundTrans","Caption")
	ui.toggleCaption := ui.MainGui.AddPicture("x+5 ys+0 w30 h20 background" cfg.themeDisabledColor,"./Img/button_down.png")
	ui.toggleCaption.toolTip := "Enable/Disable the caption bar on any window."
	ui.toggleCaption.OnEvent("Click",toggleCaption)
	ui.MainGui.AddText("xs+0 y+4 section w60 Right backgroundTrans","OnTop")
	ui.toggleOnTop := ui.MainGui.AddPicture("x+5 ys+0 w30 h20 background" cfg.themeDisabledColor,"./img/button_down.png")
	ui.toggleOnTop.OnEvent("Click",toggleAlwaysOnTop)
	ui.toggleOnTop.toolTip := "Set any window to AlwaysOnTop"
	
	ui.currWinPosLVSelection := ui.winPosLV.GetNext(0, "F")
	if !ui.currWinPosLVSelection
		ui.currWinPosLVSelection := 1
	ui.winPosLV.modify(ui.currWinPosLVSelection,"Select")

	CLV := LV_Colors(ui.winPosLV)
	clv.selectionColors("333333","CCCCCC")

	lvHdr := clv.header
	GuiCtrlFromHwnd(lvHdr).opt("background" cfg.themeDark2Color " c" cfg.themeFont1Color)
	
	workspaceChanged()
	changeWinSelected(*) {
		drawGridlines()
	
		this_winTitle := ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2)
		sqliteQuery(cfg.dbFilename,"SELECT [optionEnabled] from [winOptions] WHERE [window]='" this_winTitle "' AND [option]='caption'",&tblWinOptions)
		
		if tblWinOptions.hasRows {
			;msgBoX(this_winTitle "`ncaption: " tblWinOptions.rows[1][1])
			if tblWinOptions.rows[1][1] == false 
				ui.toggleCaption.opt("background" cfg.themeButtonOnColor)
			else
				ui.toggleCaption.opt("background" cfg.themeDisabledColor)
		} else
			sqliteExec(cfg.dbFilename,"INSERT INTO [winOptions] VALUES ('" this_winTitle "','caption',false)",&sqlResult)
		
		
		sqliteQuery(cfg.dbFilename,"SELECT [optionEnabled] from [winOptions] WHERE [window]='" this_winTitle "' AND [option]='alwaysOnTop'",&tblWinOptions)
		if tblWinOptions.hasRows {
			;msgBoX(this_winTitle "`nonTop: " tblWinOptions.rows[1][1])
			if tblWinOptions.rows[1][1] == true 
				ui.toggleOnTop.opt("background" cfg.themeButtonOnColor)
			else
				ui.toggleOnTop.opt("background" cfg.themeDisabledColor)
		} else
			sqliteExec(cfg.dbFilename,"INSERT INTO [winOptions] VALUES ('" this_winTitle "','alwaysOnTop',false)",&sqlResult)
		


		ui.toggleCaption.redraw()
		ui.toggleOnTop.redraw()
		
		sqliteQuery(cfg.dbFilename,"SELECT processPath from winPositions where title='" this_winTitle "'",&this_processPath)
		if this_processPath.hasRows
			toolTip("Process Path: " this_processPath.rows[1][1])
	}
		
	drawGridLines(*) {
		ui.mainGui.setFont("s8","Arial")
		ui.mainGui.AddText("x45 y80 hidden section")
		loop sqlResult.rows.length
			ui.mainGui.addText("x46 y+17 w390 h1 background" cfg.themeFont2Color)
	}

	getWinOption(winTitle,winOption) {
		sqliteQuery(cfg.dbFilename,"SELECT [optionEnabled] from [winOptions] WHERE [window]='" winTitle "' AND [option]= '" winOption "'",&tblWinOptions)
		
		if tblWinOptions.hasRows {
			if winOption = 'caption'
				tblWinOptions.rows[1][1] != tblWinOptions.rows[1][1]
			return tblWinOptions.rows[1][1]
		} else {
			setWinOption(winTitle,winOption,false)
			return false
		}
	}
	
	setWinOption(this_winTitle,winOption,isEnabled) {
		if winOption == 'caption'
			if isEnabled == true
				isEnabled := false
			else 
				isEnabled := true
				
		sqliteExec(cfg.dbFilename,"DELETE FROM winOptions WHERE [Window]='" this_winTitle "' and [Option]= '" winOption "'",&result)
		sqliteExec(cfg.dbFilename,"INSERT INTO winOptions VALUES ('" this_winTitle "','" winOption "','" isEnabled "')",&result)
		;trayTip("Win: " this_winTitle "`nOption: " winOption "`nValue: " ((isEnabled) ? "On" : "Off"))
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
		workspaceChanged()
	}
	
	winPosDelete(*) {
			sqliteExec(cfg.dbFilename,"DELETE from winPositions WHERE [Title]='" ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2) "'",&sqlExecResult)
			workspaceChanged()
			setTimer () => drawGridLines(),-300
	}
		
	applyWinPos(*) {
		sqliteQuery(cfg.dbFilename,"SELECT ProcessPath,winX,winY,winW,winH FROM winPositions WHERE workspace='" ui.workspaceDDL.text "'",&sqlResult)
		msgBoX('here')
		if (sqlResult.hasRows) {
			for row in sqlResult.rows {
				winNum := a_index
				processPath := row[1]
				splitPath(processPath,&processName,&processDir)
				if (launchapp(processPath,processName,processDir)) {
					this_win := winGetTitle("ahk_exe " processName)
					winMove(sqlResult.rows[winNum][2],sqlResult.rows[winNum][3],sqlResult.rows[winNum][4],sqlResult.rows[winNum][5],this_win)		
				}
			}
		}
	}

	launchApp(processPath,processName,processDir) {
		processRunning := false
		rerun_timeout := 0
		winWait_timeout := 0
		while processRunning == false && rerun_timeOut < 5  {
			rerun_timeout += 1
			if !processExist(processName)
				run(processPath,processDir)
			while processRunning == false && winWait_timeout < 5 {
				winWait_timeout += 1
				if processExist(processName)
					processRunning := true
					sleep(1000)
			}
		}
		
		if winExist("ahk_exe " processName) {
			winMaximize("ahk_exe " processName)
			sleep(350)
			winRestore("ahk_exe " processName)
			return 1
		} else { 
			return 0
		}
		

	}	
	
	

	toggleAlwaysOnTop(*) {
		this_winTitle := ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2)
		sqliteQuery(cfg.dbFilename,"SELECT [optionEnabled] FROM [winOptions] WHERE [window]='" this_winTitle "' AND [option]='alwaysOnTop'",&optionEnabled)
		if (optionEnabled.hasRows) {
			if (optionEnabled.rows[1][1] == true) {
				setWinOption(this_winTitle,"alwaysOnTop",false)
				ui.toggleOnTop.opt("background" cfg.themeDisabledColor)
				ui.toggleOnTop.value := "./img/button_down.png"
				ui.toggleOnTop.redraw()
			} else {
				setWinOption(this_winTitle,"alwaysOnTop",true)
				ui.toggleOnTop.opt("background" cfg.themeButtonOnColor)
				ui.toggleOnTop.value := "./img/button_down.png"
				ui.toggleOnTop.redraw()
			} 
		} else {
			setWinOption(this_winTitle,"alwaysOnTop",true)
			ui.toggleOnTop.opt("background" cfg.themeButtonOnColor)
			ui.toggleOnTop.value := "./img/button_down.png"
			ui.toggleOnTop.redraw()
		}
			
	}
		
	toggleCaption(*) {
		this_winTitle := ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2)
		sqliteQuery(cfg.dbFilename,"SELECT [optionEnabled] FROM [winOptions] WHERE [window]='" this_winTitle "' AND [option]='caption'",&optionEnabled)
		if (optionEnabled.hasRows) {
			if (optionEnabled.rows[1][1] == false) {
				setWinOption(this_winTitle,"caption",false)
				ui.toggleCaption.opt("background" cfg.themeDisabledColor)
				ui.toggleCaption.value := "./img/button_down.png"
				ui.toggleCaption.redraw()
			} else {
				setWinOption(this_winTitle,"caption",true)
				ui.toggleCaption.opt("background" cfg.themeButtonOnColor)
				ui.toggleCaption.value := "./img/button_down.png"
				ui.toggleCaption.redraw()
			} 
		} else {
			setWinOption(this_winTitle,"caption",true)
			ui.toggleCaption.opt("background" cfg.themeButtonOnColor)
			ui.toggleCaption.value := "./img/button_down.png"
			ui.toggleCaption.redraw()
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
	
}
	; launchApp(this_winProcessPath) {
		; if inStr(this_winProcessPath,"discord")
			; this_winProcessPath := installDir "\redist\discord.exe"
		; splitPath(this_winProcessPath,&this_winProcessName,&this_winStartupDir,&this_winProcessExt,&this_winTitle,)
		; timeoutCounter := 0
		; retryCounter := 0
			; while !winExist("ahk_exe " this_winProcessName) && retryCounter < 5 {
				; run(this_winProcessName,this_winStartupDir)
				; retryCounter += 1 
				; while !processExist(this_winProcessName) && timeoutCounter < 5 {
					; sleep(1000)
					; timeoutCounter += 1
				; }
			; }
		; if winExist(this_winProcessName)
			; return 1
		; else
			; return 0
	; }
