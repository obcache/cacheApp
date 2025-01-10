#requires autoHotkey v2.0+
#singleInstance



setting := object()
setting.gameExe := "destiny2.exe"
setting.xMargin:=305
setting.yMargin:=235
setting.columnCount:=10
setting.rowCount:=5
setting.tileSize:=67
setting.gameW:=1280
setting.gameH:=720
setting.transColor:="010203"
if a_args.length>0
	setting.arg[1]:=a_args[1]
result := object()
result.tileNum:=0
result.tileStr := ""

this:=object()
this.gameWin:="ahk_exe " setting.gameExe
if !winExist(this.gameWin) {
	msgBox("Destiny2 is not Running")
	exitApp
}

this.page:=1
this.row:=1
this.col:=1
this.x:=0
this.y:=1
this.locked:=true
this.exotic:=false
this.wasMax:=false
this.maxRange:=100
this.state:=false
this.itemNum:=0
this.YOffset:=748

	; bgGui := gui()
	; bgGui.opt("alwaysOnTop -caption -border toolWindow")
	; bgGui.backColor:="333333"
	; winSetTransparent(190,bgGui.hwnd)
	
	thisGui := gui()
	
	thisGui.backColor:=setting.transColor
	thisGui.setFont("s10 c000000","Calibri")
	thisGui.opt("-border alwaysOnTop")
	winSetAlwaysOnTop(true,this.gameWin)

	winSetTransColor(setting.transColor,thisGui.hwnd)
	;help:=thisGui.adwdText("section x5 y5 w650 h40 backgroundTrans c00FFFF",
	titleBarBg:=thisGui.addText("x0 y0 w1254 h30 background454545")
	titleBarBg.onEvent("click",wm_lbuttonDown_callback)
	titleBarText:=thisGui.addText("x10 y-2 w500 h30 backgroundTrans c212121","VaultCleaner for Destiny2 (v1.2)" )
	titleBarText.setFont("s20 bold cbbbbbb","calibri")
	closeButton:=thisGui.addText("x1250 y0 w30 h30 cBBBBBB background454545","T")
	closeButton.setFont("s24","WingDings 2")
	closeButton.onEvent("click",closeProgram)
	closeProgram(*) {
		exitApp
	}
	footerBarBg:=thisGui.addText("x0 y" this.yOffset " w1284 h100 background454545")
	thisGui.addText("x0 y30 w1284 h2 background959595")
	thisGui.addText("x0 y" this.YOffset " w1284 h2 background959595")
	onMessage(0x47,WM_WINDOWPOSCHANGED)
	WM_WINDOWPOSCHANGED(*) {
		try {
			winGetPos(&tX,&tY,,,thisGui.hwnd)
			winMove(tx+3,ty+32,,,this.gameWin)
		}		
	}
	WM_LBUTTONDOWN_callback(this_control*) {
		postMessage("0xA1",2,,,"A")
		;WM_LBUTTONDOWN(0,0,0,this_control)
	}
	StatusText:=thisGui.addText("x10 y" 38+this.yOffset " w640 h30 backgroundTrans c00FFFF","Please Wait....")
	statusText.setFont("s16")
	mainButtonBg:=thisGui.addText("x5 y" 5+this.yOffset " w80 h30 background353535")
	mainButton:=thisGui.addText("section center x7 y" 7+this.yOffset " w76 h26 background454545 c00FFFF","")
	mainButtonText:=thisGui.addText("section center x7 y" 2+this.yOffset " w76 h30 backgroundTrans c353535","Start")
	mainButtonText.setFont("s20")
	mainButtonHotkey:=thisGui.addText("left ys backgroundTrans c454545 h30 w130","[ Shift ]+[ \ ]")
	mainButtonHotkey.setFont("s20")
	;mainButton.onEvent("click",toggleButton)
	toggleButton(*) {
		(this.state:=!this.state)
			? cleanVaultStart()
			: reload()
	}
	;help2:=thisGui.addText("xs+0 w600 h60 y+0 backgroundTrans c00FFFF","")

	page:=thisGui.addText("right x1089 y" 5+this.yOffset " w80 h25 backgroundTrans c00FFFF","Page: ")
	page.setFont("s12")
	pageCount:=thisGui.addText("x1169 y" 5+this.yOffset " left w80 h25 c00FFFF backgroundTrans",this.page)
	pageCount.setFont("s12")
	thisGui.setFont("s12")
	elapsed:=thisGui.addText("x1089 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Elapsed: ")
	elapsedTime:=thisGui.addText("	x1169 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans","")
	remaining:=thisGui.addText("x1089 y" 45+this.yOffset " right w80 h25 c00FFFF backgroundTrans","Remaining: ")
	remainingtime:=thisGui.addText("x1169 y" 45+this.yOffset " left w80 h25 c00FFFF backgroundTrans","")
	vaultProgress := thisGui.addProgress("x0 y" 70+this.yOffset " w1289 h30 c440000 background151515 range1-500")
				
	;titleBar := thisGui.addText("x0 y0 w550 h30 background454545")
	;titleBar.onEvent("click",wm_lbuttonDown_callback)
	;result.logUi := thisGui.addListView("x0 y30 w550 background" setting.transColor " h980 cLime",)
	; result.logUi.insertCol(1,"autoHdr SortDesc 60","Index")
	; result.logUi.insertCol(2,"autoHdr 70","Locked")
	; result.logUi.insertCol(3,"autoHdr 75","isExotic")
	; result.logUi.insertCol(4,"autoHdr 70","xCoord")
	; result.logUi.insertCol(5,"autoHdr 70","yCoord")
	; result.logUi.insertCol(6,"autoHdr 100","Icon")
	; result.logUi.insertCol(7,"autoHdr 100","Dism")

this.remainHour:=""
this.remainMin:=""
this.remainSec:=""
this.elapsedHour:=""
this.elapsedMin:=""
this.elapsedSeconds:=""

timeFormat(seconds) {
	sec:=mod(seconds,60)
	min:=round(seconds/60)
	hour:=round(seconds/3600)
	return(format("{:02d}",hour) ":" format("{:02d}",min) ":" format("{:02d}",sec))
}

timer(*) {
	static elapsedSec := 0
	static remainingSec := 0
	elapsedSec +=1
	elapsedTime.text := timeFormat(elapsedSec)
	try
		remainingItems:=this.maxRange-this.itemNum
	try
		currSpeed:=elapsedSec/this.itemNum
	try
		remainingSec:=remainingItems*currSpeed
	remainingTime.text:= timeFormat(remainingSec)
}
tile(colNum,rowNum) {
	tile := object()
	tile.x := (setting.xMargin)+(setting.tileSize*colNum)+(setting.tileSize/2)
	tile.y := (setting.yMargin)+(setting.tileSize*rowNum)+(setting.tileSize/2)
	return tile
}

winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this.gameWin)
	this.gameWinX:=gameWinX
	this.gameWinY:=gameWinY
	this.gameWinW:=gameWinW
	this.gameWinH:=gameWinH
	this.origGameWinX:=gameWinX
	this.origGameWinY:=gameWinY
	this.origGameWinW:=gameWinW
	this.origGameWinH:=gameWinH

