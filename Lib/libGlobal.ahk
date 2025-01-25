#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)){
	Run(A_ScriptDir "/../cacheApp.ahk")
	ExitApp
	Return
}

restoreWin(*) {
	if !cfg.topDockEnabled {
		ui.mainGui.show()
		guiVis(ui.mainGui,true)
		tabsChanged()
		ui.mainGui.opt("-toolWindow")
	}
}

initTrayMenu(*) {
	A_TrayMenu.Delete
	A_TrayMenu.Add
	A_TrayMenu.Add("Show Window", restoreWin)
	A_TrayMenu.Add("Hide Window", HideGui)
	A_TrayMenu.Add("Reset Window Position", ResetWindowPosition)
	; A_TrayMenu.Add("Toggle Dock", DockApps)
	A_TrayMenu.Add()
	A_TrayMenu.Add("Toggle Log Window", toggleConsole)
	A_TrayMenu.Add()
	A_TrayMenu.Add("Exit App", KillMe)
	A_TrayMenu.Default := "Show Window"
	Try
		installLog("Tray Initialized")
}

preAutoExec(InstallDir,ConfigFileName) {
	Global
	data			:= object()
	cfg				:= object()
	ui 				:= object()
	afk				:= object()
	this			:= object()
	setting 		:= object()
	result 			:= object()
	libVaultInit()
	
	if (A_IsCompiled)
	{
		; if !(FileExist("./cacheApp.ini"))
		; {
			; SelectedFolder := DirSelect(,1,"No Installation Found. Select a folder or cancel for default.")
			; if (SelectedFolder)
				; InstallDir := SelectedFolder
		; }
		if StrCompare(A_ScriptDir,InstallDir)
  		{
			createPbConsole("cacheApp Install")
			pbConsole("Running standalone executable, attempting to install")
			installLog("Running standalone executable, attempting to auto-install")
			if !(DirExist(InstallDir))
			{
				pbConsole("Attempting to create install folder")
				installLog("Attempting to create install folder")
				try
				{
					DirCreate(InstallDir)
					SetWorkingDir(InstallDir)
				} catch {
					installLog("Couldn't create install location")
					sleep(1500)
					pbConsole("Cannot Create Folder at the Install Location.")
					pbConsole("Suspect permissions issue with the desired install location")
					pbConsole("`n`nTERMINATING")
					sleep(4000)
					ExitApp
				}
				pbConsole("Successfully created install location at " InstallDir)
				installLog("Successfully created install location at " InstallDir)
				sleep(1000)
			}
			pbConsole("Copying executable to install location")
			installLog("Copying executable to install location")
			sleep(1000)
			try{
				FileCopy(A_ScriptFullPath, InstallDir "/" A_AppName ".exe", true)
			}

			if (FileExist(InstallDir "/cacheApp.ini"))
			{
				msgBoxResult := MsgBox("Previous install detected. `nAttempt to preserve your existing settings?",, "Y/N T300")
				
				switch msgBoxResult {
					case "No": 
					{
						sleep(1000)
						pbConsole("`nReplacing existing configuration files with updated and clean files")
						FileInstall("./cacheApp.ini",InstallDir "/cacheApp.ini",1)
						FileInstall("./cacheApp.themes",InstallDir "/cacheApp.themes",1)
						FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						fileInstall("./cacheApp.db",installDir "/cacheApp.db",1)
					} 
					case "Yes": 
					{
						cfg.ThemeFont1Color := "00FFFF"
						sleep(1000)
						pbConsole("`nPreserving existing configuration may cause issues.")
						pbConsole("If you encounter issues,try installing again, choosing NO.")
						if !(FileExist(InstallDir "/AfkData.csv"))
							FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						if !(FileExist(InstallDir "/cacheApp.themes"))
							FileInstall("./cacheApp.themes",InstallDir "/cacheApp.themes",1)
						if !(fileExist(installDir "/cacheApp.db"))
							fileInstall("./cacheApp.db",installDir "/cacheApp.db",1)
					}
					case "Timeout":
					{
						setTimer () => pbNotify("Timed out waiting for your response.`Attempting to update using your exiting config files.`nIf you encounter issues, re-run the install `nselecting the option to replace your existing files.",5000),-100
						if !fileExist("./cacheApp.ini")
							fileInstall("./cacheApp.ini",installDir "/cacheApp.ini")
						if !(FileExist(InstallDir "/AfkData.csv"))
							FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						if !(FileExist(InstallDir "/cacheApp.themes"))
							FileInstall("./cacheApp.themes",InstallDir "/cacheApp.themes",1)
						if !(fileExist(installDir "/cacheApp.db"))
							fileInstall("./cacheApp.db",installDir "/cacheApp.db",1)	
					}
				}
			} else {
				sleep(1000)
				pbConsole("This seems to be the first time you're running cacheApp.")
				pbConsole("A fresh install to " A_MyDocuments "\cacheApp is being performed.")

				FileInstall("./cacheApp.ini",InstallDir "/cacheApp.ini",1)
				FileInstall("./cacheApp.themes",InstallDir "/cacheApp.themes",1)
				FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
				fileInstall("./cacheApp.db",installDir "/cacheApp.db",1)

			}
			if !(DirExist(InstallDir "\lib"))
			{
				DirCreate(InstallDir "\lib")
			}			
			if !(DirExist(InstallDir "\Img"))
			{
				DirCreate(InstallDir "\Img")
			}
			if !(DirExist(InstallDir "\Img2"))
			{
				DirCreate(InstallDir "\Img2")
			}
			if !(DirExist(InstallDir "\Img2\infogfx"))
			{
				DirCreate(InstallDir "\Img2\infogfx")
			}
			if !(DirExist(InstallDir "\Img2\infogfx\vod"))
			{
				DirCreate(InstallDir "\Img2\infogfx\vod")
			}
			if !(DirExist(InstallDir "\Redist"))
			{
				DirCreate(InstallDir "\Redist")
			}
			installLog("Created Img folder")
			
			if !dirExist(installDir "/img2/infogfx")
				dirCreate(installDir "/img2/infogfx")
			
			if !dirExist(installDir "/img2/infogfx/vod")
				dirCreate(installDir "/img2/infogfx/vod")

			if !dirExist(installDir "/redist/mouseSC")
				dirCreate(installDir "/redist/mouseSC")
			
			fileInstall("./redist/mouseSC_x64.exe",installDir "/redist/mouseSC_x64.exe",1)
			
			FileInstall("./Img/keyboard_key_up.png",InstallDir "/img/keyboard_key_up.png",1)
			FileInstall("./Img/keyboard_key_down.png",InstallDir "/img/keyboard_key_down.png",1)
			FileInstall("./Img/attack_icon.png",InstallDir "/Img/attack_icon.png",true)
			FileInstall("./Img/sleep_icon.png",InstallDir "/Img/sleep_icon.png",true)
			FileInstall("./Img/arrow_left.png",InstallDir "/Img/arrow_left.png",true)
			FileInstall("./Img/arrow_right.png",InstallDir "/Img/arrow_right.png",true)
			FileInstall("./Img/status_stopped.png",InstallDir "/Img/status_stopped.png",true)
			FileInstall("./Img/status_running.png",InstallDir "/Img/status_running.png",true)
			FileInstall("./Img/label_left_trim.png",InstallDir "/Img/label_left_trim.png",true)
			FileInstall("./Img/label_right_trim.png",InstallDir "/Img/label_right_trim.png",true)
			FileInstall("./Img/label_timer_off.png",InstallDir "/Img/label_timer_off.png",true)
			FileInstall("./Img/label_anti_idle_timer.png",InstallDir "/Img/label_anti_idle_timer.png",true)
			FileInstall("./Img/label_infinite_tower.png",InstallDir "/Img/label_infinite_tower.png",true)
			FileInstall("./Img/label_celestial_tower.png",InstallDir "/Img/label_celestial_tower.png",true)			
			FileInstall("./Img/color_swatches.png",InstallDir "/Img/color_swatches.png",1)
			FileInstall("./Img/towerToggle_celestial.png",InstallDir "/Img/towerToggle_celestial.png",1)
			FileInstall("./Img/towerToggle_infinite.png",InstallDir "/Img/towerToggle_infinite.png",1)
			FileInstall("./Img/toggle_off.png",InstallDir "/Img/toggle_off.png",1)
			FileInstall("./Img/toggle_on.png",InstallDir "/Img/toggle_on.png",1)
			FileInstall("./Img/toggle_left.png",InstallDir "/Img/toggle_left.png",1)
			FileInstall("./Img/toggle_right.png",InstallDir "/Img/toggle_right.png",1)
			fileInstall("./img/toggle_vertical_trans_on.png",installDir "/img/toggle_vertical_trans_on.png",1)
			fileInstall("./img/toggle_vertical_trans_off.png",installDir "/img/toggle_vertical_trans_off.png",1)
			FileInstall("./Img/button_update.png",InstallDir "/img/button_update.png",1)
			FileInstall("./Img/button_exit_gaming.png",InstallDir "/img/button_exit_gaming.png",1)
			FileInstall("./Img/button_execute.png",InstallDir "/Img/button_execute.png",true)
			FileInstall("./Img/button_ready.png",InstallDir "/Img/button_ready.png",1)
			FileInstall("./Img/button_on.png",InstallDir "/Img/button_on.png",1)
			FileInstall("./Img/button_plus.png",InstallDir "/Img/button_plus.png",1)
			FileInstall("./Img/button_power.png",InstallDir "/Img/button_power.png",1)
			FileInstall("./Img/button_minus.png",InstallDir "/Img/button_minus.png",1)
			FileInstall("./Img/button_x.png",InstallDir "/Img/button_x.png",1)
			FileInstall("./Img/button_x2.png",InstallDir "/Img/button_x2.png",1)
			FileInstall("./Img/button_change.png",InstallDir "/Img/button_change.png",1)
			FileInstall("./Img/button_select.png",InstallDir "/Img/button_select.png",1)
			FileInstall("./Img/button_set.png",InstallDir "/Img/button_set.png",1)
			FileInstall("./Img/button_add.png",InstallDir "/Img/button_add.png",1)
			FileInstall("./Img/button_remove.png",InstallDir "/Img/button_remove.png",1)
			FileInstall("./Img/button_popout_ready.png",InstallDir "/Img/button_popout_ready.png",1)
			FileInstall("./Img/button_popout_on.png",InstallDir "/Img/button_popout_on.png",1)
			FileInstall("./Img/button_refresh.png",InstallDir "/Img/button_refresh.png",1)
			FileInstall("./Img/button_hide.png",InstallDir "/Img/button_hide.png",1)
			FileInstall("./Img/button_autoFire1_on.png",InstallDir "/Img/button_autoFire1_on.png",1)
			FileInstall("./Img/button_autoFire1_ready.png",InstallDir "/Img/button_autoFire1_ready.png",1)
			FileInstall("./Img/button_autoFire2_on.png",InstallDir "/Img/button_autoFire2_on.png",1)
			FileInstall("./Img/button_autoFire2_ready.png",InstallDir "/Img/button_autoFire2_ready.png",1)			
			FileInstall("./Img/button_autoFire1_disabled.png",InstallDir "/Img/button_autoFire1_disabled.png",1)			
			FileInstall("./Img/button_autoFire2_disabled.png",InstallDir "/Img/button_autoFire2_disabled.png",1)
			FileInstall("./Img/button_swapHwnd.png",InstallDir "/Img/button_swapHwnd.png",1)
			FileInstall("./Img/button_autoFire_ready.png",InstallDir "/Img/button_autoFire_ready.png",1)
			FileInstall("./Img/button_autoFire1_on.png",InstallDir "/Img/button_autoFire1_on.png",1)
			FileInstall("./Img/button_autoFire2_on.png",InstallDir "/Img/button_autoFire2_on.png",1)
			FileInstall("./Img/button_autoClicker_ready.png",InstallDir "/Img/button_autoClicker_ready.png",1)
			FileInstall("./Img/button_swapHwnd_enabled.png",InstallDir "/Img/button_swapHwnd_enabled.png",1)
			FileInstall("./Img/button_swapHwnd_disabled.png",InstallDir "/Img/button_swapHwnd_disabled.png",1)
			FileInstall("./Img/button_autoClicker_on.png",InstallDir "/Img/button_autoClicker_on.png",1)
			FileInstall("./Img/button_quit.png",InstallDir "/Img/button_quit.png",true)
			FileInstall("./Img/button_minimize.png",InstallDir "/Img/button_minimize.png",true)
			FileInstall("./Img/button_tower.png",InstallDir "/Img/button_tower.png",true)
			FileInstall("./Img/button_afk.png",InstallDir "/Img/button_afk.png",true)
			FileInstall("./Img/button_antiIdle.png",InstallDir "/Img/button_antiIdle.png",true)
			FileInstall("./Img/button_tower_ready.png",InstallDir "/Img/button_tower_ready.png",true)
			FileInstall("./Img/button_tower_on.png",InstallDir "/Img/button_tower_on.png",true)
			FileInstall("./Img/button_dockright.png",InstallDir "/Img/button_dockright.png",true)
			FileInstall("./Img/button_afk_on.png",InstallDir "/Img/button_afk_on.png",true)
			FileInstall("./Img/button_antiIdle_ready.png",InstallDir "/Img/button_antiIdle_ready.png",true)
			FileInstall("./Img/button_antiIdle_on.png",InstallDir "/Img/button_antiIdle_on.png",true)
			FileInstall("./Img/button_plus_ready.png",InstallDir "/Img/button_plus_ready.png",true)
			FileInstall("./Img/button_plus_on.png",InstallDir "/Img/button_plus_on.png",true)
			FileInstall("./Img/button_minus_ready.png",InstallDir "/Img/button_minus_ready.png",true)
			FileInstall("./Img/button_minus_on.png",InstallDir "/Img/button_minus_on.png",true)
			FileInstall("./Img/button_OpsDock.png",InstallDir "/Img/button_OpsDock.png",true)
			FileInstall("./Img/button_launchLightGG.png",InstallDir "/Img/button_launchLightGG.png",1)
			FileInstall("./Img/button_launchLightGG_down.png",InstallDir "/Img/button_launchLightGG_down.png",1)
			FileInstall("./Img/button_launchDIM.png",InstallDir "/Img/button_launchDIM.png",1)
			FileInstall("./Img/button_launchDIM_down.png",InstallDir "/Img/button_launchDIM_down.png",1)
			FileInstall("./Img/button_launchBlueberries.png",InstallDir "/Img/button_launchBlueberries.png",1)
			FileInstall("./Img/button_launchBlueberries_down.png",InstallDir "/Img/button_launchBlueBerries_down.png",1)
			fileInstall("./img/button_dockDown_on.png",installDir "/img/button_dockDown_on.png",1)
			fileInstall("./img/button_dockUp_on.png",installDir "/img/button_dockUp_on.png",1)
			FileInstall("./Img/button_dockleft_on.png",InstallDir "/Img/button_dockleft_on.png",1)
			FileInstall("./Img/button_dockright_on.png",InstallDir "/Img/button_dockright_on.png",1)			
			fileInstall("./img/button_dockDown_ready.png",installDir "/img/button_dockDown_ready.png",1)
			fileInstall("./img/button_dockUp_ready.png",installDir "/img/button_dockUp_ready.png",1)
			FileInstall("./Img/button_dockleft_ready.png",InstallDir "/Img/button_dockleft_ready.png",1)
			FileInstall("./Img/button_dockright_ready.png",InstallDir "/Img/button_dockright_ready.png",1)
			FileInstall("./Img/button_dockleft.png",InstallDir "/Img/button_dockleft.png",1)
			FileInstall("./Img/button_dockright.png",InstallDir "/Img/button_dockright.png",1)
			FileInstall("./Img/button_power.png",InstallDir "/Img/button_power.png",1)
			FileInstall("./Img/button_power_on.png",InstallDir "/Img/button_power_on.png",1)
			FileInstall("./Img/button_power_ready.png",InstallDir "/Img/button_power_ready.png",1)
			FileInstall("./Img/button_save_up.png",InstallDir "/Img/button_save_up.png",1)
			FileInstall("./Img/button_up.png",InstallDir "/Img/button_up.png",1)
			FileInstall("./Img/button_down.png",InstallDir "/Img/button_down.png",1)
			FileInstall("./Img/button_help.png",InstallDir "/Img/button_help.png",1)
			FileInstall("./Img/button_help_ready.png",InstallDir "/Img/button_help_ready.png",1)
			FileInstall("./Img/button_help_on.png",InstallDir "/Img/button_help_on.png",1)			
			FileInstall("./Img/button_console_ready.png",InstallDir "/Img/button_console_ready.png",1)
			FileInstall("./Img/button_console_on.png",InstallDir "/Img/button_console_on.png",1)

			fileInstall("./img/icon_running.png",installDir "/img/icon_running.png",1)
			fileInstall("./img/icon_DIM.png",installDir "/img/icon_dim.png",1)
			fileInstall("./img/icon_blueberries.png",installDir "/img/icon_blueberries.png",1)
			fileInstall("./img2/button_vault_up.png",installDir "/img2/button_vault_up.png",1)
			fileInstall("./img2/button_vault_down.png",installDir "/img2/button_vault_down.png",1)
			fileInstall("./img/icon_d2Checklist.png",installDir "/img/icon_d2Checklist.png",1)
			fileInstall("./img/icon_brayTech.png",installDir "/img/icon_brayTech.png",1)
			fileInstall("./img/icon_steeringwheel.png",installDir "/img/icon_steeringwheel.png",1)
			
			FileInstall("./Img/keyboard_key_up.png",InstallDir "/img/keyboard_key_up.png",1)
			FileInstall("./Img/keyboard_key_down.png",InstallDir "/img/keyboard_key_down.png",1)

			fileInstall("./redist/Discord.exe",installDir "/redist/Discord.exe",1)
			fileInstall("./redist/getNir.exe",installDir "/redist/getNir.exe",1)
			fileInstall("./redist/soundVolumeView.exe",installDir "/redist/soundVolumeView.exe",1)
			fileInstall("./redist/sqlite3.dll",installDir "/redist/sqlite3.dll",1)
			fileInstall("./redist/incursionAudio.mp3",installDir "/redist/incursionAudio.mp3",1)
			FileInstall("./lib/ColorChooser.exe",InstallDir "/lib/ColorChooser.exe",1)
			FileInstall("./Redist/nircmd.exe",InstallDir "/Redist/nircmd.exe",1)
			FileInstall("./cacheApp_updater.exe",InstallDir "/cacheApp_updater.exe",1)
			FileInstall("./Img/help.png",InstallDir "/Img/help.png",1)
			FileInstall("./cacheApp_currentBuild.dat",InstallDir "/cacheApp_currentBuild.dat",1)
			
			
			;IMGv2 below
			FileInstall("./img2/button_afk_ready.png",InstallDir "/img2/button_afk_ready.png",true)
			fileInstall("./img2/button_countdown.png",installDir "/img2/button_countdown.png",1)
			fileInstall("./img2/button_dockLeftRight.png",installDir "/img2/button_dockLeftRight.png",1)
			fileInstall("./img2/button_loadouts_ready.png",installDir "/img2/button_loadouts_ready.png",1)
			fileInstall("./img2/button_keyBindTarget.png",installDir "/img2/button_keybindTarget.png",1)
			fileInstall("./img2/button_dock_up.png",installDir "/img2/button_dock_up.png",1)
			fileInstall("./img2/button_power.png",installDir "/img2/button_power.png",1)
			fileInstall("./img2/button_power_down.png",installDir "/img2/button_power_down.png",1)
			fileInstall("./img2/button_quit.png",installDir "/img2/button_quit.png",1)
			fileInstall("./img2/button_crouch.png",installDir "/img2/button_crouch.png",1)
			fileInstall("./img2/checkbox_true.png",installDir "/img2/checkbox_true.png",1)
			fileInstall("./img2/checkbox_false.png",installDir "/img2/checkbox_false.png",1)

			fileInstall("./img2/d2_button_d2Foundry.png",installDir "/img2/d2_button_d2Foundry.png",1)
			fileInstall("./img2/d2_button_d2Foundry_down.png",installDir "/img2/d2_button_d2Foundry_down.png",1)
			fileInstall("./img2/d2_button_brayTech.png",installDir "/img2/d2_button_brayTech.png",1)
			fileInstall("./img2/d2_button_brayTech_down.png",installDir "/img2/d2_button_brayTech_down.png",1)
			fileInstall("./img2/d2_button_DestinyTracker.png",installDir "/img2/d2_button_DestinyTracker.png",1)
			fileInstall("./img2/d2_button_DestinyTracker_down.png",installDir "/img2/d2_button_DestinyTracker_down.png",1)
			fileInstall("./img2/d2_button_dim.png",installDir "/img2/d2_button_dim.png",1)
			fileInstall("./img2/d2_button_dim_down.png",installDir "/img2/d2_button_dim_down.png",1)
			fileInstall("./img2/d2_button_bbgg.png",installDir "/img2/d2_button_bbgg.png",1)
			fileInstall("./img2/d2_button_bbgg_down.png",installDir "/img2/d2_button_bbgg_down.png",1)
			fileInstall("./img2/button_vault_up.png",installDir "/img2/button_vault_up.png",1)
			fileInstall("./img2/button_vault_down.png",installDir "/img2/button_vault_down.png",1)
			fileInstall("./img2/d2_button_d2Checklist.png",installDir "/img2/d2_button_d2Checklist.png",1)
			fileInstall("./img2/d2_button_d2Checklist_down.png",installDir "/img2/d2_button_d2Checklist_down.png",1)
			fileInstall("./img2/d2ClassIconWarlock_on.png",installDir "/img2/d2ClassIconWarlock_on.png",1)
			fileInstall("./img2/d2ClassIconHunter_on.png",installDir "/img2/d2ClassIconHunter_on.png",1)
			fileInstall("./img2/d2ClassIconTitan_on.png",installDir "/img2/d2ClassIconTitan_on.png",1)
			fileInstall("./img2/d2ClassIconWarlock_off.png",installDir "/img2/d2ClassIconWarlock_off.png",1)
			fileInstall("./img2/d2ClassIconHunter_off.png",installDir "/img2/d2ClassIconHunter_off.png",1)
			fileInstall("./img2/d2ClassIconTitan_off.png",installDir "/img2/d2ClassIconTitan_off.png",1)
			fileInstall("./img2/d2CodeMorgeth.png",installDir "/img2/d2CodeMorgeth.png",1)
			
			fileInstall("./img2/infogfx/vod/activate.png", installDir "/img2/infogfx/vod/activate.png",1)
			fileInstall("./img2/infogfx/vod/ascendant.png", installDir "/img2/infogfx/vod/ascendant.png",1)
			fileInstall("./img2/infogfx/vod/black_garden.png", installDir "/img2/infogfx/vod/black_garden.png",1)
			fileInstall("./img2/infogfx/vod/black_heart.png", installDir "/img2/infogfx/vod/black_heart.png",1)
			fileInstall("./img2/infogfx/vod/darkness.png", installDir "/img2/infogfx/vod/darkness.png",1)
			fileInstall("./img2/infogfx/vod/drink.png", installDir "/img2/infogfx/vod/drink.png",1)
			fileInstall("./img2/infogfx/vod/earth.png", installDir "/img2/infogfx/vod/earth.png",1)
			fileInstall("./img2/infogfx/vod/enter.png", installDir "/img2/infogfx/vod/enter.png",1)
			fileInstall("./img2/infogfx/vod/grieve.png", installDir "/img2/infogfx/vod/grieve.png",1)
			fileInstall("./img2/infogfx/vod/guardian.png", installDir "/img2/infogfx/vod/guardian.png",1)
			fileInstall("./img2/infogfx/vod/hive.png", installDir "/img2/infogfx/vod/hive.png",1)
			fileInstall("./img2/infogfx/vod/kill.png", installDir "/img2/infogfx/vod/kill.png",1)
			fileInstall("./img2/infogfx/vod/light.png", installDir "/img2/infogfx/vod/light.png",1)
			fileInstall("./img2/infogfx/vod/love.png", installDir "/img2/infogfx/vod/love.png",1)
			fileInstall("./img2/infogfx/vod/pyramid.png", installDir "/img2/infogfx/vod/pyramid.png",1)
			fileInstall("./img2/infogfx/vod/redacted.png", installDir "/img2/infogfx/vod/redacted.png",1)
			fileInstall("./img2/infogfx/vod/remember.png", installDir "/img2/infogfx/vod/remember.png",1)
			fileInstall("./img2/infogfx/vod/savathun.png", installDir "/img2/infogfx/vod/savathun.png",1)
			fileInstall("./img2/infogfx/vod/scorn.png", installDir "/img2/infogfx/vod/scorn.png",1)
			fileInstall("./img2/infogfx/vod/stop.png", installDir "/img2/infogfx/vod/stop.png",1)
			fileInstall("./img2/infogfx/vod/tower.png", installDir "/img2/infogfx/vod/tower.png",1)
			fileInstall("./img2/infogfx/vod/traveler.png", installDir "/img2/infogfx/vod/traveler.png",1)
			fileInstall("./img2/infogfx/vod/witness.png", installDir "/img2/infogfx/vod/witness.png",1)
			fileInstall("./img2/infogfx/vod/worm.png", installDir "/img2/infogfx/vod/worm.png",1)
			fileInstall("./img2/infogfx/vod/worship.png", installDir "/img2/infogfx/vod/worship.png",1)
			fileInstall("./img2/tab_selected.png", installDir "/img2/tab_selected.png",1)
			fileInstall("./img2/tab_unselected.png", installDir "/img2/tab_unselected.png",1)
			fileInstall("./img2/attack_icon.ico",installDir "/img2/attack_icon.ico",1)
			fileInstall("./img2/handlebar_vertical.png",installDir "/img2/handlebar_vertical.png",true)
			fileInstall("./img2/right_handlebar_vertical.png",installDir "/img2/right_handlebar_vertical.png",true)
			pbConsole("`nINSTALL COMPLETED SUCCESSFULLY!")
			installLog("Copied Assets to: " InstallDir)
			
			fileCreateShortcut(installDir "/cacheApp.exe", A_Desktop "\cacheApp.lnk",installDir,,"CacheApp Gaming Assistant",installDir "/img2/attack_icon.ico")
			fileCreateShortcut(installDir "/cacheApp.exe", A_StartMenu "\Programs\cacheApp.lnk",installDir,,"CacheApp Gaming Assistant",installDir "/img2/attack_icon.ico")
			IniWrite(installDir,installDir "/cacheApp.ini","System","InstallDir")
			Run(InstallDir "\" A_AppName ".exe")
			sleep(4500)
			ExitApp
		
		}
	}
}

createPbConsole(title) {

	transColor := "010203"
	ui.pbConsoleBg := gui()
	ui.pbConsoleBg.backColor := "304030"
	ui.pbConsoleHandle := ui.pbConsoleBg.addPicture("w700 h400 background203020","")
	ui.pbConsoleBg.show("w700 h400 noActivate")
	winSetTransparent(160,ui.pbConsoleBg)
	ui.pbConsole := gui()
	ui.pbConsole.opt("-caption AlwaysOnTop")
	ui.pbConsole.backColor := transColor
	ui.pbConsole.color := transColor
	winSetTransColor(transColor,ui.pbConsole)
	ui.pbConsoleTitle := ui.pbConsole.addText("x8 y4 w700 h35 section center background303530 c859585",title)
	ui.pbConsoleTitle.setFont("s20","Verdana Bold")


	drawOutlineNamed("pbConsoleTitle",ui.pbConsole,6,4,692,35,"253525","202520",2)
	ui.pbConsoleData := ui.pbConsole.addText("xs+10 w680 h380 backgroundTrans cA5C5A5","")
	ui.pbConsoleData.setFont("s16")
	drawOutlineNamed("pbConsoleOutside",ui.pbConsole,2,2,698,398,"355535","355535",2)
	drawOutlineNamed("pbConsoleOutside2",ui.pbConsole,3,3,696,396,"457745","457745",1)
	drawOutlineNamed("pbConsoleOutside3",ui.pbConsole,4,4,694,394,"353535","353535",2)
	ui.pbConsole.show("w700 h400 noActivate")
	ui.pbConsoleBg.opt("-caption owner" ui.pbConsole.hwnd)
}

hidePbConsole(*) {
	guiVis(ui.pbConsole,false)
	guiVis(ui.pbConsoleBg,false)
}

showPbConsole(*) {
	guiVis(ui.pbConsole,false)
	guiVis(ui.pbConsoleBg,false)
}
pbConsole(msg) {
	if !hasProp(ui,"pbConsole")
		createPbConsole("cacheApp Console")
	ui.pbConsoleData.text := msg "`n" ui.pbConsoleData.text
}

testPbConsole() {
	createPbConsole("Test Console")
	loop 40 {
		pbConsole("This is test console message #" a_index)
		sleep(1500)
	}
	ui.pbConsole.destroy()
}

 ;testPbConsole()

FileFound(fileName,destination,fileDescription) {
	source := fileName
	dest := destination
	PreserveData := pbNotify('
	(
	' fileName ' - (' fileDescription ')
	from previous installation found. 
	Would you like to preserve it?
	)'
	,,1)
	
	if !(PreserveData) {
		MsgBox("FileInstall('" source "','" dest "',1)")
	} else {
		pbNotify('
		(
			If you encounter any issues with your saved data
			please re-run this install and answer "No" when
			asked if you would like to preserve the file.
		)'
		,3000)
	}
}
			
installLog(LogMsg) {
 	if !(DirExist(InstallDir "\Logs"))
	{
		DirCreate(InstallDir "\Logs")
		FileAppend(A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] Created Logs Folder`n",InstallDir "/Logs/persist.log")
	}

	FileAppend(A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] " LogMsg "`n",InstallDir "/Logs/persist.log")
}

bail(*) {
	return
}
	
autoUpdate() {		
	runWait("cmd /C start /b /wait ping -n 1 8.8.8.8 > " a_scriptDir "/.tmp",,"Hide")
	if !inStr(fileRead(a_scriptDir "/.tmp"),"100% loss") {
		checkForUpdates(0)
	} else {
		setTimer () => pbNotify("Network Down. Bypassing Auto-Update.",1000),-100
	}
	try
	if fileExist("./.tmp")
		fileDelete("./.tmp")
}	

CheckForUpdates(msg,*) {
	;winSetAlwaysOnTop(0,ui.mainGui.hwnd)
	ui.installedVersion := fileRead("./cacheApp_currentBuild.dat")
	ui.installedVersionText.text := "Installed:`t" substr(ui.installedVersion,1,1) "." substr(ui.installedVersion,2,1) "." substr(ui.installedVersion,3,1) "." substr(ui.installedVersion,4,1)
	ui.installedVersionText.redraw()
	try {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", "https://raw.githubusercontent.com/obcache/cacheApp/main/cacheApp_currentBuild.dat", true)
			whr.Send()
			whr.WaitForResponse()
			ui.latestVersion := whr.ResponseText
			ui.latestVersionText.text := "Available:`t" substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1)
	} catch {
			if(msg != 0) {
				ui.latestVersionText.text := "Available:`t--No Network--"
				notifyOSD("Network down.`nTry again later.",3000)
			ui.latestVersion := ui.installedVersion
		}
	}

	if (ui.installedVersion < ui.latestVersion) {
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.mainGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.titleBarButtonGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.afkGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.gameSettingsGui.hwnd")
		} 
		try {
			winSetAlwaysOnTop(0,"ahk_id ui.gameTabGui.hwnd")
		} 
		sleep(1500)
		runWait("./cacheApp_updater.exe")
	} else {
		if(msg != 0) {
			ui.latestVersionText.text := "Available:`t" substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1)
			notifyOSD("No upgraded needed.`nInstalled: " substr(ui.installedVersion,1,1) "." substr(ui.installedVersion,2,1) "." substr(ui.installedVersion,3,1) "." substr(ui.installedVersion,4,1) "`nAvailable: " substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1),2500)
		}
	}
	
}

