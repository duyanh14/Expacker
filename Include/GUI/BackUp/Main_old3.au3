Global $_Gui_Main

Func _Gui_Main()
	$_Gui_Main = GUICreate($_Configuration_Application_Title, 600, 600, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
	GUISetFont(Default , Default , Default , $_Configuration_Application_Font)
	
	$_Gui_Main_Menu_File = GUICtrlCreateMenu("File")
	
	Global $StudioFenster_MenuHandle = _GUICtrlMenu_GetMenu($_Gui_Main)
Global $ISN_FileMenu_SideMenu = _CreateSideMenu($_Gui_Main_Menu_File)
_SetSideMenuText($ISN_FileMenu_SideMenu,$_Configuration_Application_Title&" " + $_Configuration_Application_Version		)
_SetSideMenuColor($ISN_FileMenu_SideMenu, 0xFFFFFF) ; default color - white
_SetSideMenuBkColor($ISN_FileMenu_SideMenu, 0x921801) ; bottom start color - dark blue
_SetSideMenuBkGradColor($ISN_FileMenu_SideMenu, 0xFBCE92) ; top end color - light blue

	$iOpenFile = _GUICtrlCreateODMenuItem("Открыть", $_Gui_Main_Menu_File, "shell32.dll", -4)
	GUICtrlSetState(-1, $GUI_DEFBUTTON)
	$iHelpMenu = GUICtrlCreateMenu("?")
	_GUICtrlCreateODMenuItem("Сохранить", $_Gui_Main_Menu_File, "shell32.dll", -6)
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlCreateODMenuItem("", $_Gui_Main_Menu_File, 2) ; создаёт разделительную линию
	$iInfoItem = _GUICtrlCreateODMenuItem("Информация", $iHelpMenu, "shell32.dll", -222)
	$iRecentFilesMenu = _GUICtrlCreateODMenu("Последние файлы", $_Gui_Main_Menu_File, "shell32.dll", -222)
	$iExit = _GUICtrlCreateODMenuItem("Выход", $_Gui_Main_Menu_File, "shell32.dll", -28)

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


	$iButton = GUICtrlCreateButton("OK", 50, 130, 70, 20)
	GUICtrlSetState(-1, $GUI_FOCUS)
	$iCancel = GUICtrlCreateButton("Отмена", 180, 130, 70, 20)

	$i_CM_Btn = GUICtrlCreateContextMenu($iButton)
	$i_CM_BtnItem = _GUICtrlCreateODMenuItem("О кнопке", $i_CM_Btn, "shell32.dll", -222)

	$iContMenu = GUICtrlCreateContextMenu()

	$i_CM_newsubmenu = _GUICtrlCreateODMenu("Новое", $iContMenu, "shell32.dll", -5)
	$i_CM_textitem = _GUICtrlCreateODMenuItem("Текст", $i_CM_newsubmenu, "shell32.dll", -71)

	$i_CM_OpenFile = _GUICtrlCreateODMenuItem("Открыть", $iContMenu, "shell32.dll", -4)
	$i_CM_SaveFile = _GUICtrlCreateODMenuItem("Сохранить", $iContMenu, "shell32.dll", -6)
	_GUICtrlCreateODMenuItem("", $iContMenu) ; разделитель

	$i_CM_infoitem = _GUICtrlCreateODMenuItem("Информация", $iContMenu, "shell32.dll", -222)


	GUISetState(@SW_SHOW)
EndFunc   ;==>_Gui_Main