if this.gameWin {


		;msgBox winGetStyle(this.gameWin)
		if winGetStyle(this.gameWin)=="0xC00000"
			winSetStyle("-0xC00000",this.GameWin)	
		sleep(1000)
		winActivate(this.gameWin)
		winWait(this.gameWin)
		if this.gameWinW == a_screenWidth && this.gameWinY == a_screenHeight {
			this.wasMax:=true
		;send("{alt down}{enter}{alt up}")
		}

		sleep(1200)
		if !(this.gameWinW==1280 && this.gameWinH==720) {
			winActivate(this.gameWin)
			winMove((a_screenwidth/2)-640,(a_screenHeight/2)-360,1280,720,this.gameWin)
			sleep(2000)
		}
		thisGui.show("x" this.gameWinX+2 " y" this.gameWinY-28 " w1280 h" 30+this.gameWinH+94 " noActivate")
		winSetTransColor("830303","ahk_exe destiny2.exe")
		winActivate(this.gameWin)
		sleep(2000)	

		while !winActive(this.gameWin)
			sleep(1000)
		send("{F1}")
		sleep(600)
		while !winActive(this.gameWin)
			sleep(1000)
		send("{Ctrl}")
		sleep(600)
		while !winActive(this.gameWin)
			sleep(1000)
		send("{w}")
		sleep(600)
		mainButtonHotkey.setFont("c00FFFF")
		statusText.text:="Dismantles ALL unlocked items. *DIM Search 'is:unlocked' to review"
		mainButton.opt("background22aa11")
		mainButton.redraw()
} else {
		msgBox("Process " setting.gameExe " not Running")
}

