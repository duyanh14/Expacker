#Region Header

#CS
	Name:				TreeViewTab.au3
	Description:		Pseudo TreeViewTab control to handle TreeView Items on "Tabs level". Usefull for Settings dialog.
	Author:				Copyright © 2012 CreatoR's Lab (G.Sandler), www.creator-lab.ucoz.ru, www.autoit-script.ru. All rights reserved.
	AutoIt version:		3.3.8.1
	UDF version:		1.2
	Forum Link:			
	Uses:           	Constants.au3, GUIConstantsEx.au3, WindowsConstants.au3, GUITreeView.au3, Array.au3, WinAPI.au3
	
	Notes:				From usage perspective, this UDF is similar to Tabs controls.
						But there is few small exceptions:
							- To avoid problems and allow other controls to be outside the tab, you *must* close the created tab using _GUICtrlTreeViewTab_CloseTab.
							- To create a new control on an existing TreeViewTabItem,
								use _GUICtrlTreeViewTab_OpenTab, create your new control, and then close back with _GUICtrlTreeViewTab_CloseTab.
							- After (or better before) parent GUI of the created TreeViewTab control is deleted, _GUICtrlTreeViewTab_DestroyTab must be called.
							- You can create more than one TreeViewTab controls in one GUI, and even create it inside other TreeViewTab Item.
	
	Remarks:			* External controls created with _GUICtrl* functions should be added manually using _GUICtrlTreeViewTab_AddExternalControl.
						* To updated/get data/state or perform other manipulation with created TreeViewTab control, use native GUICtrlTreeView* and other updating functions.
	
	ToDo:				* Try to restore icons when restoring child items.
						* Add $iDelChildItems parameter to _GUICtrlTreeViewTab_DeleteItem function, to remove child TreeViewTab items, and if $iDelCtrls = 1 all controls in them.
	
	History:
	1.2
	* WM_NOTIFY window message replaced with Callback windows procedure (thanks to BugFix).
	* Fixed issue with adding new control, if it's added after TreeViewTabItem deleted, the control added outside TabItems.
	* Removed TreeViewTab_Adlib.au3 due to replacement of WM_NOTIFY window message.
	
	1.1
	+ Added _GUICtrlTreeViewTab_DestroyTab function, must be called after parent GUI of the created TreeViewTab control is deleted.
	* Fixed issue with deleting items. The script should not end with fatal error anymore.
	* Example Improved.
	
	1.0
	* First release
	
#CE

;Includes
#include-once

#Include <Constants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GUITreeView.au3>
#include <Array.au3>
#include <WinAPI.au3>

#EndRegion Header

#Region Global Variables

Global $i_TVT_SubItems = 1000 ;TreeViewTabItems
Global $a_TVT_Items[1][$i_TVT_SubItems]
Global $a_TVT_EnumWins[1]
Global $a_TVT_hWndID[2]
Global $a_TVT_OpenTVTItem[3]
Global $ah_TVT_WinProc[1][2]
Global $h_TVT_WinCallback_Proc

#EndRegion Global Variables

