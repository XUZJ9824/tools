If Not IsObject(application) Then
   Set SapGuiAuto  = GetObject("SAPGUI")
   Set application = SapGuiAuto.GetScriptingEngine
End If
If Not IsObject(connection) Then
   Set connection = application.Children(0)
End If
If Not IsObject(session) Then
   Set session    = connection.Children(0)
End If
If IsObject(WScript) Then
   WScript.ConnectObject session,     "on"
   WScript.ConnectObject application, "on"
End If
session.findById("wnd[0]").maximize
session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRTASKGRP"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = "22.08.2015"
session.findById("wnd[0]/usr/ctxtS_DATE-LOW").caretPosition = 2
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = "29.08.2015"
session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 2
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373c"
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").caretPosition = 4
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").text = "73C10012"
session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").caretPosition = 8
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[46]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp"
session.findById("wnd[1]/usr/ctxtDY_PATH").setFocus
session.findById("wnd[1]/usr/ctxtDY_PATH").caretPosition = 7
session.findById("wnd[1]").sendVKey 0