cfgLoad(&cfg, &ui) {
	global
	cfg.dbFileName := A_ScriptDir . "\cacheApp.DB"
	data.queryResult		:= array()
	ui.guiH					:= 220  	;430 for Console Mode
	cfg.dockbarMon			:= 1
	ui.incursionNoticeHwnd	:= ""
	ui.exitMenuGui := gui()
	ui.gameWindowsList 		:= array()
	cfg.gameWindowsList 	:= array()
	ui.d2FlyEnabled		:= true
	ui.d2AlwaysSprintPaused 	:= false
	ui.d2IsSprinting			:= false
	ui.d2IsSliding				:= false
	ui.d2IsReloading			:= false
	ui.d2ToggleWalkEnabled	:= false
	ui.clockTimerStarted 	:= false
	ui.clockMode			:= "Clock"
	ui.autoFire1Enabled		:= false
	ui.autoFire2Enabled		:= false
	ui.antiIdle1_enabled 	:= false
	ui.antiIdle2_enabled 	:= false
	ui.antiIdle_enabled 	:= false
	ui.antiIdleInterval		:= 900000
	ui.autoClickerEnabled 	:= false
	ui.previousTab			:= ""
	ui.activeTab			:= ""
	ui.lastWindowHwnd		:= 0
	ui.colorChanged 		:= false 
	ui.guiCollapsed			:= false
	ui.afkDocked 			:= false
	ui.afkAnchoredToGui 	:= true
	ui.afkEnabled 			:= false
	ui.towerEnabled 		:= false
	ui.helpActive			:= false
	ui.dockApp_enabled		:= false
	ui.themeResetScheduled 	:= false
	ui.win1Hwnd				:= ""
	ui.win2Hwnd				:= ""
	ui.pipEnabled			:= false
	ui.pauseAlwaysRun		:= false
	ui.inGameChat			:= false
	ui.reloading			:= false
	ui.gameWindowFound		:= false
	ui.profileList				:= array()
	ui.profileListStr			:= ""
	ui.waitingForPrompt			:= true
	ui.notifyResponse			:= false
	ui.fastShutdown				:= false
	win1afk 					:= object()
	win2afk						:= object()
	win1afk.steps				:= array()
	win2afk.steps				:= array()
	win1afk.nextStep			:= ""
	win2afk.nextStep 			:= ""
	win1afk.waits 				:= array()
	win2afk.waits				:= array()
	win1afk.nextWait			:= ""
	win2afk.nextWait			:= ""
	win1afk.waiting				:= false
	win2afk.waiting				:= false
	win1afk.currStepNum			:= ""
	win2afk.currStepNum 		:= ""
	ui.clearClockAlert			:= false
	ui.themeEditorVisible		:= false
	cfg.forcedTooltipControls	:= "Win1,Win2,Win3"
	cfg.gameModuleList			:= strSplit(iniRead(cfg.file,"Game","GameModuleList","Destiny2,World//Zero"),",")
	cfg.gameList				:= StrSplit(IniRead(cfg.file,"Game","GameList","Roblox,Rocket League"),",")
	cfg.mainTabList				:= strSplit(IniRead(cfg.file,"Interface","MainTabList"," 1_GAME , 2_SYS , 3_AFK , 4 App Dock 4 , 5 Setup 5 "),",")
	cfg.mainGui					:= IniRead(cfg.file,"System","MainGui","MainGui")
	cfg.autoStartEnabled 		:= iniRead(cfg.file,"System","AutoStartEnabled",false)
	cfg.confirmExitEnabled		:= iniRead(cfg.file,"System","ConfirmExit",false)
	cfg.excludedApps			:= IniRead(cfg.file,"System","ExcludedApps","Windows10Universal.exe,explorer.exe,RobloxPlayerInstaller.exe,RobloxPlayerLauncher.exe,Chrome.exe,msedge.exe")
	cfg.MainGui					:= IniRead(cfg.file,"System","MainGui","MainGui")
	cfg.MainScriptName			:= IniRead(cfg.file,"System","MainScriptName", "cacheApp")
	cfg.debugEnabled			:= IniRead(cfg.file,"System","DebugEnabled",false)
	cfg.consoleVisible			:= IniRead(cfg.file,"System","consoleVisible",false)
	cfg.ToolTipsEnabled 		:= IniRead(cfg.file,"System","ToolTipsEnabled",true)
	cfg.monitorRes				:= IniRead(cfg.file,"System","MonitorResolution","Auto")
	cfg.disabledTabs 			:= iniRead(cfg.file,"System","DisabledTabs","Audio,Editor")
	cfg.listDataFile			:= iniRead(cfg.file,"System","ListDataFile","./listData.ini")
	cfg.toggleOn				:= IniRead(cfg.file,"Interface","ToggleOnImage","./Img/toggle_on.png")
	cfg.toggleOff				:= IniRead(cfg.file,"Interface","ToggleOffImage","./Img/toggle_off.png")
	cfg.activeMainTab			:= IniRead(cfg.file,"Interface","activeMainTab",1)
	cfg.activeGameTab  			:= IniRead(cfg.file,"Interface","ActiveGameTab",1)
	cfg.activeEditorTab			:= iniRead(cfg.file,"Interface","ActiveEditorTab",1)
	cfg.AlwaysOnTopEnabled		:= IniRead(cfg.file,"Interface","AlwaysOnTopEnabled",true)
	cfg.AnimationsEnabled		:= IniRead(cfg.file,"Interface","AnimationsEnabled",true)
	cfg.ColorPickerEnabled 		:= IniRead(cfg.file,"Interface","ColorPickerEnabled",true)
	cfg.GuiX 					:= IniRead(cfg.file,"Interface","GuiX",PrimaryWorkAreaLeft + 200)
	cfg.GuiY 					:= IniRead(cfg.file,"Interface","GuiY",PrimaryWorkAreaTop + 200)
	cfg.GuiW					:= IniRead(cfg.file,"Interface","GuiW",545)
	cfg.GuiH					:= IniRead(cfg.file,"Interface","GuiH",210)
	cfg.pushNotificationsEnabled := iniRead(cfg.file,"Interface","PushNotifications",false)
	

	cfg.AfkX					:= IniRead(cfg.file,"Interface","AfkX",cfg.GuiX+10)
	cfg.AfkY					:= IniRead(cfg.file,"Interface","AfkY",cfg.GuiY+35)
	cfg.AfkSnapEnabled			:= IniRead(cfg.file,"Interface","AfkSnapEnabled",false)
	cfg.GuiSnapEnabled			:= IniRead(cfg.file,"Interface","GuiSnapEnabled",true)
	cfg.topDockEnabled 			:= iniRead(cfg.file,"Interface","TopDockEnabled",false)
				
	cfg.displaySizeAuto			:= iniRead(cfg.file,"Game","DisplaySizeAuto",true)
	cfg.AutoDetectGame			:= IniRead(cfg.file,"Game","AutoDetectGame",true)
	cfg.excludedProcesses		:= IniRead(cfg.file,"Game","ExcludedProcesses",true)
	cfg.game					:= IniRead(cfg.file,"Game","Game","2")
	cfg.HwndSwapEnabled			:= IniRead(cfg.file,"Game","HwndSwapEnabled",false)
	ui.win1enabled 				:= IniRead(cfg.file,"Game","Win1Enabled",true)
	ui.win2enabled 				:= IniRead(cfg.file,"Game","Win2Enabled",true)	
	cfg.win1Disabled 			:= IniRead(cfg.file,"Game","win1disabled",false)
	cfg.win2Disabled 			:= IniRead(cfg.file,"Game","win2disabled",false)
	cfg.w0DualPerkSwapEnabled	:= IniRead(cfg.file,"Game","w0DualPerkSwap",true)
	cfg.AfkDataFile				:= IniRead(cfg.file,"AFK","AfkDataFile","./AfkData.csv")
	cfg.Profile					:= IniRead(cfg.file,"AFK","Profile","1")
	cfg.win1Class				:= IniRead(cfg.file,"AFK","Win1Class",1)
	cfg.win2Class				:= IniRead(cfg.file,"AFK","Win2Class",1)
	cfg.antiIdleWin1Cmd			:= IniRead(cfg.file,"AFK","AntiIdleWin1Cmd","5")
	cfg.antiIdleWin2Cmd			:= IniRead(cfg.file,"AFK","AntiIdleWin2Cmd","5")
	cfg.towerInterval			:= iniRead(cfg.file,"AFK","TowerInterval","270000")
	cfg.antiIdleInterval		:= IniRead(cfg.file,"AFK","AntiIdleInterval","1250")
	cfg.SilentIdleEnabled 		:= IniRead(cfg.file,"AFK","SilentIdleEnabled",true)
	cfg.AutoClickerSpeed 		:= IniRead(cfg.file,"AFK","AutoClickerSpeed",50)
	cfg.CelestialTowerEnabled	:= IniRead(cfg.file,"AFK","CelestialTowerEnabled",false)
	cfg.AppDockMonitor 			:= IniRead(cfg.file,"AppDock","AppDockMonitor","1")	
	if cfg.appDockMonitor > monitorGetCount()
		cfg.appDockMonitor := 1
	cfg.app1filename			:= IniRead(cfg.file,"AppDock","app1filename","")
	cfg.app1path				:= IniRead(cfg.file,"AppDock","app1path","")
	cfg.app2filename			:= IniRead(cfg.file,"AppDock","app2filename","")
	cfg.app2path				:= IniRead(cfg.file,"AppDock","app2path","")
	
	cfg.DockHeight 				:= IniRead(cfg.file,"AppDock","DockHeight","240")
	cfg.DockMarginSize 			:= IniRead(cfg.file,"AppDock","DockMarginSize","8")
	cfg.UndockedX 				:= IniRead(cfg.file,"AppDock","UndockedX","150")
	cfg.UndockedY 				:= IniRead(cfg.file,"AppDock","UndockedY","150")
	cfg.UndockedW 				:= IniRead(cfg.file,"AppDock","UndockedW","1600")
	cfg.UndockedH 				:= IniRead(cfg.file,"AppDock","UndockedH","1000")

	cfg.allowedAudioDevices		:= iniRead(cfg.file,"Audio","AllowedAudioOutput","")
	cfg.gameAudioEnabled		:= IniRead(cfg.file,"audio","gameAudioEnabled","false")
	cfg.MicName					:= IniRead(cfg.file,"audio","MicName","Yeti")
	cfg.SpeakerName				:= IniRead(cfg.file,"audio","SpeakerName","S2MASTER")
	cfg.HeadsetName				:= IniRead(cfg.file,"audio","HeadsetName","G432")
	cfg.MicVolume				:= IniRead(cfg.file,"audio","MicVolume",".80")
	cfg.SpeakerVolume	 		:= IniRead(cfg.file,"audio","SpeakerVolume",".50")
	cfg.HeadsetVolume			:= IniRead(cfg.file,"audio","HeadsetVolume",".80")
	cfg.Mode					:= IniRead(cfg.file,"audio","Mode","1")

	cfg.Theme					:= IniRead(cfg.file,"Interface","Theme","Modern Class")
	cfg.ThemeList				:= StrSplit(IniRead(cfg.themeFile,"Interface","ThemeList","Modern Class,Cold Steel,Militarized,Custom"),",")
	cfg.ThemeBackgroundColor	:= IniRead(cfg.themeFile,cfg.Theme,"ThemeBackgroundColor","414141")
	cfg.ThemeFont1Color			:= IniRead(cfg.themeFile,cfg.Theme,"ThemeFont1Color","1FFFF0")
	cfg.ThemeFont2Color			:= IniRead(cfg.themeFile,cfg.Theme,"ThemeFont2Color","FBD58E")
	cfg.ThemeFont3Color			:= IniRead(cfg.themeFile,cfg.Theme,"ThemeFont3Color","1FFFF0")
	cfg.ThemeFont4Color			:= IniRead(cfg.themeFile,cfg.Theme,"ThemeFont4Color","FBD58E")
	cfg.ThemeBright2Color		:= IniRead(cfg.themeFile,cfg.Theme,"ThemeBright2Color","C0C0C0")
	cfg.ThemeBright1Color		:= IniRead(cfg.themeFile,cfg.Theme,"ThemeBright1Color","FFFFFF")
	cfg.ThemeDark2Color			:= IniRead(cfg.themeFile,cfg.Theme,"ThemeDark2Color","C0C0C0")
	cfg.ThemeDark1Color			:= IniRead(cfg.themeFile,cfg.Theme,"ThemeDark1Color","FFFFFF")
	cfg.ThemeBorderLightColor	:= IniRead(cfg.themeFile,cfg.Theme,"ThemeBorderLightColor","888888")
	cfg.ThemeBorderDarkColor	:= IniRead(cfg.themeFile,cfg.Theme,"ThemeBorderDarkColor","333333")
	cfg.ThemePanel1Color		:= IniRead(cfg.themeFile,cfg.Theme,"ThemePanel1Color","204040")
	cfg.ThemePanel2Color		:= IniRead(cfg.themeFile,cfg.Theme,"ThemePanel2Color","804001")
	cfg.ThemePanel3Color		:= IniRead(cfg.themeFile,cfg.Theme,"ThemePanel3Color","204040")
	cfg.ThemePanel4Color		:= IniRead(cfg.themeFile,cfg.Theme,"ThemePanel4Color","804001")
	cfg.ThemeEditboxColor		:= IniRead(cfg.themeFile,cfg.Theme,"ThemeEditboxColor","292929")
	cfg.ThemeProgressColor		:= IniRead(cfg.themeFile,cfg.Theme,"ThemeProgressColor","292929")
	cfg.ThemeDisabledColor		:= IniRead(cfg.themeFile,cfg.Theme,"ThemeDisabledColor","212121")
	cfg.ThemeButtonAlertColor	:= IniRead(cfg.themeFile,cfg.Theme,"ThemeButtonAlertColor","3C3C3C")
	cfg.ThemeButtonOnColor		:= IniRead(cfg.themeFile,cfg.Theme,"ThemeButtonOnColor","FF01FF")
	cfg.ThemeButtonReadyColor	:= IniRead(cfg.themeFile,cfg.Theme,"ThemeButtonReadyColor","1FFFF0")
	
	cfg.holdToCrouchEnabled 	:= IniRead(cfg.file,"game","HoldToCrouch",true)
	cfg.cs2HoldToScopeEnabled	:= IniRead(cfg.file,"game","cs2HoldToScopeEnabled",true)

	cfg.d2AppPauseKey			:= iniRead(cfg.file,"Game","d2AppPauseKey","<UNSET>")
	cfg.d2AppPaused				:= iniRead(cfg.file,"Game","d2AppPaused",false)
	cfg.d2AlwaysRunEnabled		:= iniRead(cfg.file,"Game","d2AlwaysRunEnabled",false)
	cfg.d2AppSwordFlyKey		:= iniRead(cfg.file,"Game","d2AppSwordFlyKey","<UNSET>")
	cfg.d2AppLoadoutKey			:= IniRead(cfg.file,"Game","d2AppLoadoutKey","<UNSET>")
	cfg.d2AppLoadoutMultiplier	:= iniRead(cfg.file,"Game","d2AppLoadoutMultiplier",1)
	cfg.d2AppToggleSprintKey	:= IniRead(cfg.file,"Game","d2AppToggleSprintKey","<UNSET>")
	cfg.d2AppReloadKey			:= IniRead(cfg.file,"Game","d2AppReloadKey","<UNSET>")
	cfg.d2AppHoldToCrouchKey	:= IniRead(cfg.file,"Game","d2AppHoldToCrouchKey","<UNSET>")
	cfg.d2GameHoldToCrouchKey	:= iniRead(cfg.file,"Game","d2GameHoldToCrouchKey","LControl")
	cfg.d2GameToggleSprintKey	:= IniRead(cfg.file,"Game","d2GameToggleSprintKey","<UNSET>")
	cfg.d2GameReloadKey			:= IniRead(cfg.file,"Game","d2GameReloadKey","<UNSET>")
	cfg.d2GameGrenadeKey			:= IniRead(cfg.file,"Game","d2GameGrenadeKey","<UNSET>")
	cfg.d2GameSuperKey			:= IniRead(cfg.file,"Game","d2GameSuperKey","<UNSET>")
	cfg.d2CharacterClass		:= iniRead(cfg.file,"Game","d2CharacterClass","1")
	cfg.d2AutoGameConfigEnabled := iniRead(cfg.file,"Game","d2AutoGameConfigEnabled",true)
	cfg.SLBHopKey				:= iniRead(cfg.file,"Game","ShatterLineBunnyHopKey","<UNSET>")
	runWait("./redist/mouseSC_x64.exe /verticalScroll:1",,"hide")
	
}


