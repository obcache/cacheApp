#requires autohotkey v2.0+
#singleInstance

persistent()





isAutoRunHot(*) {
	if winActive("ahk_exe destiny2.exe") && !getKeyState("CapsLock", "T") && !getKeyState("LButton") && !getKeyState("RButton")
		return 1
	else
		return 0
}

#hotIf winActive("ahk_exe destiny2.exe")
*~capslock::
{
	(getKeyState("capsLock","T")) ? d2ToggleAppFunctionsOn() : d2ToggleAppFunctionsOff()
}
#hotIf

#hotIf isAutoRunHot()
*~w::
{
	sendEvent("{blind}{LShift Down}")
}

*~w up::
{
	sendEvent("{blind}{LShift Up}")
}
LShift::
{
	if getKeyState("w") {
		send("{c down}")
		keyWait("lshift")
		send("{c up}")	
		sendEvent("{blind}{w down}")
	}
}
#hotIf

*~w::
{
	sendEvent("{blind}{LShift Down}")
}

*~w up::
{
	sendEvent("{blind}{LShift Up}")
}
LShift::
{
	if getKeyState("w") {
		send("{c down}")
		keyWait("lshift")
		send("{c up}")	
		sendEvent("{blind}{w down}")
	}
}
#hotIf