; #FUNCTION# ====================================================================================================
; Name...........: _GUICtrlTreeViewTab_CreateTab
; Description....: Creates TreeViewTab control
; Syntax.........: _GUICtrlTreeViewTab_CreateTab($iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
; Parameters.....: $iLeft - Horizontal position of the control
;                  $iTop - Vertical position of the control
;                  $iWidth [Optional] - Control width
;                  $iHeight [Optional] - Control height
;                  $iStyle [Optional] - Control style (same as used in GUICtrlCreateTreeView)
;                  $iExStyle [Optional] - Control extended style
;                  
;                 
; Return values..: Success - Returns the identifier (controlID) of the new control.
;                  Failure - Returns 0.
; Author.........: G.Sandler (CreatoR)
; Modified.......: 
; Remarks........: Must be closed with _GUICtrlTreeViewTab_CloseTab after all controls under TreeViewTabItems have been created.
; Related........: 
; Link...........: 
; Example........: 
; ===============================================================================================================
Func _GUICtrlTreeViewTab_CreateTab($iLeft, $iTop, $iWidth = -1, $iHeight = -1, $iStyle = -1, $iExStyle = -1)
	If $a_TVT_Items[0][0] = 0 Then
		$h_TVT_WinCallback_Proc = DllCallbackRegister('__GUICtrlTreeViewTab_WinProc', 'ptr', 'hwnd;uint;wparam;lparam')
	EndIf
	
	$a_TVT_Items[0][0] += 1
	ReDim $a_TVT_Items[$a_TVT_Items[0][0]+1][$i_TVT_SubItems]
	$a_TVT_Items[$a_TVT_Items[0][0]][0] = GUICtrlCreateTreeView($iLeft, $iTop, $iWidth, $iHeight, $iStyle, $iExStyle)
	
	Local $hParent = _WinAPI_GetParent(GUICtrlGetHandle($a_TVT_Items[$a_TVT_Items[0][0]][0]))
	
	For $i = 1 To $ah_TVT_WinProc[0][0]
		If $ah_TVT_WinProc[$i][0] = $hParent Then
			Return $a_TVT_Items[$a_TVT_Items[0][0]][0]
		EndIf
	Next
	
	$ah_TVT_WinProc[0][0] += 1
	ReDim $ah_TVT_WinProc[$ah_TVT_WinProc[0][0]+1][2]
	$ah_TVT_WinProc[$ah_TVT_WinProc[0][0]][0] = $hParent
	$ah_TVT_WinProc[$ah_TVT_WinProc[0][0]][1] = _WinAPI_SetWindowLong($hParent, $GWL_WNDPROC, DllCallbackGetPtr($h_TVT_WinCallback_Proc))
	
	Return $a_TVT_Items[$a_TVT_Items[0][0]][0]
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: _GUICtrlTreeViewTab_CreateTabItem
; Description....: Creates TreeViewTabItem control
; Syntax.........: _GUICtrlTreeViewTab_CreateTabItem($sText, $iTVTID = -1, $iParentTVTItemID = -1)
; Parameters.....: $sText - The text of the control
;                  $iTVTID [Optional] - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTab
;                  $iParentTVTItemID [Optional] - TreeViewTabItem identifier as returned by _GUICtrlTreeViewTab_CreateTabItem if subtree is created
;                  
;                 
; Return values..: Success - Returns the identifier (controlID) of the new control.
;                  Failure - Returns 0.
; Author.........: G.Sandler (CreatoR)
; Modified.......: 
; Remarks........: 
; Related........: 
; Link...........: 
; Example........: 
; ===============================================================================================================
Func _GUICtrlTreeViewTab_CreateTabItem($sText, $iTVTID = -1, $iParentTVTItemID = -1)
	Local $iSubItemsCount = __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $iLastID = __GUICtrlTreeViewTab_GetLastCtrlID(_WinAPI_GetParent(GUICtrlGetHandle($iTVTID)))
	
	If $iSubItemsCount = $i_TVT_SubItems Then
		$iSubItemsCount += 1
		$i_TVT_SubItems *= 2
		ReDim $a_TVT_Items[$a_TVT_Items[0][0]+1][$i_TVT_SubItems]
	EndIf
	
	If $iTVTID = -1 Then
		$iTVTID = $iLastID
	EndIf
	
	If $iParentTVTItemID = -1 Then
		$iParentTVTItemID = $iTVTID
	EndIf
	
	For $i = 1 To $a_TVT_Items[0][0]
		If $a_TVT_Items[$i][0] = $iTVTID Then
			For $j = 1 To $iSubItemsCount
				If $a_TVT_Items[$i][$j] == '' Then
					$a_TVT_Items[$i][$j] = GUICtrlCreateTreeViewItem($sText, $iParentTVTItemID)
					Return $a_TVT_Items[$i][$j]
				EndIf
			Next
		EndIf
	Next
	
	Return 0
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: _GUICtrlTreeViewTab_CloseTab
; Description....: Closes created TreeViewTab control
; Syntax.........: _GUICtrlTreeViewTab_CloseTab($iTVTID)
; Parameters.....: $iTVTID - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTab
;                  
;                 
; Return values..: Success - Returns 1.
;                  Failure - Returns 0 and set @error as following:
;                                                                   1 - No items created.
;                                                                   2 - $iTVTID not found/created.
; Author.........: G.Sandler (CreatoR)
; Modified.......: 
; Remarks........: 
; Related........: 
; Link...........: 
; Example........: 
; ===============================================================================================================
Func _GUICtrlTreeViewTab_CloseTab($iTVTID)
	Local $hParent = _WinAPI_GetParent(GUICtrlGetHandle($iTVTID))
	Local $iLastID = __GUICtrlTreeViewTab_GetLastCtrlID($hParent)
	Local $iSubItemsCount = __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $aSplitIDs, $iNext, $iRet = 0
	
	;No items created
	If $iSubItemsCount = 0 Then
		Return SetError(-1, 0, 0)
	EndIf
	
	If $iTVTID = -1 Then
		$iTVTID = $iLastID
	EndIf
	
	For $i = 1 To $a_TVT_Items[0][0]
		;Close tab definition for opened item
		If $a_TVT_Items[$i][0] = $a_TVT_OpenTVTItem[0] Then
			;Add all new CtrlIDs that under our Tab Item as a list
			For $j = 1 To $iSubItemsCount
				$aSplitIDs = StringSplit($a_TVT_Items[$i][$j], '|')
				
				If $aSplitIDs[1] = $a_TVT_OpenTVTItem[1] Then
					;From last CtrlID on the time that tab was open, to the last created at this point (current CtrlID)
					For $iID = $a_TVT_OpenTVTItem[2]+1 To $iLastID
						If ControlGetHandle($hParent, '', $iID) <> 0 And __GUICtrlTreeViewTab_FindID($a_TVT_Items[$i][0], $iID) = 0 Then
							$a_TVT_Items[$i][$j] &= '|' & $iID
						EndIf
					Next
					
					ExitLoop
				EndIf
			Next
			
			Dim $a_TVT_OpenTVTItem[3]
			
			$iRet = 1
			ExitLoop
		EndIf
		
		;Found TVTab control
		If $a_TVT_Items[$i][0] = $iTVTID Then
			;Add all CtrlIDs that under our Tab Items as a list
			For $j = 1 To $iSubItemsCount
				If $a_TVT_Items[$i][$j] == '' Then
					ContinueLoop
				EndIf
				
				If $j+1 < $iSubItemsCount And $a_TVT_Items[$i][$j+1] <> '' Then
					$iNext = $a_TVT_Items[$i][$j+1]-1
				Else
					$iNext = $iLastID
				EndIf
				
				For $iID = $a_TVT_Items[$i][$j]+1 To $iNext
					$a_TVT_Items[$i][$j] &= '|' & $iID
				Next
			Next
			
			$iRet = 1
			ExitLoop
		EndIf
	Next
	
	_WinAPI_RedrawWindow($hParent, 0, 0, BitOR($RDW_ALLCHILDREN, $RDW_INVALIDATE))
	
	Return $iRet
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: _GUICtrlTreeViewTab_OpenTab
; Description....: Open TreeViewTab to allow addition of new created controls.
; Syntax.........: _GUICtrlTreeViewTab_OpenTab($iTVTID, $iTVTItemID)
; Parameters.....: $iTVTID - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTab
;                  $iTVTItemID - TreeViewTabItem identifier as returned by _GUICtrlTreeViewTab_CreateTabItem to add controls
;                  
;                 
; Return values..: Returns 1 and open TreeViewTab for adding new controls.
;                  
; Author.........: G.Sandler (CreatoR)
; Modified.......: 
; Remarks........: 
; Related........: 
; Link...........: 
; Example........: 
; ===============================================================================================================
Func _GUICtrlTreeViewTab_OpenTab($iTVTID, $iTVTItemID)
	$a_TVT_OpenTVTItem[0] = $iTVTID
	$a_TVT_OpenTVTItem[1] = $iTVTItemID
	$a_TVT_OpenTVTItem[2] = __GUICtrlTreeViewTab_GetLastCtrlID(0);_WinAPI_GetParent(GUICtrlGetHandle($iTVTID)))
	
	Return 1
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: _GUICtrlTreeViewTab_DeleteItem
; Description....: Deletes TreeViewTabItem.
; Syntax.........: _GUICtrlTreeViewTab_DeleteItem($iTVTID, $iTVTItemID, $iDelCtrls = 0)
; Parameters.....: $iTVTID - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTab
;                  $iTVTItemID - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTabItem
;                  $iDelCtrls [Optional] - If this parameter = 1, then all controls that created under specified $iTVTItemID will be deleted
;                  
;                 
; Return values..: Depends on the $iTVTItemID type:
;                                                    If it's parent for other TreeViewTabItem controls, then array of all it's child controls will be returned
;                                                    Otherwise returns 1.
; Author.........: G.Sandler (CreatoR)
; Modified.......: 
; Remarks........: Any child TreeViewTabItem controls will be recreated inside TreeViewTab control.
; Related........: 
; Link...........: 
; Example........: 
; ===============================================================================================================
Func _GUICtrlTreeViewTab_DeleteItem($iTVTID, $iTVTItemID, $iDelCtrls = 0)
	Local $iSubItemsCount = __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $aSplitIDs, $aRet[1]
	
	For $i = 1 To $a_TVT_Items[0][0]
		If $a_TVT_Items[$i][0] = $iTVTID Then
			For $j = 1 To $iSubItemsCount
				$aSplitIDs = StringSplit($a_TVT_Items[$i][$j], '|')
				
				;Recreate child TVItems
				If _GUICtrlTreeView_GetChildCount($iTVTID, $iTVTItemID) > 0 Then
					If _GUICtrlTreeView_GetParentParam($iTVTID, Int($aSplitIDs[1])) = $iTVTItemID Then
						$a_TVT_Items[$i][$j] = GUICtrlCreateTreeViewItem(GUICtrlRead(Int($aSplitIDs[1]), 1), $iTVTID)
						
						$aRet[0] += 1
						ReDim $aRet[$aRet[0]+1]
						$aRet[$aRet[0]] = $a_TVT_Items[$i][$j]
						
						For $iID = 2 To $aSplitIDs[0]
							$a_TVT_Items[$i][$j] &= '|' & $aSplitIDs[$iID]
						Next
					EndIf
				EndIf
				
				If $aSplitIDs[1] = $iTVTItemID Then
					If $iDelCtrls Then
						For $iID = 2 To $aSplitIDs[0]
							If StringIsInt($aSplitIDs[$iID]) Then
								GUICtrlDelete(Int($aSplitIDs[$iID]))
							Else
								_WinAPI_DestroyWindow(HWnd($aSplitIDs[$iID]))
							EndIf
						Next
					EndIf
					
					$a_TVT_Items[$i][$j] = ''
				EndIf
			Next
		EndIf
	Next
	
	__GUICtrlTreeViewTab_TidySubItems()
	
	GUICtrlDelete($iTVTItemID)
	
	If $aRet[0] > 0 Then
		Return $aRet
	EndIf
	
	Return 1
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: _GUICtrlTreeViewTab_DestroyTab
; Description....: Destroys TreeViewTab, must be called after parent GUI of the created TreeViewTab control is deleted.
; Syntax.........: _GUICtrlTreeViewTab_DestroyTab($iTVTID)
; Parameters.....: $iTVTID - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTab
;                  
;                 
; Return values..: Success - Returns 1.
;                  Failure - Returns 0.
; Author.........: G.Sandler (CreatoR)
; Modified.......: 
; Remarks........: Any child TreeViewTabItem controls will be recreated inside TreeViewTab control.
; Related........: 
; Link...........: 
; Example........: 
; ===============================================================================================================
Func _GUICtrlTreeViewTab_DestroyTab($iTVTID)
	For $i = 1 To $a_TVT_Items[0][0]
		If $a_TVT_Items[$i][0] = $iTVTID Then
			_ArrayDelete($a_TVT_Items, $i)
			$a_TVT_Items[0][0] -= 1
			
			If $a_TVT_Items[0][0] <= 0 Then
				DllCallbackFree($h_TVT_WinCallback_Proc)
				
				For $j = 1 To $ah_TVT_WinProc[0][0]
					_WinAPI_SetWindowLong($ah_TVT_WinProc[$j][0], $GWL_WNDPROC, $ah_TVT_WinProc[$j][1])
				Next
			Else
				Local $hParent = _WinAPI_GetParent(GUICtrlGetHandle($iTVTID))
				
				For $j = 1 To $ah_TVT_WinProc[0][0]
					If $ah_TVT_WinProc[$j][0] = $hParent And Not WinExists($ah_TVT_WinProc[$j][0]) Then
						_WinAPI_SetWindowLong($ah_TVT_WinProc[$j][0], $GWL_WNDPROC, $ah_TVT_WinProc[$j][1])
					EndIf
				Next
			EndIf
			
			Return GUICtrlDelete($iTVTID)
		EndIf
	Next
	
	Return 0
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........:	_GUICtrlTreeViewTab_AddExternalControl
; Description....:	Adds external control (that is not created with native AutoIt function) to the specified TreeViewTabItem.
; Syntax.........:	_GUICtrlTreeViewTab_AddExternalControl($iTVTID, $iTVTItemID, $hCtrl)
; Parameters.....:	$iTVTID - TreeViewTab identifier as returned by _GUICtrlTreeViewTab_CreateTab
;					$iTVTItemID - TreeViewTabItem identifier as returned by _GUICtrlTreeViewTab_CreateTabItem to add control
;					$hCtrl - Control handle to add
;					
; Return values..:	Success - Returns 1.
;					Failure - Returns 0 and sets @error to -1 if no TreeViewTabItems created.
; Author.........:	
; Modified.......:	
; Remarks........:	
; Related........:	
; Link...........:	
; Example........:	
; ===============================================================================================================
Func _GUICtrlTreeViewTab_AddExternalControl($iTVTID, $iTVTItemID, $hCtrl)
	Local $hParent = _WinAPI_GetParent(GUICtrlGetHandle($iTVTID))
	Local $iSubItemsCount = __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $aSplitIDs
	
	;No items created
	If $iSubItemsCount = 0 Then
		Return SetError(-1, 0, 0)
	EndIf
	
	For $i = 1 To $a_TVT_Items[0][0]
		If $a_TVT_Items[$i][0] = $iTVTID Then
			;Add new Ctrl handle to our TreeViewTab Item
			For $j = 1 To $iSubItemsCount
				$aSplitIDs = StringSplit($a_TVT_Items[$i][$j], '|')
				
				If $aSplitIDs[1] = $iTVTItemID Then
					$a_TVT_Items[$i][$j] &= '|' & $hCtrl
					ExitLoop
				EndIf
			Next
			
			Return 1
		EndIf
	Next
	
	Return 0
