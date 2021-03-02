Global $_GUI_Main
Global $_GUI_Main_Tab_Content_MinLeft =  210 + (14 * 3) +  2
Global $_GUI_Main_Tab_Content_MinTop =  14 * 2 +  2

Func _GUI_Main()
	$_GUI_Main = GUICreate($_Configuration_Application_Title& " " &	 $_Configuration_Application_Version, 771, 448, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	GUISetFont(10, Default, Default, $_Configuration_Application_Font)
	GUISetBkColor(0xC0C0C0)

	$_GUI_Main_Menu_Configuration = GUICtrlCreateMenu("Configuration")
	Global $_GUI_Main_Menu_Configuration_Side_Menu = _CreateSideMenu($_GUI_Main_Menu_Configuration)
	_SetSideMenuText($_GUI_Main_Menu_Configuration_Side_Menu, $_Configuration_Application_Title & " " &	 $_Configuration_Application_Version)
	_SetSideMenuColor($_GUI_Main_Menu_Configuration_Side_Menu, 0xFFFFFF)
	_SetSideMenuBkColor($_GUI_Main_Menu_Configuration_Side_Menu, 0x921801)
	_SetSideMenuBkGradColor($_GUI_Main_Menu_Configuration_Side_Menu, 0xFBCE92)
	
	$iExit = _GUICtrlCreateODMenuItem("New", $_GUI_Main_Menu_Configuration, "shell32.dll", -71)
	$iExit = _GUICtrlCreateODMenuItem("Open", $_GUI_Main_Menu_Configuration, "shell32.dll", -69)
	$iExit = _GUICtrlCreateODMenuItem("Save", $_GUI_Main_Menu_Configuration, "shell32.dll", -259)
	$iExit = _GUICtrlCreateODMenuItem("Save as", $_GUI_Main_Menu_Configuration, "shell32.dll", -125)
	_GUICtrlCreateODMenuItem("", $_GUI_Main_Menu_Configuration, 2) ; создаёт разделительную линию
	$iExit = _GUICtrlCreateODMenuItem("Show current in explorer", $_GUI_Main_Menu_Configuration, "shell32.dll", -156)
	
	$_GUI_Main_Menu_Help = GUICtrlCreateMenu("Help")
	$iExit = _GUICtrlCreateODMenuItem("About", $_GUI_Main_Menu_Help, "shell32.dll", -161)


;~ 	$iOpenFile = _GUICtrlCreateODMenuItem("Открыть", $_GUI_Main_Menu_File, "shell32.dll", -4)
;~ 	GUICtrlSetState(-1, $GUI_DEFBUTTON)

;~ 	
;~ 	_GUICtrlCreateODMenuItem("Сохранить", $_GUI_Main_Menu_File, "shell32.dll", -6)
;~ 	GUICtrlSetState(-1, $GUI_DISABLE)
;~ 	_GUICtrlCreateODMenuItem("", $_GUI_Main_Menu_File, 2) ; создаёт разделительную линию
;~ 	$iRecentFilesMenu = _GUICtrlCreateODMenu("Последние файлы", $_GUI_Main_Menu_File, "shell32.dll", -222)
;~ 	
;~ 	$iExit = _GUICtrlCreateODMenuItem("Выход", $_GUI_Main_Menu_File, "shell32.dll", -28)

;~ 	$iViewMenu = GUICtrlCreateMenu("Вид", -1, 1) ; Создан до элемента меню "?"
;~ 	$iViewStatusItem = _GUICtrlCreateODMenuItem("Строка состояния", $iViewMenu)
;~ 	GUICtrlSetState(-1, $GUI_CHECKED)
;~ 	$iStyleitem = _GUICtrlCreateODMenuItem("Стиль GUI POPUP", $iViewMenu)
;~ 	_GUICtrlCreateODMenuItem("", $iViewMenu)
;~ 	$iMRadio1 = _GUICtrlCreateODMenuItem("Радио1", $iViewMenu, "", 0, 1)
;~ 	$iMRadio2 = _GUICtrlCreateODMenuItem("Радио2", $iViewMenu, "", 0, 1)
;~ 	$iMRadio3 = _GUICtrlCreateODMenuItem("Радио3", $iViewMenu, "", 0, 1)
;~ 	GUICtrlSetState(-1, $GUI_CHECKED)
;~ 	$iMRadio4 = _GUICtrlCreateODMenuItem("Радио4", $iViewMenu, "", 0, 1)

	
	$_GUI_Main_Tab = _GUICtrlTreeViewTab_CreateTab(14, 14, 210, 400,BitOr($TVS_HASBUTTONS,$TVS_LINESATROOT,$TVS_DISABLEDRAGDROP,$TVS_SHOWSELALWAYS,$TVS_RTLREADING,$TVS_TRACKSELECT,$TVS_FULLROWSELECT),512)
	_GUICtrlTreeView_SetHeight($_GUI_Main_Tab, 49)
	_GUICtrlTreeView_SetIndent($_GUI_Main_Tab, 5)

	$_GUI_Main_Tab_General = _GUICtrlTreeViewTab_CreateTabItem("  General  ", $_GUI_Main_Tab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", -208	)
	
	
	$_GUI_Main_Tab_Icon = _GUICtrlTreeViewTab_CreateTabItem("  Icon  ", $_GUI_Main_Tab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", -278)

	
	$_GUI_Main_Tab_Icon = _GUICtrlTreeViewTab_CreateTabItem("  UPX  ", $_GUI_Main_Tab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", -157)
	
		$_GUI_Main_Tab_Icon = _GUICtrlTreeViewTab_CreateTabItem("  Execution options  ", $_GUI_Main_Tab)
	GUICtrlSetColor(-1, 0x0000C0)
	GUICtrlSetImage(-1, "shell32.dll", -262)
	
	_GUICtrlTreeViewTab_AddExternalControl($_GUI_Main_Tab, $_GUI_Main_Tab_General, _GUI_Main_Tab_General() )



	GUISwitch($_GUI_Main)
	
	GUICtrlCreateGroup("", 210 + (14 * 2), 6, 519, 408)
	
	GUISetState(@SW_SHOW, $_GUI_Main)


;~ 		GUICtrlSetState($_GUI_Main_Tab_General, BitOR($GUI_DEFBUTTON, $GUI_FOCUS)) ; Paint in bold "Other" item
;~ 	GUICtrlSetState($_GUI_Main_Tab_General, BitOR($GUI_EXPAND, $GUI_DEFBUTTON, $GUI_FOCUS)) ; Expand the "General" item and paint in bold

EndFunc   ;==>_GUI_Main

Func _GUI_Main_Tab_General()
	$_GUI_Main_Tab_General =  GUICreate("",487, 368, $_GUI_Main_Tab_Content_MinLeft, $_GUI_Main_Tab_Content_MinTop,$WS_CHILD ,  0   , $_GUI_Main)
	GUISetFont(10, Default, Default, $_Configuration_Application_Font)
	GUISetBkColor(0xC0C0C0)
	
	GUICtrlCreateLabel("Select directory include executable file", 0 , 0, 400, 26)

	GUICtrlCreateInput("", 0 , 26, 424, 31, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
	
	GUICtrlCreateButton("...", 438, 26, 50, 31)
	
	GUICtrlCreateLabel("Select where to save result file", 0 ,72, 400, 26)

	GUICtrlCreateInput("", 0 , 26 +  72, 424, 31, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
	
	GUICtrlCreateButton("...", 438, 26 +  72, 50, 31)
	
	DllCall("user32.dll", "hwnd", "SetParent", "hwnd", $_GUI_Main_Tab_General, "hwnd", $_GUI_Main)
	return $_GUI_Main_Tab_General
EndFunc