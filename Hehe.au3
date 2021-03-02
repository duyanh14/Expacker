#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <GUIButton.au3>

#include "include\TreeViewTab.au3"

$hGUI = GUICreate("TreeViewTab Example", 300, 60)
$iSettings_Button = GUICtrlCreateButton("Settings", 20, 20, 260, 20)
GUISetState(@SW_SHOW, $hGUI)

While 1
	$iMsg = GUIGetMsg()
	
	Switch $iMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $iSettings_Button
			_Settings_GUI($hGUI)
	EndSwitch
WEnd

Func _Settings_GUI($hParent)
	Local Enum _
		$iGeneral_Indx, $iSettings_Indx, $iAbout_Indx, $iOther_Indx, $iWindow_Indx, _
		$iTotal_Indxs
	
	Local $aImage_Indxs[$iTotal_Indxs][2] = [["General", -170], ["Settings", -91], ["About", -24], ["Other", -77], ["Window", -3]]
	
	GUISetState(@SW_DISABLE, $hParent)
	$hSettings_GUI = GUICreate("TreeViewTab Example - Settings", 450, 400, -1, -1, -1, -1, $hParent)
	
	$iTreeViewTab = _GUICtrlTreeViewTab_CreateTab(5, 5, 150, 348, -1, BitOR($WS_EX_STATICEDGE, $WS_EX_CLIENTEDGE))
	
	#Region General TVItem
		
	$iGeneral_TVTItem = _GUICtrlTreeViewTab_CreateTabItem("General", $iTreeViewTab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", $aImage_Indxs[$iGeneral_Indx][1])
	
	$iGeneralHeader_Icon = GUICtrlCreateIcon("shell32.dll", $aImage_Indxs[$iGeneral_Indx][1], 160, 3, 32, 32)
	$iGeneralHeader_Label = GUICtrlCreateLabel("General", 200, 10, 300, 40)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetFont(-1, 12, 800, 0, "Georgia")
	
	$hExternal_Button = _GUICtrlButton_Create($hSettings_GUI, 'External Button', 230, 150, 200, 25, $BS_SPLITBUTTON)
	_GUICtrlTreeViewTab_AddExternalControl($iTreeViewTab, $iGeneral_TVTItem, $hExternal_Button)
	
	;Settings TVItem
	$iSettings_TVItem = _GUICtrlTreeViewTab_CreateTabItem("Settings", $iTreeViewTab, $iGeneral_TVTItem)
	GUICtrlSetImage(-1, "shell32.dll", $aImage_Indxs[$iSettings_Indx][1])
	
	$iSettingsHeader_Icon = GUICtrlCreateIcon("shell32.dll", $aImage_Indxs[$iSettings_Indx][1], 160, 3, 32, 32)
	$iSettingsHeader_Label = GUICtrlCreateLabel("Settings", 200, 10, 300, 40)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetFont(-1, 12, 800, 0, "Georgia")
	
	$iSettings_CheckBox1 = GUICtrlCreateCheckbox("Settings Checkbox 1", 180, 60)
	$iSettings_CheckBox2 = GUICtrlCreateCheckbox("Settings Checkbox 2", 180, 80)
	$iSettings_CheckBox3 = GUICtrlCreateCheckbox("Settings Checkbox 3", 180, 100)
	
	$iSettings_List = GUICtrlCreateList("List Item", 180, 140, 250, 210)
	
	;About TVItem
	$iAbout_TVItem = _GUICtrlTreeViewTab_CreateTabItem("About", $iTreeViewTab, $iGeneral_TVTItem)
	GUICtrlSetImage(-1, "shell32.dll", $aImage_Indxs[$iAbout_Indx][1])
	
	$iAboutHeader_Icon = GUICtrlCreateIcon("shell32.dll", $aImage_Indxs[$iAbout_Indx][1], 160, 3, 32, 32)
	$iAboutHeader_Label = GUICtrlCreateLabel("About", 200, 10, 300, 40)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetFont(-1, 12, 800, 0, "Georgia")
	
	$iAbout_Label = GUICtrlCreateLabel( _
		"TreeViewTab - Settings Controls Concept" & @CRLF & @CRLF & _
		"By G.Sandler a.k.a CreatoR", 180, 70, 300, 50)
	GUICtrlSetFont(-1, 8, 400, 2, "Georgia")
	
	#EndRegion General TVItem
	
	#Region Other TVItem
	
	$iOther_TVTItem = _GUICtrlTreeViewTab_CreateTabItem("Other", $iTreeViewTab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", $aImage_Indxs[$iOther_Indx][1])
	
	$iOtherHeader_Icon = GUICtrlCreateIcon("shell32.dll", $aImage_Indxs[$iOther_Indx][1], 160, 3, 32, 32)
	$iOtherHeader_Label = GUICtrlCreateLabel("Other", 200, 10, 300, 40)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetFont(-1, 12, 800, 0, "Georgia")
	
	;Window TVItem
	$iWindow_TVItem = _GUICtrlTreeViewTab_CreateTabItem("Window", $iTreeViewTab, $iOther_TVTItem)
	GUICtrlSetImage(-1, "shell32.dll", $aImage_Indxs[$iWindow_Indx][1])
	
	$iWindowHeader_Icon = GUICtrlCreateIcon("shell32.dll", $aImage_Indxs[$iWindow_Indx][1], 160, 3, 32, 32)
	$iWindowHeader_Label = GUICtrlCreateLabel("Window", 200, 10, 300, 40)
	GUICtrlSetColor(-1, 0xFF0000)
	GUICtrlSetFont(-1, 12, 800, 0, "Georgia")
	
	$iWindowSetOnTop_CheckBox = GUICtrlCreateCheckbox("Set on top", 180, 100)
	
	#EndRegion Other TVItem
	
	_GUICtrlTreeViewTab_CloseTab($iTreeViewTab)
	
	;Seperators
	GUICtrlCreateLabel("", 160, 40, 285, 2, $SS_SUNKEN)
	GUICtrlCreateGroup("", 160, 45, 285, 310)
	GUICtrlCreateLabel("", 2, 360, 446, 2, $SS_SUNKEN)
	
	$iClose_Button = GUICtrlCreateButton("Close", 5, 370, 70, 20)
	$iAddCtrl_Button = GUICtrlCreateButton("Add Control", 90, 370, 100, 20)
	$iDelTVItem_Button = GUICtrlCreateButton("Delete current TVTItem", 305, 370, 140, 20)
	
	GUISetState(@SW_SHOW, $hSettings_GUI)
	
	GUICtrlSetState($iOther_TVTItem, BitOR($GUI_DEFBUTTON, $GUI_FOCUS)) ; Paint in bold "Other" item
	GUICtrlSetState($iGeneral_TVTItem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON, $GUI_FOCUS)) ; Expand the "General" item and paint in bold
	
	While 1
		$iMsg = GUIGetMsg()
		
		Switch $iMsg
			Case $iClose_Button, $GUI_EVENT_CLOSE
				_GUICtrlTreeViewTab_DestroyTab($iTreeViewTab)
				
				GUISetState(@SW_ENABLE, $hParent)
				GUIDelete($hSettings_GUI)
				
				ExitLoop
			Case $iAddCtrl_Button
				GUISetState(@SW_DISABLE, $hSettings_GUI)
				$hAddCtrl_GUI = GUICreate("Add New Element", 500, 150, -1, -1, 0, BitOR($WS_EX_STATICEDGE, $WS_EX_CLIENTEDGE, $WS_EX_TOOLWINDOW), $hSettings_GUI)
				
				GUICtrlCreateLabel("GUICtrlCreate", 20, 42, 80, 15)
				GUICtrlSetFont(-1, 9, 800)
				$iCtrlName_Input = GUICtrlCreateInput("Label('New Label', 180, 330, -1, 15)", 100, 40, 380, 20)
				GUICtrlSetFont(-1, 8.3, 800)
				GUICtrlSetColor(-1, 0xFF0000)
				
				$iOK_Button = GUICtrlCreateButton("Add", 20, 100, 60, 20)
				GUICtrlSetState(-1, $GUI_DEFBUTTON)
				$iCancel_Button = GUICtrlCreateButton("Cancel", 90, 100, 60, 20)
				
				GUISetState(@SW_SHOW, $hAddCtrl_GUI)
				
				While 1
					Switch GUIGetMsg()
						Case $GUI_EVENT_CLOSE, $iCancel_Button
							ExitLoop
						Case $iOK_Button
							GUISwitch($hSettings_GUI)
							
							_GUICtrlTreeViewTab_OpenTab($iTreeViewTab, GUICtrlRead($iTreeViewTab))
							$iNewCtrlID = Execute("GUICtrlCreate" & GUICtrlRead($iCtrlName_Input))
							_GUICtrlTreeViewTab_CloseTab($iTreeViewTab)
							
							ExitLoop
					EndSwitch
				WEnd
				
				GUISetState(@SW_ENABLE, $hSettings_GUI)
				GUIDelete($hAddCtrl_GUI)
			Case $iDelTVItem_Button
				$iTVTItemID = GUICtrlRead($iTreeViewTab)
				$iDelCtrls = Int(MsgBox(52, 'Attention', 'Delete all controls of that TVTItem (' & GUICtrlRead($iTVTItemID, 1) & ')?', 0, $hSettings_GUI) = 6)
				
				$aChild_CtrlIDs = _GUICtrlTreeViewTab_DeleteItem($iTreeViewTab, $iTVTItemID, $iDelCtrls)
				
				For $iIndx = 0 To $iTotal_Indxs-1
					For $iID = 1 To UBound($aChild_CtrlIDs)-1
						If GUICtrlRead($aChild_CtrlIDs[$iID], 1) == $aImage_Indxs[$iIndx][0] Then
							GUICtrlSetImage($aChild_CtrlIDs[$iID], "shell32.dll", $aImage_Indxs[$iIndx][1])
						EndIf
					Next
				Next
		EndSwitch
	WEnd
EndFunc