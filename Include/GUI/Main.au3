Global $_GUI_Main

Func _GUI_Main()
	$_GUI_Main = GUICreate($_Configuration_Application_Title& " " &	 $_Configuration_Application_Version, 600, 600, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	GUISetFont(Default, Default, Default, $_Configuration_Application_Font)
;~ 		GUISetBkColor(0xFFFFFF)

	$_GUI_Main_Menu_File = GUICtrlCreateMenu("File")
	Global $_GUI_Main_Menu_File_Side_Menu = _CreateSideMenu($_GUI_Main_Menu_File)
	_SetSideMenuText($_GUI_Main_Menu_File_Side_Menu, $_Configuration_Application_Title & " " &	 $_Configuration_Application_Version)
	_SetSideMenuColor($_GUI_Main_Menu_File_Side_Menu, 0xFFFFFF)
	_SetSideMenuBkColor($_GUI_Main_Menu_File_Side_Menu, 0x921801)
	_SetSideMenuBkGradColor($_GUI_Main_Menu_File_Side_Menu, 0xFBCE92)


	$iOpenFile = _GUICtrlCreateODMenuItem("Открыть", $_GUI_Main_Menu_File, "shell32.dll", -4)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)

		$iOpenFile = _GUICtrlCreateODMenuItem("Открыть", $_GUI_Main_Menu_File, "shell32.dll", -4)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	$iOpenFile = _GUICtrlCreateODMenuItem("Открыть", $_GUI_Main_Menu_File, "shell32.dll", -4)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
		$iOpenFile = _GUICtrlCreateODMenuItem("Открыть", $_GUI_Main_Menu_File, "shell32.dll", -4)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)

	$iHelpMenu = GUICtrlCreateMenu("?")
	_GUICtrlCreateODMenuItem("Сохранить", $_GUI_Main_Menu_File, "shell32.dll", -6)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlCreateODMenuItem("", $_GUI_Main_Menu_File, 2) ; создаёт разделительную линию
	$iInfoItem = _GUICtrlCreateODMenuItem("Информация", $iHelpMenu, "shell32.dll", -222)
	$iRecentFilesMenu = _GUICtrlCreateODMenu("Последние файлы", $_GUI_Main_Menu_File, "shell32.dll", -222)
	$iExit = _GUICtrlCreateODMenuItem("Выход", $_GUI_Main_Menu_File, "shell32.dll", -28)

	$iViewMenu = GUICtrlCreateMenu("Вид", -1, 1) ; Создан до элемента меню "?"
	$iViewStatusItem = _GUICtrlCreateODMenuItem("Строка состояния", $iViewMenu)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$iStyleitem = _GUICtrlCreateODMenuItem("Стиль GUI POPUP", $iViewMenu)
	_GUICtrlCreateODMenuItem("", $iViewMenu)
	$iMRadio1 = _GUICtrlCreateODMenuItem("Радио1", $iViewMenu, "", 0, 1)
	$iMRadio2 = _GUICtrlCreateODMenuItem("Радио2", $iViewMenu, "", 0, 1)
	$iMRadio3 = _GUICtrlCreateODMenuItem("Радио3", $iViewMenu, "", 0, 1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$iMRadio4 = _GUICtrlCreateODMenuItem("Радио4", $iViewMenu, "", 0, 1)

	
	$iTreeViewTab = _GUICtrlTreeViewTab_CreateTab(5, 5, 150, 348,BitOr($TVS_HASBUTTONS,$TVS_LINESATROOT,$TVS_DISABLEDRAGDROP,$TVS_SHOWSELALWAYS,$TVS_RTLREADING,$TVS_TRACKSELECT,$TVS_FULLROWSELECT),512)
	_GUICtrlTreeView_SetHeight($iTreeViewTab, 30)
	_GUICtrlTreeView_SetIndent($iTreeViewTab, 5)

	$iGeneral_TVTItem = _GUICtrlTreeViewTab_CreateTabItem("General", $iTreeViewTab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", -12)
	
	
	$_GUI_Main_Tab_General = _GUI_Main_Tab_General($iTreeViewTab)
	_GUICtrlTreeViewTab_AddExternalControl($iTreeViewTab, $iGeneral_TVTItem, $_GUI_Main_Tab_General )


	GUISetState(@SW_SHOW, $_GUI_Main)


;~ 		GUICtrlSetState($iOther_TVTItem, BitOR($GUI_DEFBUTTON, $GUI_FOCUS)) ; Paint in bold "Other" item
;~ 	GUICtrlSetState($iGeneral_TVTItem, BitOR($GUI_EXPAND, $GUI_DEFBUTTON, $GUI_FOCUS)) ; Expand the "General" item and paint in bold

EndFunc   ;==>_GUI_Main

Func _GUI_Main_Tab_General($iTreeViewTab)
	$_GUI_Main_Tab_General =  GUICreate("heheh", 500, 500, 200, 0,$WS_POPUP,  $WS_CHILD , $_GUI_Main)
	GUICtrlCreateButton("123123", 150, 0, 100, 100)
	
	DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $_GUI_Main_Tab_General, "hwnd", $_GUI_Main)
	
	GUISwitch($_GUI_Main)
	return $_GUI_Main_Tab_General
EndFunc