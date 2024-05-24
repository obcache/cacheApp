A_FileVersion := "1.1.8.3"
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

autoUpdate()

winGetPos(&MainGuiX,&MainGuiY,,,ui.mainGui)
if cfg.startMinimizedEnabled
	hideGui()

createDockBar()
changeGameDDL()

winSetTransparent(0,ui.gameSettingsGui)
winSetTransparent(0,ui.afkGui)

drawAfkOutlines()
ui.gameSettingsGui.show("x" mainGuiX+35 " y" mainGuiY+32 " w495 h180 noActivate")
ui.afkGui.show("x" mainGuiX+45 " y" mainGuiY+50 " w270 h140 noActivate")
ui.MainGuiTabs.Choose(cfg.mainTabList[cfg.activeMainTab])
fadeIn()
if !cfg.topDockEnabled
	tabsChanged()
else
ui.topDockPrevTab := ui.mainGuiTabs.text
monitorResChanged()


OnMessage(0x0201, wm_lButtonDown)
