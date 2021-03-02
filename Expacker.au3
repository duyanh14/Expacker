#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Run_Au3Check=N
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <GUIButton.au3>
#include <GuiMenu.au3>
#include "include\TreeViewTab.au3"
#include "include\ModernMenuRaw.au3"
#include "include\Configuration.au3"
#include "include\GUI\Main.au3"

DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", True)

Opt("GuiOnEventMode", 1)

_GUI_Main()

While True
	Sleep(1000)
WEnd

Func _Exit()
		ProcessClose(@AutoItPID)
	Exit
EndFunc   ;==>_Exit
	