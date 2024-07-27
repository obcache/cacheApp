A_FileVersion := "1.2.9.2"
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

if not (a_isAdmin or regExMatch(currExe, " /restart(?!\S)"))
{
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

	
a_restarted := 
	(inStr(dllCall("GetCommandLine","Str"),"/restart"))
		? true
		: false
		
installDir 		:= a_myDocuments "\cacheApp"
configFileName 	:= "cacheApp.ini"
themeFileName	:= "cacheApp.themes"

preAutoExec(InstallDir,ConfigFileName)
initTrayMenu()
	d2ActivePanel := 1

; ui.AfkGui 		:= Gui()
dockApp 		:= Object()
workApp			:= Object()
cfg.file 		:= "./" ConfigFileName
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
initGui(&cfg, &ui)
initConsole(&ui)

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
#include <libGuiSystemTab>
#include <libHotkeys>
#include <libRoutines>
#include <libThemeEditor>

debugLog("Interface Initialized")
OnExit(ExitFunc)
debugLog("Console Initialized")

ui.gameTabs.choose(cfg.gameModuleList[cfg.activeGameTab])

createDockBar()
changeGameDDL()
drawAfkOutlines()

try
	guiVis("all",false)

ui.afkGui.show("x" cfg.guiX+45 " y" cfg.guiY+50 " w270 h140 noActivate")
ui.gameSettingsGui.show("x" cfg.guiX+35 " y" cfg.guiY+32 " w495 h180 noActivate")
ui.titleBarButtonGui.Show("w75 h36 NoActivate")
ui.MainGui.Show("x" cfg.guix " y" cfg.guiy " w562 h214 NoActivate")

ui.MainGuiTabs.Choose(cfg.mainTabList[cfg.activeMainTab])

;if (cfg.startMinimizedEnabled)
;winMinimize(ui.mainGui.hwnd)

monitorResChanged()


; initGuiState()
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
		ui.titleBarButtonGui.Opt("+AlwaysOnTop")
		ui.AfkGui.Opt("+AlwaysOnTop")
		try
			ui.dockBarGui.opt("+alwaysOnTop")
	} else {
		ui.MainGui.Opt("-AlwaysOnTop")
		ui.titleBarButtonGui.Opt("-AlwaysOnTop")
		ui.AfkGui.Opt("-AlwaysOnTop")	
		try
			ui.dockBarGui.opt("+alwaysOnTop")
	}
	
