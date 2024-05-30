#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

sqlResult := ""

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
	
	lvDrawGridlines()
	if (sqlResult.hasRows) {
		ui.mainGui.setFont("s8","Arial")
		loop sqlResult.rows.length {
			ui.winPoslv.add("", sqlResult.rows[a_index]*)
		lvDrawGridlines()
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
	drawOutlineNamed("AppListView2",ui.mainGui,42,74,396,17,cfg.themeBorderLightColor,cfg.themeDark1Color,1)

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
	ui.winPosLV := ui.mainGui.addListView("x40 y92 w398 h114 -hdr e0x2000 c" cfg.themeBorderDarkColor " background" cfg.themePanel2Color)
	ui.winPosLV.setFont("s9","Calibri")
	ui.winPosLV.onEvent("itemFocus",changeWinSelected)
		ui.mainGui.setFont("s9","calibri")

	ui.MainGui.AddText("x426 y50 section backgroundTrans w60 Right backgroundTrans","Add")
	ui.winPosAdd := ui.MainGui.AddPicture("x+5 ys-1 w30 h20 vWin1 background" cfg.themePanel3Color,"")
	ui.winPosAdd.OnEvent("Click",winPosAdd)
	ui.winPosAdd.Value := "./Img/button_down.png"
	ui.winPosAdd.toolTipData := "Add window to current workspace" 
	ui.MainGui.AddText("xs+0 y+0 section backgroundTrans w60 Right backgroundTrans","Delete")
	ui.winPosDelete := ui.MainGui.AddPicture("x+5 ys+0 w30 h20 vWin3 background" cfg.themePanel3Color,"")
	ui.winPosDelete.OnEvent("Click",winPosDelete)
	ui.winPosDelete.Value := "./Img/button_down.png"
	ui.winPosDelete.toolTip := "Delete selected window from current workspace"
	ui.RestoreWinPosLabel := ui.mainGui.addText("xs+0 y+15 w60 right section backgroundTrans","Apply")
	ui.restoreWinPosButton := ui.mainGui.addPicture("x+5 ys+1 w30 h20 background" cfg.themePanel3Color,"./img/button_down.png")
	ui.restoreWinPosButton.onEvent("click",applyWinPos_callback)
	ui.winCloseLabel := ui.mainGui.addText("xs+0 y+0 w60 right section backgroundTrans","Close")
	ui.winCloseButton := ui.mainGui.addPicture("x+5 ys+1 w30 h20 background" cfg.themePanel3Color,"./img/button_down.png")
	ui.winCloseButton.onEvent("click",winCloseAll_callback)
	ui.MainGui.SetFont("s9 c" cfg.ThemeFont1Color,"Calibri")
	ui.MainGui.AddText("xs+0 y+15 section background w60 Right backgroundTrans","Caption")
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
}
	changeWinSelected(*) {
	
		this_winTitle := ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2)
		sqliteQuery(cfg.dbFilename,"SELECT [caption],[AlwaysOnTop] FROM [winPositions] WHERE [title] = '" this_winTitle "'",&sqlResult)
		this_caption := sqlResult.rows[1][1]
		this_alwaysOnTop := sqlResult.rows[1][2]
		
		if sqlResult.hasRows {
			if this_caption == true 
				ui.toggleCaption.opt("background" cfg.themeButtonOnColor)
				else
				ui.toggleCaption.opt("background" cfg.themeDisabledColor)
		
			if this_alwaysOnTop == true 
				ui.toggleOnTop.opt("background" cfg.themeButtonOnColor)
			else
				ui.toggleOnTop.opt("background" cfg.themeDisabledColor)
		}
		ui.toggleCaption.redraw()
		ui.toggleOnTop.redraw()
		lvDrawGridlines()
	}
		
	lvDrawGridlines() {
		ui.mainGuiTabs.useTab("AppDock")
		ui.mainGui.setFont("s8","Arial")
		ui.mainGui.AddText("x45 y80 hidden section")
		sqliteQuery(cfg.dbFilename,"SELECT title FROM winPositions WHERE workspace = '" ui.workspaceDDL.text "'",&sqlResult)
		loop sqlResult.rows.length
			ui.mainGui.addText("x46 y+17 w390 h1 background" cfg.themeFont2Color)
	}

	getWinOption(winTitle,winOption) {
		sqliteQuery(cfg.dbFilename,"SELECT [" winOption "] from [winPositions] WHERE [title]='" winTitle "'",&sqlResult)
		if sqlResult.hasRows
			return sqlResult.rows[1][1]
		else {
			setWinOption(winTitle,winOpti on,false)
			return false
		}
	}
	
	setWinOption(this_winTitle,winOption,isEnabled) {
		sqliteExec(cfg.dbFilename,"UPDATE [winPositions] SET [" winOption "] = " isEnabled " WHERE [title] = '" this_winTitle "'",&sqlResult)		
		;trayTip("Win: " this_winTitle "`nOption: " winOption "`nValue: " ((isEnabled) ? "On" : "Off"))
	}
	
	
	winPosAdd(*) {
		ui.winPosAdd.opt("background" cfg.themeButtonOnColor)
		DialogBox("Click Any Window`nTo Add Current Positioning`nTo Workspace " ui.workspaceDDL.text)
		sleep(500)
		keyWait("LButton","D")
		mouseGetPos(,,&winClicked)
		splitPath(winGetProcessPath(winClicked),,,,&winName)
		winGetPos(&currWinX,&currWinY,&currWinW,&currWinH,winClicked)
		sqliteExec(cfg.dbFilename,"INSERT into winPositions VALUES ('" ui.workspaceDDL.text "','" winName "','" currWinX "','" currWiny "','" currWinW "','" currWinH "','','" winGetProcessPath(winClicked) "',true,false)",&insertResult)
		DialogBoxClose()
		workspaceChanged()
		ui.winPosAdd.opt("background" cfg.themePanel3Color)
	}
	
	winPosDelete(*) {
			ui.winPosDelete.opt("background" cfg.themeButtonOnColor)
			sqliteExec(cfg.dbFilename,"DELETE from winPositions WHERE [Title]='" ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2) "'",&sqlExecResult)
			workspaceChanged()
			setTimer () => lvDrawGridlines(),-300
			setTimer () => ui.winPosDelete.opt("background" cfg.themePanel3Color),-400
	}
	
	applyWinPos_callback(*) {
		applyWinPos()
	}	
	
	applyWinPos(workspace := ui.workspaceDDL.text) {
		ui.restoreWinPosButton.opt("background" cfg.themeButtonOnColor)
		ui.restoreWinPosButton.redraw()
		sqliteQuery(cfg.dbFilename,"SELECT title,ProcessPath,winX,winY,winW,winH,caption,alwaysOnTop FROM winPositions WHERE workspace='" workspace "'",&sqlResult)
		;msgBoX('here')
		if (sqlResult.hasRows) {
			for row in sqlResult.rows {
				winNum := a_index
				this_winTitle := row[1]
				processPath 	:= row[2]
				this_coordX		:= row[3]
				this_coordY		:= row[4]
				this_coordW		:= row[5]
				this_coordH		:= row[6]
				this_Caption	:= row[7]
				this_onTop 		:= row[8]
				splitPath(processPath,&processName,&processDir)
				launchapp(processPath,processName,processDir) 
				try {
					winMove(this_coordX,this_coordY,this_coordW,this_coordH,"ahk_exe " processName)		
					if this_onTop == true
						winSetAlwaysOnTop(1,"ahk_exe " processName)
					else
						winSetAlwaysOnTop(0,"ahk_exe " processName)

					if this_caption == true
						WinSetStyle("+0xC00000", "ahk_exe " processName)
					else
						WinSetStyle("-0xC00000","ahk_exe " processName)
				}
			
			}
		}
	ui.restoreWinPosButton.opt("background" cfg.themePanel3Color)
	ui.restoreWinPosButton.redraw()
	}
	
	winCloseAll_callback(*) {
		winCloseAll()
	}
	winCloseAll(workspace := ui.workspaceDDL.text) {
		try 
			sqliteQuery(cfg.dbFilename,"SELECT [processPath] from [winPositions] where [workspace] = '" workspace "'",&sqlResult)
	
		if sqlResult.hasRows {
			for row in sqlResult.rows {
				splitPath(row[1],&processName)
				try
					winClose("ahk_exe " processName)
			}
			sleep(5000)
			for row in sqlResult.rows {
				splitPath(row[1],&processName)
				try
					processClose(processName)
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
				osdLog("launching " processName ": attempt " a_index)
			while processRunning == false && winWait_timeout < 5 {
				winWait_timeout += 1
				if processExist(processName)
					processRunning := true
					sleep(1000)
					osdLog("waitig for: " processName)
			}
		}
		
		DetectHiddenWindows(True)
		if currWin := winExist("ahk_exe " processName) {
			if winGetMinMax("ahk_id " currWin) != 0
				try
					winRestore("ahk_id " currWin)
			try
				winShow("ahk_id" currWin)
		}
		try 
			currWinMinMax := winGetMinMax("ahk_id " currWin)
		catch
			currWinMinMax := 0
		
		if currWinMinMax := 0
			return 1
		else 
			return 0
			 ; winMa
	}	
	

	toggleAlwaysOnTop(*) {
		this_winTitle 		:= ui.winPosLV.getText(ui.winPosLV.GetNext(0, "F"),2)
		sqliteQuery(cfg.dbFilename,"SELECT [processPath],[alwaysOnTop] FROM [winPositions] WHERE [title]='" this_winTitle "'",&sqlResult)
		this_processPath 	:= sqlResult.rows[1][1]
		this_alwaysOnTop	:= sqlResult.rows[1][2]
		
		splitPath(this_ProcessPath,&this_processName,&this_processDir)
		if (sqlResult.hasRows) {
			if (this_alwaysOnTop == true) {
				setWinOption(this_winTitle,"alwaysOnTop",false)
				if winExist("ahk_exe " this_processName)
					winSetAlwaysOnTop(0,"ahk_exe " this_processName)
				ui.toggleOnTop.opt("background" cfg.themeDisabledColor)
				ui.toggleOnTop.value := "./img/button_down.png"
				ui.toggleOnTop.redraw()
			} else {
				setWinOption(this_winTitle,"alwaysOnTop",true)
				if winExist("ahk_exe " this_processName)
					winSetAlwaysOnTop(1,"ahk_exe " this_processName)
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
		sqliteQuery(cfg.dbFilename,"SELECT [processPath],[caption] FROM [winPositions] WHERE [title]='" this_winTitle "'",&sqlResult)
		this_processPath 	:= sqlResult.rows[1][1]
		this_caption		:= sqlResult.rows[1][2]
		splitPath(this_processPath,&this_processName,&this_processDir)
		if (sqlResult.hasRows) {
			if (this_caption == true) {
				setWinOption(this_winTitle,"caption",false)
				if winExist("ahk_exe " this_processName)
					WinSetStyle("-0xC00000","ahk_exe " this_processName)
				ui.toggleCaption.opt("background" cfg.themeDisabledColor)
				ui.toggleCaption.value := "./img/button_down.png"
				ui.toggleCaption.redraw()
			} else {
				setWinOption(this_winTitle,"caption",true)
				if winExist("ahk_exe " this_processName)
					WinSetStyle("+0xC00000","ahk_exe " this_processName)
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
	


