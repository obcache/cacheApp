A_FileVersion := "1.3.2.7"
;@Ahk2Exe-Let FileVersion=%A_PriorLine~U)^(.+"){1}(.+)".*$~$2% 

A_AppName := "cacheApp"
if (fileExist("./cacheApp_currentBuild.dat"))
	A_FileVersion := FileRead("./cacheApp_currentBuild.dat")
;@Ahk2Exe-SetName cacheApp
;@Ahk2Exe-SetVersion %U_FileVersion%
;@Ahk2Exe-SetFileVersion %U_FileVersion%

#Requires AutoHotkey v2.0
#SingleInstance
#Warn All, Off

currExe := DllCall("GetCommandLine", "str")

a_restarted := 
	(inStr(dllCall("GetCommandLine","Str"),"/restart"))
		? true
		: false
		
if !a_isAdmin {
    try
    {
        if a_isCompiled
            run '*runAs "' a_scriptFullPath '" /restart'
        else
            run '*runAs "' a_ahkPath '" /restart "' a_scriptFullPath '"'
    }
    exitApp()
}



persistent()
installMouseHook()
installKeybdHook()
keyHistory(10)
setWorkingDir(a_scriptDir)


		
installDir 		:= a_myDocuments "\cacheApp"
configFileName 	:= "cacheApp.ini"
themeFileName	:= "cacheApp.themes"

; if fileExist("./extractAssets.ahk")
	; fileDelete("./extractAssets.ahk")
; loop files, "./img2/infogfx/vod/*.png" {
	; flist .= a_loopFilename "`n"
	; fileAppend('fileInstall("./img2/infogfx/vod/' a_loopFilename '", "' installDir '/img2/infogfx/vod/' a_loopFilename '",1)`n',"./extractAssets.ahk")
; }
; keyWait("Escape")
; return

loadingProgressStep(*) {
		ui.loadingProgress.value += 1
}

preAutoExec(InstallDir,ConfigFileName)
cfg.file 		:= "./" ConfigFileName
adjustPos()
loadScreen()
initTrayMenu()
	d2ActivePanel := 1

; ui.AfkGui 		:= Gui()
dockApp 		:= Object()
workApp			:= Object()

cfg.ThemeFile	:= "./" ThemeFileName
ui.pinned 		:= 0
ui.hidden 		:= 0
ui.hwndAfkGui 	:= ""
ui.AfkHeight 	:= 170
ui.latestVersion := ""
ui.installedVersion := ""
ui.incursionDebug := false

MonitorGet(MonitorGetprimary(),
	&primaryMonitorLeft,
	&primaryMonitorTop,
	&primaryMonitorRight,
	&primaryMonitorBottom)

MonitorGetWorkArea(MonitorGetprimary(),
	&primaryWorkAreaLeft,
	&primaryWorkAreaTop,
	&primaryWorkAreaRight,
	&primaryWorkAreaBottom)
cfgLoad(&cfg, &ui)
ui.loadingProgress.value += 5


initGui(&cfg, &ui)
ui.loadingProgress.value += 10

initConsole(&ui)
ui.loadingProgress.value += 10

#include <class_sqliteDb>
#include <class_lv_colors>
#include <libGui>
#include <libWinMgr>
#include <libGlobal>
#include <libGuiOperationsTab>
#include <libGuiAFKTab>
#include <libAfkFunctions>
#include <libGuiSetupTab>
#include <libGuiAppDockTab>
#include <libGameSettingsTab>
#include <libEditorTab>
ui.loadingProgress.value += 15
#include <libGuiSystemTab>
#include <libGuiSystemTab>
#include <libHotkeys>
#include <libRoutines>
#include <libThemeEditor>
ui.loadingProgress.value += 10

debugLog("Interface Initialized")
OnExit(ExitFunc)
debugLog("Console Initialized")

ui.gameTabs.choose(cfg.gameModuleList[cfg.activeGameTab])
ui.loadingProgress.value += 5

createDockBar()
ui.loadingProgress.value += 5
	
changeGameDDL()

ui.loadingProgress.value += 5
drawAfkOutlines()

ui.loadingProgress.value += 5
try
	guiVis("all",false)

ui.loadingProgress.value += 5
ui.afkGui.show("x" cfg.guiX+45 " y" cfg.guiY+50 " w270 h140 noActivate")
ui.gameSettingsGui.show("x" cfg.guiX+30 " y" cfg.guiY+32 " w495 h182 noActivate")
ui.mainGui.Show("x" cfg.guix " y" cfg.guiy " w562 h214 NoActivate")

ui.loadingProgress.value += 5

if (cfg.startMinimizedEnabled)
	ui.mainGui.hide()


	ui.loadingProgress.value += 5
	monitorResChanged()

ui.MainGuiTabs.Choose(cfg.mainTabList[cfg.activeMainTab])

ui.loadingProgress.value += 5

; initGuiState()


ui.loadingProgress.value += 5
	fadeIn()

try {
	whr := ComObject("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
	whr.Send()
	whr.WaitForResponse()
	iniWrite(whr.ResponseText,cfg.file,"Game","LastIncursion")
}

autoUpdate()

if cfg.topDockEnabled
	ui.topDockPrevTab := ui.mainGuiTabs.text

if ui.incursionDebug
	incursionNotice()
;OnMessage(0x0201, wm_lButtonDown)
	if (cfg.AlwaysOnTopEnabled) {
		ui.MainGui.Opt("+AlwaysOnTop")
		; ui.titleBarButtonGui.Opt("+AlwaysOnTop")
		ui.AfkGui.Opt("+AlwaysOnTop")
		try
			ui.dockBarGui.opt("+alwaysOnTop")
	} else {
		ui.MainGui.Opt("-AlwaysOnTop")
		; ui.titleBarButtonGui.Opt("-AlwaysOnTop")
		ui.AfkGui.Opt("-AlwaysOnTop")	
		try
			ui.dockBarGui.opt("+alwaysOnTop")
	}
	
	
cfg.consoleVisible := !cfg.consoleVisible	

toggleConsole()
;statusBar()
;listhotkeys()
d2AutoGameConfigOverride()
loadScreen(0)
