A_FileVersion := "1.3.9.8"
a_appName := "cacheApp"
if (fileExist("./cacheApp_currentBuild.dat"))
a_fileVersion := fileRead("./cacheApp_currentBuild.dat")
	
;@ahk2Exe-let fileVersion=%a_priorLine~U)^(.+"){1}(.+)".*$~$2% 
;@ahk2Exe-setName cacheApp
;@ahk2Exe-setVersion %a_fileVersion%
;@ahk2Exe-setFileVersion %a_fileVersion%

#requires autoHotkey v2.0+
#singleInstance
#warn All, Off

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

a_cmdLine := DllCall("GetCommandLine", "str")
a_restarted := 
			(inStr(a_cmdLine,"/restart"))
				? true
				: false

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
; loop files, "./img/infogfx/vod/*.png" {
	; flist .= a_loopFilename "`n"
	; fileAppend('fileInstall("./img/infogfx/vod/' a_loopFilename '", "' installDir '/img/infogfx/vod/' a_loopFilename '",1)`n',"./extractAssets.ahk")
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
#include <libVaultCleaner>
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

;if ui.incursionDebug
;	incursionNotice("manualFire")
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