EndFunc

#Region Internal functions

; #FUNCTION# ====================================================================================================
; Name...........: __GUICtrlTreeViewTab_WinProc
; Description....: Internal Callback windows procedure to handle TreeView notify messages
; Author.........: G.Sandler (CreatoR)
; ===============================================================================================================
Func __GUICtrlTreeViewTab_WinProc($hWnd, $iMsg, $wParam, $lParam)
	Switch $iMsg
		Case $WM_NOTIFY
			Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
			
			If BitAND(WinGetState($hWnd), 2) Then
				$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
				$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
				$iIDFrom = GUICtrlRead(DllStructGetData($tNMHDR, "IDFrom"))
				$iCode = DllStructGetData($tNMHDR, "Code")
				
				Switch $iCode
					Case $TVN_SELCHANGEDA, $TVN_SELCHANGEDW
						$a_TVT_hWndID[0] = $hWndFrom
						$a_TVT_hWndID[1] = $iIDFrom
						AdlibRegister('__GUICtrlTreeViewTab_SelChanged', 10)
				EndSwitch
			EndIf
	EndSwitch
	
	For $i = 1 To $ah_TVT_WinProc[0][0]
		If $ah_TVT_WinProc[$i][0] = $hWnd Then
			Return _WinAPI_CallWindowProc($ah_TVT_WinProc[$i][1], $hWnd, $iMsg, $wParam, $lParam)
		EndIf
	Next
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: __GUICtrlTreeViewTab_SelChanged
; Description....: Internal function for __GUICtrlTreeViewTab_WM_NOTIFY, to avoid blocking the window message function. 
; Author.........: G.Sandler (CreatoR)
; ===============================================================================================================
Func __GUICtrlTreeViewTab_SelChanged()
	AdlibUnRegister('__GUICtrlTreeViewTab_SelChanged')
	
	Local $hWndFrom = $a_TVT_hWndID[0]
	Local $iIDFrom = $a_TVT_hWndID[1]
	
	Dim $a_TVT_hWndID[2]
	
	Local $hParent = _WinAPI_GetParent($hWndFrom)
	Local $iLastID = __GUICtrlTreeViewTab_GetLastCtrlID($hParent)
	Local $iSubItemsCount = __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $aSplitIDs
	
	For $i = 1 To $a_TVT_Items[0][0]
		If GUICtrlGetHandle($a_TVT_Items[$i][0]) = $hWndFrom Then
			For $j = 1 To $iSubItemsCount
				$aSplitIDs = StringSplit($a_TVT_Items[$i][$j], '|')
				
				If Int($aSplitIDs[1]) = $iIDFrom Then
					For $iID = 2 To $aSplitIDs[0]
						If StringIsInt($aSplitIDs[$iID]) Then
							GUICtrlSetState(Int($aSplitIDs[$iID]), $GUI_SHOW)
						Else
							ControlShow($hParent, '', HWnd($aSplitIDs[$iID]))
						EndIf
					Next
				Else
					For $iID = 2 To $aSplitIDs[0]
						If StringIsInt($aSplitIDs[$iID]) Then
							GUICtrlSetState(Int($aSplitIDs[$iID]), $GUI_HIDE)
						Else
							ControlHide($hParent, '', HWnd($aSplitIDs[$iID]))
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	
	_WinAPI_RedrawWindow($hParent, 0, 0, BitOR($RDW_ALLCHILDREN, $RDW_INVALIDATE))
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: __GUICtrlTreeViewTab_GetLastCtrlID
; Description....: Internal function to get last created CtrlID
; Syntax.........: __GUICtrlTreeViewTab_GetLastCtrlID($hWnd = 0)
; Parameters.....: $hWnd [Optional] - Window handle, if this parameter = 0, then this function will search the last created CtrlID in last created/switched window.
; Return values..: Success - Return the last CtrlID created in specified window, or in last created/switched window if $hWnd = 0.
;                  Failure - Return 0 and set @error to 1.
; Author.........: G.Sandler (CreatoR)
; ===============================================================================================================
Func __GUICtrlTreeViewTab_GetLastCtrlID($hWnd = 0)
	Local $hID = GUICtrlGetHandle(-1)
	
	If IsHWnd($hWnd) Then
		Local $aChildWins = __GUICtrlTreeViewTab_EnumChildWindows($hWnd)
		
		If Not @error Then
			$hID = $aChildWins[$aChildWins[0]]
		EndIf
	EndIf
	
	Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", $hID)
	If Not @error Then Return $aRet[0]
	
	Return SetError(1, 0, 0)
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: __GUICtrlTreeViewTab_GetSubItemsCount
; Description....: Internal function to get $a_TVT_Items array subitems count (non empty entries)
; Syntax.........: __GUICtrlTreeViewTab_GetSubItemsCount() 
; Return values..: Success - Returns the subitems count.
;                  Failure - Returns 0.
; Author.........: G.Sandler (CreatoR)
; ===============================================================================================================
Func __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $iCount = 0, $iRetCount = 0
	
	For $i = 1 To $a_TVT_Items[0][0]
		$iCount = 0
		
		For $j = 1 To $i_TVT_SubItems-1
			If $a_TVT_Items[$i][$j] <> '' Then
				$iCount += 1
			EndIf
		Next
		
		If $iCount > $iRetCount Then
			$iRetCount = $iCount
		EndIf
	Next
	
	Return $iRetCount+1
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: __GUICtrlTreeViewTab_TidySubItems
; Description....: Internal function to tidy subitems of $a_TVT_Items array (remove middle empty subitems)
; Syntax.........: __GUICtrlTreeViewTab_TidySubItems() 
; Return values..: None.
; Author.........: G.Sandler (CreatoR)
; ===============================================================================================================
Func __GUICtrlTreeViewTab_TidySubItems()
	For $i = 1 To $a_TVT_Items[0][0]
		For $j = 1 To $i_TVT_SubItems-1
			If $j+1 > $i_TVT_SubItems Or ($j+1 < $i_TVT_SubItems And $a_TVT_Items[$i][$j] = '' And $a_TVT_Items[$i][$j+1] = '') Then
				Return
			EndIf
			
			If $a_TVT_Items[$i][$j] = '' And $a_TVT_Items[$i][$j+1] <> '' Then
				$a_TVT_Items[$i][$j] = $a_TVT_Items[$i][$j+1]
				$a_TVT_Items[$i][$j+1] = ''
			EndIf
		Next
	Next