WriteConfig() {
	Global
	tmpGameList := ""
	iniWrite(cfg.displaySizeAuto,cfg.file,"Game","DisplaySizeAuto")
	iniWrite(cfg.excludedProcesses,cfg.file,"Game","ExcludedProcesses")
	IniWrite(cfg.autoDetectGame,cfg.file,"Game","AutoDetectGame")
	iniWrite(cfg.excludedApps,cfg.file,"System","ExcludedApps")
	IniWrite(cfg.game,cfg.file,"Game","Game")
	iniWrite(cfg.listDataFile,cfg.file,"System","ListDataFile")
	IniWrite(cfg.mainScriptName,cfg.file,"System","ScriptName")
	IniWrite(cfg.mainGui,cfg.file,"System","MainGui")
	iniWrite(cfg.disabledTabs,cfg.file,"System","DisabledTabs")
	iniWrite(cfg.confirmExitEnabled,cfg.file,"System","ConfirmExit")
	IniWrite(ui.monitorResDDL.value,cfg.file,"System","MonitorResolution")
	IniWrite(arr2str(cfg.gameModuleList),cfg.file,"Game","GameModuleList")
	IniWrite(arr2str(cfg.gameList),cfg.file,"Game","GameList")
	IniWrite(ui.gameDDL.value,cfg.file,"Game","Game")
	IniWrite(ui.win1enabled,cfg.file,"Game","Win1Enabled")
	IniWrite(ui.win2enabled,cfg.file,"Game","Win2Enabled")	
	IniWrite(cfg.win1disabled,cfg.file,"Game","win1disabled")
	IniWrite(cfg.win2disabled,cfg.file,"Game","win2disabled")
	IniWrite(cfg.hwndSwapEnabled,cfg.file,"Game","HwndSwapEnabled")
	IniWrite(cfg.cs2HoldToScopeEnabled,cfg.file,"Game","cs2HoldToScope")
	IniWrite(cfg.AppDockMonitor,cfg.file,"AppDock","AppDockMonitor")
	IniWrite(cfg.dockHeight,cfg.file,"AppDock","DockHeight")
	IniWrite(cfg.dockMarginSize,cfg.file,"AppDock","DockMarginSize")

	IniWrite(cfg.undockedX,cfg.file,"AppDock","UndockedX")
	IniWrite(cfg.undockedY,cfg.file,"AppDock","UndockedY")
	IniWrite(cfg.undockedW,cfg.file,"AppDock","UndockedW")
	IniWrite(cfg.undockedH,cfg.file,"AppDock","UndockedH")

	IniWrite(cfg.gameAudioEnabled,cfg.file,"Audio","gameAudioEnabled")
	IniWrite(cfg.micName,cfg.file,"Audio","Mic")
	IniWrite(cfg.speakerName,cfg.file,"Audio","Speaker")
	IniWrite(cfg.headsetName,cfg.file,"Audio","Headset")
	IniWrite(cfg.micVolume,cfg.file,"Audio","MicVolume")
	IniWrite(cfg.speakerVolume,cfg.file,"Audio","SpeakerVolume")
	IniWrite(cfg.headsetVolume,cfg.file,"Audio","HeadsetVolume")
	IniWrite(cfg.mode,cfg.file,"Audio","Mode")

	if (ui.themeResetScheduled) {
		FileDelete(cfg.themeFile)
		FileAppend(ui.defaultThemes,cfg.themeFile)
		ui.themeResetSchedule := false
	} else {
		IniWrite(ui.themeDDL.text,cfg.file,"Interface","Theme")
		IniWrite(arr2str(cfg.themeList),cfg.themeFile,"Interface","ThemeList")
		IniWrite(cfg.themeBright2Color,cfg.themeFile,"Custom","ThemeBright2Color")
		IniWrite(cfg.themeBright1Color,cfg.themeFile,"Custom","ThemeBright1Color")
		IniWrite(cfg.themeDark2Color,cfg.themeFile,"Custom","ThemeDark2Color")
		IniWrite(cfg.themeDark1Color,cfg.themeFile,"Custom","ThemeDark1Color")
		IniWrite(cfg.themeBorderDarkColor,cfg.themeFile,"Custom","ThemeBorderDarkColor")
		IniWrite(cfg.themeBorderLightColor,cfg.themeFile,"Custom","ThemeBorderLightColor")
		IniWrite(cfg.themeBackgroundColor,cfg.themeFile,"Custom","ThemeBackgroundColor")
		IniWrite(cfg.themeFont1Color,cfg.themeFile,"Custom","ThemeFont1Color")
		IniWrite(cfg.themeFont2Color,cfg.themeFile,"Custom","ThemeFont2Color")
		IniWrite(cfg.themeFont3Color,cfg.themeFile,"Custom","ThemeFont3Color")
		IniWrite(cfg.themeFont4Color,cfg.themeFile,"Custom","ThemeFont4Color")
		IniWrite(cfg.themePanel1Color,cfg.themeFile,"Custom","ThemePanel1Color")
		IniWrite(cfg.themePanel3Color,cfg.themeFile,"Custom","ThemePanel3Color")
		IniWrite(cfg.themePanel2Color,cfg.themeFile,"Custom","ThemePanel2Color")
		IniWrite(cfg.themePanel4Color,cfg.themeFile,"Custom","ThemePanel4Color")
		IniWrite(cfg.themeEditboxColor,cfg.themeFile,"Custom","ThemeEditboxColor")
		IniWrite(cfg.themeProgressColor,cfg.themeFile,"Custom","ThemeProgressColor")
		IniWrite(cfg.themeDisabledColor,cfg.themeFile,"Custom","ThemeDisabledColor")
		IniWrite(cfg.themeButtonOnColor,cfg.themeFile,"Custom","ThemeButtonOnColor")
		IniWrite(cfg.themeButtonReadyColor,cfg.themeFile,"Custom","ThemeButtonReadyColor")
		IniWrite(cfg.themeButtonAlertColor,cfg.themeFile,"Custom","ThemeButtonAlertColor")
		IniWrite(cfg.activeMainTab,cfg.file,"Interface","ActiveMainTab")
		IniWrite(cfg.activeGameTab,cfg.file,"Interface","ActiveGameTab")
		iniWrite(cfg.activeEditorTab,cfg.file,"Interface","ActiveEditorTab")
		iniWrite(cfg.topDockEnabled,cfg.file,"Interface","TopDockEnabled")
		

		iniWrite(cfg.d2AppPauseKey,cfg.file,"Game","d2AppPauseKey")
		iniWrite(cfg.d2AppPaused,cfg.file,"Game","d2AppPaused")
		IniWrite(cfg.d2AppHoldToCrouchKey,cfg.file,"Game","d2AppHoldToCrouchKey")
		IniWrite(cfg.d2AppLoadoutKey,cfg.file,"Game","d2AppLoadoutKey")
		iniWrite(cfg.d2AppSwordFlyKey,cfg.file,"Game","d2AppSwordFlyKey")
		iniWrite(cfg.d2AppLoadoutMultiplier,cfg.file,"Game","d2AppLoadoutMultiplier")
		IniWrite(cfg.d2AppToggleSprintKey,cfg.file,"Game","d2AppToggleSprintKey")
		IniWrite(cfg.d2AppReloadKey,cfg.file,"Game","d2AppReloadKey")
		IniWrite(cfg.d2AppHoldToCrouchKey,cfg.file,"Game","d2AppHoldToCrouchKey")
		IniWrite(cfg.d2GameToggleSprintKey,cfg.file,"Game","d2GameToggleSprintKey")
		IniWrite(cfg.d2GameReloadKey,cfg.file,"Game","d2GameReloadKey")
		IniWrite(cfg.d2GameGrenadeKey,cfg.file,"Game","d2GameGrenadeKey")
		IniWrite(cfg.d2GameSuperKey,cfg.file,"Game","d2GameSuperKey")
		iniWrite(cfg.d2CharacterClass,cfg.file,"Game","d2CharacterClass")
		iniWrite(cfg.d2AutoGameConfigEnabled,cfg.file,"Game","d2AutoGameConfigEnabled")
		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords1920x1080[a_index] ","
		}
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords1920x1080")

		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords3440x1440[a_index] ","
		}		
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords3440x1440")

		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords1920x1200[a_index] ","
		}
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords1920x1200")
		
		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords2560x1440[a_index] ","
		}		
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords2560x1440")

		ui.mainTabListString := ""
		loop cfg.mainTabList.length {
			ui.mainTabListString .= cfg.mainTabList[a_index] ','
		}
		IniWrite(rtrim(ui.mainTabListString,","),cfg.file,"Interface","MainTabList")
	}
	
		if (ui.AfkDocked) {
			cfg.GuiX := ui.GuiPrevX
			cfg.GuiY := ui.GuiPrevY
		} 
		
		try {
			winGetPos(&guiX,&guiY,,,ui.mainGui.hwnd)
			cfg.guiX := guiX
			cfg.guiY := GuiY
		} catch {
			cfg.GuiX := 200
			cfg.GuiY := 200
		}

	IniWrite(cfg.GuiX,cfg.file,"Interface","GuiX")
	IniWrite(cfg.GuiY,cfg.file,"Interface","GuiY")
	IniWrite(cfg.AfkX,cfg.file,"Interface","AfkX")
	IniWrite(cfg.AfkY,cfg.file,"Interface","AfkY")
	IniWrite(cfg.AfkSnapEnabled,cfg.file,"Interface","AfkSnapEnabled")
	IniWrite(cfg.GuiSnapEnabled,cfg.file,"Interface","GuiSnapEnabled")
	IniWrite(cfg.toggleOn,cfg.file,"Interface","ToggleOnImage")
	IniWrite(cfg.toggleOff,cfg.file,"Interface","ToggleOffImage")
	IniWrite(cfg.ConsoleVisible,cfg.file,"System","ConsoleVisible")
	IniWrite(cfg.consoleVisible,cfg.file,"System","consoleVisible")
	IniWrite(cfg.AlwaysOnTopEnabled,cfg.file,"Interface","AlwaysOnTopEnabled")
	IniWrite(cfg.ColorPickerEnabled,cfg.file,"Interface","ColorPickerEnabled")
	iniWrite(cfg.autoStartEnabled,cfg.file,"System","AutoStartEnabled")
	IniWrite(cfg.AfkDataFile,cfg.file,"AFK","AfkDataFile")
	IniWrite(cfg.SilentIdleEnabled,cfg.file,"AFK","SilentIdleEnabled")
	iniWrite(cfg.towerInterval,cfg.file,"AFK","TowerInterval")
	iniWrite(cfg.CelestialTowerEnabled,cfg.file,"AFK","CelestialTowerEnabled")
	IniWrite(ui.AutoClickerSpeedSlider.Value,cfg.file,"AFK","AutoClickerSpeed")
	IniWrite(ui.win1classDDL.value,cfg.file,"AFK","Win1Class")

	if (ui.win2ClassDDL.Text != "N/A")
		IniWrite(ui.win2classDDL.value,cfg.file,"AFK","Win2Class")
	if !(DirExist("./Logs"))
	{
		DirCreate("./Logs")
	}
	
	; if (cfg.ConsoleVisible)
	; {
		; FileAppend(ui.gvConsole.Value,"./Logs/gvLog_" A_YYYY A_MM A_DD A_Hour A_Min A_Sec ".txt")
	; }
	ui.MainGui.Destroy()
	BlockInput("Off")
}