cleanVaultStart(*) {
	coordMode("mouse","client")
	mainButtonHotkey.text:="[Esc]" 	
	mainButton.opt("backgroundbb2211 c252525")
	mainButtonText.text:="Stop"
	setTimer(timer,1000)
	mouseMove(955,170)
	sleep(500)
	notLastPage:=true
	pageUpColor:=""
	
	loop {
		;msgBox(pageUpColor := pixelGetColor(970,170))
		;msgBox(subStr(pageUpColor,3,1))
		currPixColor:= 10
		try 
			currPixColor := round(subStr(pixelGetColor(970,170),3,1))
		if currPixColor <= "3" {
			mouseMove(955,170)
			this.page+=1
			pageCount.text:=this.page
			sleep(250)
			send("{LButton Down}")
			sleep(250)
			send("{LButton Up}")
			;sleep(350)
		} else {
			break
		}
	}
	sleep(250)
	mouseMove(905,170)
	sleep(250)
	send("{LButton Down}")
	sleep(250)
	send("{LButton Up}")
	this.page-=1
	pageCount.text:=this.page
	this.maxRange:=this.page*50
	vaultProgress.opt("range1-" this.maxRange)
	vaultProgress.value:=0
	sleep(800)


	while this.page>0 {

		loop setting.rowCount {
			this.row:=setting.rowCount-a_index
			loop setting.columnCount {
				vaultProgress.value+=1
				this.col:=setting.columnCount-a_index
				this.itemNum+=1
				;dismantle(this.col,this.row,tile(this.col,this.row).x,tile(this.col,this.row).y)
				isUnlocked(this.col,this.row)
				
			}
		}
		sleep(500)
		mouseMove(905,170)
		send("{LButton Down}")
		sleep(350)
		send("{LButton Up}")
		this.page-=1
		
		pageCount.text:=this.page
		sleep(600)
	}
	completeMsg:=thisGui.addText("x30 y67 w500 h30 backgroundTrans c00FFFF","Operation Complete")
		;msgBox(result.logUi.text)
	setTimer(timer,0)
}


isUnlocked(thisCol,thisRow,x:=tile(thisCol,thisRow).x,y:=tile(thisCol,thisRow).y) {
	this.timeoutCounter:=0
	while !winActive(this.gameWin) && ((this.timeoutCounter:=a_index) < 20)
		sleep(1000)
		
	if this.timeoutCounter >= 20 {
		msgBox('Game window out-of-focus too long.`nStopping Vault Clean Process')
		exit
	}
	
	mouseMove(x,y)
	sleep(50)
	send("{f}")
	this.color:=array()
	sleep(20)
	result.locked:=false
	if thisCol >= 5 {
		loop 5 {
			this.color:=pixelGetColor(x+(setting.tileSize/2)-4,y)
			if subStr(this.color,3,1) != subStr(this.color,5,1) {
				result.locked:=true
				break
			}
		}
	} else {
		loop 5 {
			this.color:=pixelGetColor(x-(setting.tileSize/2)+2,y) '`n'
			if subStr(this.color,3,1) != subStr(this.color,5,1) {
				result.locked:=true
				break
			}
		}
	}

	sleep(150)
	if !result.locked {
		sendEvent("{f down}")
		sleep(1850)
	
		loop 30 {
			if pixelSearch(&returnX,&returnY,(thisCol>=5) ? x+50 : x-150,300,100,720,"0x830303",1) {
				sleep(2500)
				break
			}
			sleep(10)
		}
	}
	send("{f up}")
}

dismantle(thisCol,thisRow,x:=tile(thisCol,thisRow).x,y:=tile(thisCol,thisRow).y) {
	isUnlocked:=false
	isExotic:=false
	mouseMove(x,y)
	sleep(50)
	send("{f down}")
	sleep(150)
	loop 30 {
		if pixelSearch(&returnX,&returnY,0,300,1280,720,"0x830303",1) {
			;msgBox("pass1")
			isUnlocked := true
			break
		}
	}
	
	if isUnlocked {
		sleep(2000)
		loop 30 {
			if pixelSearch(&returnX,&returnY,0,300,1280,720,"0x830303",1) {
				isExotic := true
				break
			}
		}
		if isExotic
			sleep(3000)
	}
	
	send("{f up}")
	isUnlocked:=false
	isExotic:=false
}

	
	
isIdle(*) {
	if (A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
		return 1
	else 
		return 0
}




onExit(exitFunc)
exitFunc(*) {
	;thisGui.hide()
	sleep(2000)
	if this.wasMax
		send("{alt down}{enter}{alt up}")
	winMove(this.origGameWinX,this.origGameWinY,this.origGameWinW,this.origGameWinH,this.gameWin)
	winSetStyle("-0xC00000",this.GameWin)
	
}

resetApp(*) {
	}

hotIf(isHot)
	+\:: {
		statusText.text:="[Esc] to Stop/Exit"
		
		cleanVaultStart()
}
Esc:: {
	resetApp()
}
F5:: {
	reload()
}
hotIf()

isHot(*) {
	if winActive(this.gameWin)
		return 1
	else
		return 0
}