EndFunc

; #FUNCTION# ====================================================================================================
; Name...........: __GUICtrlTreeViewTab_FindID
; Description....: Internal function to find specific CtrlID in items array
; Syntax.........: __GUICtrlTreeViewTab_FindID($iTVTID, $iID)
; Parameters.....: $iTVTID - TreeViewTab ID as returned by _GUICtrlTreeViewTab_CreateTab
;                  $iID - CtrlID under the TreeViewTabItems
; Return values..: Success - Return found position (cel #) in the array.
;                  Failure - Returns 0.
; Author.........: G.Sandler (CreatoR)
; ===============================================================================================================
Func __GUICtrlTreeViewTab_FindID($iTVTID, $iID)
	Local $iSubItemsCount = __GUICtrlTreeViewTab_GetSubItemsCount()
	Local $aSplitIDs
	
	For $i = 1 To $a_TVT_Items[0][0]
		If $a_TVT_Items[$i][0] = $iTVTID Then
			For $j = 1 To $iSubItemsCount
				$aSplitIDs = StringSplit($a_TVT_Items[$i][$j], '|')
				
				For $jID = 2 To $aSplitIDs[0]
					If $aSplitIDs[$jID] == $iID Then
						Return $j
					EndIf
				Next
			Next
			
			ExitLoop
		EndIf
	Next
	
	Return 0
EndFunc

;Internal function used to Enum Child Windows
Func __GUICtrlTreeViewTab_EnumChildWindows($hWnd, $fVisible = 1)
	If Not _WinAPI_GetWindow($hWnd, 5) Then
		Return SetError(1, 0, 0)
	EndIf
	
	Dim $a_TVT_EnumWins[1] = [0]
	Local $hEnumProc = DllCallbackRegister('__GUICtrlTreeViewTab_EnumWindowsProc', 'int', 'hwnd;lparam')
	DllCall('user32.dll', 'int', 'EnumChildWindows', 'hwnd', $hWnd, 'ptr', DllCallbackGetPtr($hEnumProc), 'lparam', $fVisible)
	DllCallbackFree($hEnumProc)
	
	If $a_TVT_EnumWins[0] = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	
	Local $aRet = $a_TVT_EnumWins
	Dim $a_TVT_EnumWins[1] = [0]
	
	Return $aRet
EndFunc

;Internal function used for callback from __GUICtrlTreeViewTab_EnumChildWindows
Func __GUICtrlTreeViewTab_EnumWindowsProc($hWnd, $fVisible)
	If ($fVisible) And (Not _WinAPI_IsWindowVisible($hWnd)) Then
		Return 1
	EndIf
	
	$a_TVT_EnumWins[0] += 1
	ReDim $a_TVT_EnumWins[$a_TVT_EnumWins[0]+1]
	$a_TVT_EnumWins[$a_TVT_EnumWins[0]] = $hWnd
	
	Return 1
EndFunc

#EndRegion Internal functions
