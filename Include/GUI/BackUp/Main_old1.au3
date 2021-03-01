Global $_Gui_Main

Func _Gui_Main()
	$_Gui_Main =  GUICreate($_Configuration_Title, 600, 600, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE,"_Exit")
	
	$_Gui_Main_Menu_File = GUICtrlCreateMenu("File")

		 GUICtrlCreateMenuItem("Kịch bản mới", $_Gui_Main_Menu)
			GUICtrlSetOnEvent(-1,"kichbanmoi")

		 GUICtrlCreateMenuItem("Mở kịch bản", $_Gui_Main_Menu)
			GUICtrlSetOnEvent(-1,"mokichban")

		 GUICtrlCreateMenuItem("Lưu kịch bản", $_Gui_Main_Menu)
			GUICtrlSetOnEvent(-1,"luukichban")

		 GUICtrlCreateMenuItem("", $_Gui_Main_Menu)
			GUICtrlCreateMenuItem("Thoát", $_Gui_Main_Menu)
			   GUICtrlSetOnEvent(-1,"thoat")

	  $_Gui_Main_Menu_Tool = GUICtrlCreateMenu("Công cụ")

		 GUICtrlCreateMenuItem("Biên dịch kịch bản sang .au3",	$_Gui_Main_Menu_Tool)
			GUICtrlSetOnEvent(-1,"dichau3")

		 GUICtrlCreateMenuItem("Đổi tên cửa sổ",	$_Gui_Main_Menu_Tool)
			GUICtrlSetOnEvent(-1,"doitencs")

		 GUICtrlCreateMenuItem("Khoá màn hình",	$_Gui_Main_Menu_Tool)
			GUICtrlSetOnEvent(-1,"khoamanhinh")

		 GUICtrlCreateMenuItem("Record",	$_Gui_Main_Menu_Tool)
			GUICtrlSetOnEvent(-1,"record")

	  $_Gui_Main_Menu_Application = GUICtrlCreateMenu("Chương trình")
		 GUICtrlCreateMenuItem("Trợ giúp",	$_Gui_Main_Menu_Application)
			GUICtrlSetOnEvent(-1,"trogiup")

		 GUICtrlCreateMenuItem("Website",	$_Gui_Main_Menu_Application)
			GUICtrlSetOnEvent(-1,"website")

		 GUICtrlCreateMenuItem("Forum",	$_Gui_Main_Menu_Application)
			GUICtrlSetOnEvent(-1,"forum")

		 GUICtrlCreateMenuItem("Copyright",	$_Gui_Main_Menu_Application)
			GUICtrlSetOnEvent(-1,"copyright")
	
	GUISetState(@SW_SHOW)
EndFunc