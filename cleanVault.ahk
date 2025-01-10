#requires autoHotkey v2.0+
#singleInstance

persistent()
installMouseHook()
installKeybdHook()
keyHistory(10)

setting := object()
setting.gameExe := "destiny2.exe"
setting.xMargin:=305
setting.yMargin:=235
setting.columnCount:=10
setting.rowCount:=5
setting.tileSize:=67.25
setting.gameW:=1280
setting.gameH:=720
setting.transColor:="010203"

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
	thisGui.opt("-border")
	winSetTransColor(setting.transColor,thisGui.hwnd)
	;help:=thisGui.adwdText("section x5 y5 w650 h40 backgroundTrans c00FFFF",
	titleBarBg:=thisGui.addText("x0 y0 w1254 h30 background454545")
	titleBarBg.onEvent("click",wm_lbuttonDown_callback)
	titleBarText:=thisGui.addText("x10 y-2 w500 h30 backgroundTrans c212121","VaultCleaner for Destiny2 (v1.1)" )
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
	;onMessage(0x47,WM_WINDOWPOSCHANGED)
	WM_WINDOWPOSCHANGED(*) {
		try {
			winGetPos(&tX,&tY,,,thisGui.hwnd)
			winMove(tx+3,ty+32,,,this.gameWin)
		}		
	}
	WM_LBUTTONDOWN_callback(this_control*) {
		;postMessage("0xA1",2,,,"A")
		;WM_LBUTTONDOWN(0,0,0,this_control)
	}
	StatusText:=thisGui.addText("x10 y" 38+this.yOffset " w640 h30 backgroundTrans c00FFFF","Please Wait....")
	statusText.setFont("s16")
	mainButtonOutline:=thisGui.addText("x2 y" 2+this.yOffset " w86 h36 background505050","")
	mainButtonOutline:=thisGui.addText("x3 y" 3+this.yOffset " w84 h34 background404040","")
	mainButtonOutline:=thisGui.addText("x4 y" 4+this.yOffset " w82 h32 background303030","")
	mainButtonBg:=thisGui.addText("x5 y" 5+this.yOffset " w80 h30 background252525")
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
	elapsedTime:=thisGui.addText("x1169 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans","")
	remaining:=thisGui.addText("x1089 y" 45+this.yOffset " right w80 h25 c00FFFF backgroundTrans","Remaining: ")
	remainingtime:=thisGui.addText("x1169 y" 45+this.yOffset " left w80 h25 c00FFFF backgroundTrans","")
	vaultProgress := thisGui.addProgress("x0 y" 70+this.yOffset " w1289 h30 c440000 background151515 range1-500")
	
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


if winExist(this.gameWin) {
		winActivate(this.gameWin)
		winWait(this.gameWin)
		winSetStyle("-0xC00000",this.GameWin)
		winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this.gameWin)
		this.origGameWinX:=gameWinX
		this.origGameWinY:=gameWinY
		this.origGameWinW:=gameWinW
		this.origGameWinH:=gameWinH
		sleep(1000)
		if winGetMinMax(this.gameWin) {
			this.wasMax:=true
			send("{alt down}{enter}{alt up}")
		}

		sleep(3000)
		winMove((a_screenwidth/2)-640,(a_screenHeight/2)-360,1280,720,this.gameWin)
		winSetStyle("-0xC00000",this.GameWin)
		
		sleep(2000)
		winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this.gameWin)
		this.gameWinX:=gameWinX
		this.gameWinY:=gameWinY
		this.gameWinW:=gameWinW
		this.gameWinH:=gameWinH
		;bgGui.show("x" this.gameWinX+5 " y" this.gameWinY-30 " w1280 h" 30+this.gameWinH+100 " noActivate")
		thisGui.show("x" this.gameWinX+2 " y" this.gameWinY-28 " w1280 h" 30+this.gameWinH+94 " noActivate")
		;winSetTransColor("830303","ahk_exe destiny2.exe")
		winActivate(this.gameWin)
		sleep(2000)	
		while !winActive(this.gameWin) && !(A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
			sleep(2000)

		send("{F1}")
		sleep(600)
		while !winActive(this.gameWin) && !(A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
			sleep(2000)
		send("{Ctrl}")
		sleep(600)
		while !winActive(this.gameWin) && !(A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
			sleep(2000)
		send("{w}")
		sleep(600)
		while !winActive(this.gameWin) && !(A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
			sleep(2000)

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
	;setTimer(timer,1000)
	mouseMove(955,170)
	sleep(500)
	
	;click next page until at the end, count how many pages
	while round(pixelGetColor(955,170))==round("0xE0E0E0") {
		this.page+=1
		pageCount.text:=this.page

		mouseMove(955,170)
		send("{LButton Down}")
		sleep(350)
		send("{LButton Up}")
		sleep(350)
	}
	
	sleep(500)
	;click prev page so on the last page with a full 50 items
	mouseMove(905,170)
	sleep(500)
	send("{LButton Down}")
	sleep(350)
	send("{LButton Up}")
	this.page-=1
	pageCount.text:=this.page
	this.maxRange:=this.page*50
	vaultProgress.opt("range1-" this.maxRange)
	vaultProgress.value:=0
	sleep(800)

	;loop once for each page, clicking prev page in between
	while this.page>0 {
		;loop once for each of the 5 item rows
		loop setting.rowCount {
			;calculating reverse order so that when an item is dismantle, you dont have to backtrack
			this.row:=setting.rowCount-a_index
			;loop once for each of the 10 item columns (also reverse order)
			loop setting.columnCount {
				vaultProgress.value+=1
				this.col:=setting.columnCount-a_index
				this.itemNum+=1
				;check item locked status
				isUnlocked(this.col,this.row)
					;dismantle(this.col,this.row)
			}
		}
		this.results:=""
		sleep(800)
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
	setTimer(timer,0)
}
this.results:=""
this.lastRow:=5
this.results :=""

dismantle(thisCol,thisRow) {
	x:=tile(thisCol,thisRow).x
	y:=tile(thisCol,thisRow).y
	if !result.locked {
		;msgBox("dismantling")
		send("{f 300}")
		sleep(4000)
		send("{f up}")
	}
}


isUnlocked(thisCol,thisRow,x:=tile(thisCol,thisRow).x,y:=tile(thisCol,thisRow).y) {
	this.timeoutCounter:=0
	while !winActive(this.gameWin) && ((this.timeoutCounter:=a_index) < 20)
		sleep(1000)
		
	if this.timeoutCounter >= 20 {
		msgBox('Game window out-of-focus too long.`nStopping Vault Clean Process')
		exit
	}
	result.locked:=false
	mouseMove(x,y)
	sleep(50)
	send("{f}")
	;sleep(100)
	this.color:=array()
	sleep(20)
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

	;send("{f up}")
	sleep(350)
	if !result.locked {
		winActivate(this.gameWin)
		sleep(200)
		setKeyDelay(50)
		sendEvent("{f 200}")
		sleep(10000)
	}
	send("{f up}")

}

isDismantling(*) {
	loop 10 {
		if pixelSearch(&returnX,&returnY,0,300,1280,720,"0x830303",1) {
			this.returnX:=returnX
			this.returnY:=returnY
			return 1
		} else
			sleep(50)
	}
	return 0
}

hotIf(isHot)
	+\:: {
		statusText.text:="[Esc] to Stop/Exit"
		cleanVaultStart()
	}
hotIf()

Esc:: {
	reload()
}

isHot(*) {
	if winActive(this.gameWin)
		return 1
	else
		return 0
}
	
	
isIdle(*) {
	if (A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
		return 1
	else 
		return 0
}




onExit(exitFunc)
exitFunc(*) {
	thisGui.hide()
	winSetStyle("-0xC00000",this.GameWin)
	winMove(this.origGameWinX,this.origGameWinY,this.origGameWinW,this.origGameWinH,this.gameWin)
	sleep(2000)
	if this.wasMax
		send("{alt down}{enter}{alt up}")
}