adjustPos(*) {
	cfg.guiX := iniRead(cfg.file,"interface","GuiX",200)
	cfg.guiY := iniRead(cfg.file,"interface","GuiY",200)
	lowestHorz := 0
	highestHorz := 0
	lowestVert :=0
	highestVert := 0
	loop monitorGetCount() {
		monitorGet(a_index,&ml,&mt,&mr,&mb)
		if lowestHorz > ml
			lowestHorz := ml
		if highestHorz < mr
			highestHorz := mr
		if lowestVert > mt
			lowestVert := mt
		if highestVert < mb
			highestVert := mb
	}		
	if (cfg.GuiX < lowestHorz) || (cfg.guiX+550 > highestHorz) {
		cfg.GuiX := 200
		cfg.GuiY := 200
	}
	if (cfg.GuiY < lowestVert) || (cfg.guiY+220 > highestVert) {
		cfg.GuiX := 200
		cfg.GuiY := 200
	}
	iniWrite(cfg.GuiX,cfg.file,"interface","GuiX")
	iniWrite(cfg.GuiY,cfg.file,"interface","GuiY")
}

runApp(appName) {
	global
	For app in ComObject('Shell.Application').NameSpace('shell:AppsFolder').Items
	(app.Name = appName) && RunWait('explorer shell:appsFolder\' app.Path,,,&appPID)
}

getClick(&clickX,&clickY,&activeWindow) {
	DialogBox("Click to get information about a pixel")
	Sleep(750)
	CoordMode("Mouse","Client")
	MonitorSelectStatus := KeyWait("LButton", "D T15")
	DialogBoxClose()
	if (MonitorSelectStatus = 0) {	
		MsgBox("A monitor was not selected in time.`nPlease try again.")
		Return
	} else {
		MouseGetPos(&clickX,&clickY,&pixelColor,&activeWindow)
		pixelColor := PixelGetColor(clickX,clickY)
		activeWindow := winWait("A")
		fileAppend("Window: [" activeWindow "] " WinGetTitle("ahk_id " activeWindow) " `nx: " clickX " y: " clickY "`nColor: " pixelColor "`n`n", "./capturedPixels.txt")
		debugLog("Window: [" activeWindow "] " WinGetTitle("ahk_id " activeWindow) ", x: " clickX " y: " clickY ", Color: " pixelColor)
	}
}

GetWinNumber() {
	 Try {
		debugLog("GetWinNumber Comparing " ui.Win1Hwnd " and " ui.Win2Hwnd " to " WinExist("A"))
		Return (ui.Win1Hwnd == WinExist("A")) ? 1 : (ui.Win2Hwnd == WinExist("A") ? 2 : 0)
	 } Catch {
		 Return 0
	 }
}

debugLog(LogMsg) {
	Global
	ui.gvConsole.Add([A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] " LogMsg])
	PostMessage("0x115",7,,,"ahk_id " ui.gvConsole.hwnd) 
}


DialogBox(Msg,Alignment := "Center") {
	Global
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.ThemePanel1Color  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s16")  ; Set a large font size (32-point).
	ui.notifyMsg := ui.notifyGui.AddText("c" cfg.ThemeFont1Color " " Alignment " BackgroundTrans",Msg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	drawOutlineNotifyGui(1,1,w,h,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,1)
	drawOutlineNotifyGui(2,2,w-2,h-2,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)
	
	Transparency := 0
	guiVis("all",false)	
	While Transparency < 253 {
		Transparency += 5
		WinSetTransparent(Round(Transparency),ui.notifyGui)
	}
}


DialogBoxClose(*)
{
	Global
	Try
		ui.notifyGui.Destroy()
	guiVis("all",true)
	tabsChanged()
}

NotifyOSD(NotifyMsg,Duration := 10,Alignment := "Left",YN := "")
{
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
		
	Transparent := 250
	try
		ui.notifyGui.Destroy()
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.ThemePanel1Color  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s16")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c" cfg.ThemeFont1Color " " Alignment " BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	guiVis(ui.notifyGui,true)
	drawOutlineNotifyGui(1,1,w,h,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,1)
	drawOutlineNotifyGui(2,2,w-2,h-2,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)
	
	if (YN) {
		ui.notifyGui.AddText("xs hidden")
		ui.notifyYesButton := ui.notifyGui.AddPicture("ys x30 y30","./Img/button_yes.png")
		ui.notifyYesButton.OnEvent("Click",notifyConfirm)
		ui.notifyNoButton := ui.notifyGui.AddPicture("ys","/Img/button_no.png")
		ui.notifyNoButton.OnEvent("Click",notifyCancel)
		SetTimer(waitOSD,-10000)
	} else {
		ui.Transparent := 250
		try {
			WinSetTransparent(ui.Transparent,ui.notifyGui)
			setTimer () => (sleep(duration),fadeOSD()),-100
		}
	}

	waitOSD() {
	
		ui.notifyGui.destroy()
		notifyOSD("Timed out waiting for response.`nPlease try your action again",-1000)
	
	}



}

fadeOSD() {
	ui.transparent := 250
	While ui.Transparent > 10 { 	
	
		try
			WinSetTransparent(ui.Transparent,ui.notifyGui)
		ui.Transparent -= 3
		Sleep(1)
	}
	try
		guiVis(ui.notifyGui,false)
	
	ui.Transparent := ""
	
}

pbNotify(NotifyMsg,Duration := 10,YN := "",confirmCustomScript:="notifyConfirm",cancelCustomScript:="notifyCancel") {
	Transparent := 250
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := "353535" ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s16")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c00FFFF center BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	
	if (YN) {
		ui.notifyGui.AddText("xs hidden")
		ui.notifyGui.SetFont("s10")
		ui.notifyYesButton := ui.notifyGui.AddButton("ys section w60 h25","Proceed")
		ui.notifyYesButton.OnEvent("Click",%confirmCustomScript%)
		ui.notifyNoButton := ui.notifyGui.AddButton("xs w60 h25","Cancel")
		ui.notifyNoButton.OnEvent("Click",%cancelCustomScript%)
	}
	
	ui.notifyGui.Show("AutoSize")
	winGetPos(&x,&y,&w,&h,ui.notifyGui.hwnd)
	drawOutline(ui.notifyGui,0,0,w,h,"202020","808080",3)
	drawOutline(ui.notifyGui,5,5,w-10,h-10,"BBBBBB","DDDDDD",2)
	canProceed:=""
	timeout:=0
	if (YN) {
		while timeout < 90 && ui.waitingForPrompt {
				timeout+=1
				sleep(500)
		}
		ui.waitingForPrompt:=true
		if timeout > 89 {
			notifyOSD("Timed out waiting for response. Cancelling")
			setTimer () => (fadeOSD()),-1
			Exit
		} else {
			if !ui.notifyResponse {
				setTimer () => (fadeOSD()),-1
				
				exit
			} else {
				setTimer () => (sleep(duration),fadeOSD()),-1
			}
				
		} 
		timeout:=0
	} else
			setTimer () => (sleep(duration),fadeOSD()),duration
} 

pbWaitOSD() {
	ui.notifyGui.destroy()
	pbNotify("Timed out waiting for response.`nPlease try your action again",-1000)
}



loadScreen(visible := true,NotifyMsg := "cacheApp Loading",Duration := 10) {
	if (visible) {
		Transparent := 0
		ui.notifyGui			:= Gui()
		ui.notifyGui.Title 		:= "cacheApp Loading"

		ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		ui.notifyGui.BackColor := "353535" ; Can be any RGB color (it will be made transparent below).
		ui.notifyGui.SetFont("s22")  ; Set a large font size (32-point).
		ui.notifyGui.AddText("y5 w300 h35 cBABABA center BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
		ui.notifyGUi.addText("xs+1 y+1 w302 h22 background959595")
		ui.loadingProgress := ui.notifyGui.addProgress("smooth x+-301 y+-21 w300 h20 cABABAB background252525")
		;setTimer(loadingProgressStep,100)
		ui.notifyGui.AddText("xs hidden")
	
		tmpX := iniRead(cfg.file,"Interface","GuiX",200)
		tmpY := iniRead(cfg.file,"Interface","GuiY",200)
		
		ui.notifyGui.Show("w350 h70")
		winGetPos(&x,&y,&w,&h,ui.notifyGui.hwnd)
		ui.notifyGui.move((tmpX+275)-(w/2),(tmpY+95)-(h/2))
		drawOutline(ui.notifyGui,1,1,w-2,h-2,"454545","757575",1)
		drawOutline(ui.notifyGui,2,2,w-4,h-4,"858585","454545",1)
		while transparent < 245 {
			winSetTransparent(transparent,ui.notifyGui.hwnd)
			transparent += 8
			sleep(1)
		}
		winSetTransparent("Off",ui.notifyGui.hwnd)
	
	} else {
		try {
			setTimer(loadingProgressStep,0)
			transparent := 255
			while transparent > 20 {
				winSetTransparent(transparent,ui.notifyGui.hwnd)
				transparent -= 8
				sleep(1)
			}
			ui.notifyGui.hide()
			ui.notifyGui.destroy()
		}
	}
}



hasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

killMe(*) {
	ExitApp
}

resetWindowPosition(*) {
	try {
		guiVis(ui.dockBarGui,false)

		guiVis(ui.mainGui,true)
		tabsChanged()
		ui.MainGui.Move(PrimaryWorkAreaLeft+200,PrimaryWorkAreaTop+200,,)
	}
}

exitFunc(ExitReason,ExitCode) {
	debugLog("Exit Command Received")
	ui.MainGui.Opt("-AlwaysOnTop")
	If  !ui.fastShutdown && (cfg.confirmExitEnabled) && !InStr("Logoff Shutdown Reload Single Close",ExitReason)
	{
		Result := MsgBox("Are you sure you want to`nTERMINATE cacheApp?",,4)
		if Result = "No" {
			if cfg.AlwaysOnTopEnabled
				ui.mainGui.opt("AlwaysOnTop")
			Return 1
		}
	}
	; guiVis(ui.titlebarButtonGui,false)
	guiVis(ui.afkGui,false)
	guiVis(ui.gameSettingsGui,false)
	guiVis(ui.mainGui,false)
	try {
		guiVis(ui.gameTabGui,false)
	}
	; if (cfg.topDockEnabled) {
		; topDockOff()
	; }
	winGetPos(&winX,&winY,,,ui.mainGui.hwnd)
	cfg.guiX := winX
	cfg.guiY := winY
	
	if fileExist("./.tmp")
		fileDelete("./.tmp")
	WriteConfig()
	setCapsLockState("off")
	runWait("redist/mouseSC_x64.exe /verticalScroll:4",,"hide")
}

restartApp(*) {
	reload()
}

arr2str(arrayName) {
	loop arrayName.Length
	{
		stringFromArray .= arrayName[a_index] ","
	}
	return rtrim(stringFromArray,",")
}

resetKeyStates() {
	Loop 0xFF {
		if getKeyState(key := format("vk{:x}",a_index))
		sendInput("{%key% up}")
	}	
}


; setTimer(winActiveMonitor,1000)
; ui.lastWinHwnd := ""
; winActiveMonitor(*) {
	; try
		; ui.currWinProcessName := winGetProcessName(ui.currWinHwnd := winExist("A"))
	; catch
		; return

	; if ui.currWinHwnd == ui.lastWinHwnd
		; return
	; else {
		
		; ui.lastWinHwnd := ui.currWinHwnd 
		
		; if inStr("chrome.exe",ui.currWinProcessName) {
				; winGetPos(&dockX,,,,ui.dockBarGui)
				; if dockX != primaryWorkAreaRight-ui.dockBarWidth-160 {
					; try {
						; if (cfg.animationsEnabled) {
							; while dockX < primaryWorkAreaRight-ui.dockBarWidth-160 {
								; ui.dockBarGui.move(dockX,0)
								; dockX += 15
							; }
						; }
						; ui.dockBarGui.move(primaryWorkAreaRight-ui.dockBarWidth-160,0)
					; }
				; }	
		; } else {
			; winGetPos(&dockX,,,,ui.dockBarGui)
			; if dockX != (a_screenWidth/2)-(ui.dockBarWidth/2) {
			; try {
					; if (cfg.animationsEnabled) {
						; while dockX > (a_screenWidth/2)-(ui.dockBarWidth/2) {
							; ui.dockBarGui.move(dockX,0)
							; dockX -= 15
						; }
					; }
					; ui.dockBarGui.move((a_screenWidth/2)-(ui.dockBarWidth/2),0)
				; }
			; }
		; }		
	; }
; }

appChangeTrans(transLevel) {
	try
		winSetTransparent(transLevel,ui.dockBarGui.hwnd)
}

newGuid(*) {
	return ComObjCreate("Scriptlet.TypeLib").GUID
}



; iniEditor(*) {
	; loop read configFilename {
	; if substr(a_loopReadline,1,1) = "[" {
		; this_section := ltrim(rtrim(a_loopReadline,"]"),"[")
		
; }