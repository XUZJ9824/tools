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

ST = Date - Weekday(Date, vbMonday) - 6
ET = Date - Weekday(Date, vbMonday)
TT = Date

If Month(ST) > 9 Then
   If Day(ST) > 9 Then
      ST = Year(ST) & Month(ST) & Day(ST)
   Else
      ST = Year(ST) & Month(ST) & "0" & Day(ST)
   End If
Else
   If Day(ST) > 9 Then
      ST = Year(ST) & "0" & Month(ST) & Day(ST)
   Else
      ST = Year(ST) & "0" & Month(ST) & "0" & Day(ST)
   End If
End If
If Month(ET) > 9 Then
   If Day(ET) > 9 Then
      ET = Year(ET) & Month(ET) & Day(ET)
   Else
      ET = Year(ET) & Month(ET) & "0" & Day(ET)
   End If
Else
   If Day(ET) > 9 Then
      ET = Year(ET) & "0" & Month(ET) & Day(ET)
   Else
      ET = Year(ET) & "0" & Month(ET) & "0" & Day(ET)
   End If
End If
If Month(TT) > 9 Then
   If Day(TT) > 9 Then
      TT = Year(TT) & Month(TT) & Day(TT)
   Else
      TT = Year(TT) & Month(TT) & "0" & Day(TT)
   End If
Else
   If Day(TT) > 9 Then
      TT = Year(TT) & "0" & Month(TT) & Day(TT)
   Else
      TT = Year(TT) & "0" & Month(TT) & "0" & Day(TT)
   End If
End If

session.findById("wnd[0]").maximize
session.findById("wnd[0]/tbar[0]/okcd").text = "ZHREMPEFF"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/btn%_S_BUKRS_%_APP_%-VALU_PUSH").press
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,0]").text = "373c"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").text = "385c"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").setFocus
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").caretPosition = 4
session.findById("wnd[1]/tbar[0]/btn[8]").press
session.findById("wnd[0]/usr/btn%_S_KOSTL_%_APP_%-VALU_PUSH").press
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,0]").text = "373C100011"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").text = "385C100107"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,2]").text = "385C100160"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,3]").text = "373C100028"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").setFocus
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").caretPosition = 10
session.findById("wnd[1]/tbar[0]/btn[8]").press
session.findById("wnd[0]").sendVKey 4
session.findById("wnd[1]/usr/cntlCONTAINER/shellcont/shell").selectionInterval = ST & "," & ST
session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 9
session.findById("wnd[0]").sendVKey 4
session.findById("wnd[1]/usr/cntlCONTAINER/shellcont/shell").selectionInterval = ET & "," & ET
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[46]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]").sendVKey 0
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Users\e585135\Desktop\SAP\Employee Effort Report\D&G - Fiscal"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Employee Effort Report from " & ST & " to " & ET & " - " & TT & ".XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 54
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[0]/tbar[0]/okcd").text = "/n"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRDAYWISE"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373C"
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").caretPosition = 4
session.findById("wnd[0]/usr/btn%_S_BUKRS_%_APP_%-VALU_PUSH").press
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").text = "385C"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").setFocus
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").caretPosition = 4
session.findById("wnd[1]/tbar[0]/btn[8]").press
session.findById("wnd[0]/usr/btn%_S_KOSTL_%_APP_%-VALU_PUSH").press
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,0]").text = "373C100011"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").text = "385C100107"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,2]").text = "385C100160"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,3]").text = "373C100028"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").setFocus
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").caretPosition = 10
session.findById("wnd[1]/tbar[0]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[46]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]").sendVKey 0
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Users\e585135\Desktop\SAP\Day-wise Timesheet Report\D&G"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Day-wise Timesheet Report from " & ST & " to " & ET & " - " & TT & ".XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 7
session.findById("wnd[1]/tbar[0]/btn[11]").press
session.findById("wnd[0]/tbar[0]/okcd").text = "/n"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/tbar[0]/okcd").text = "ZPSAIPROJDET"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/ctxtP_NWTYPE").text = "OUTCHB"
session.findById("wnd[0]/usr/ctxtP_NWTYPE").caretPosition = 6
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]").sendVKey 0
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Users\e585135\Desktop\SAP\Aero Interface Project Details"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Aero Interface Project Details - " & TT & " - BJ.XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 37
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[0]/tbar[0]/btn[3]").press
session.findById("wnd[0]/usr/ctxtP_NWTYPE").text = "OUTCHS"
session.findById("wnd[0]/usr/ctxtP_NWTYPE").caretPosition = 6
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]").sendVKey 0
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Users\e585135\Desktop\SAP\Aero Interface Project Details"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Aero Interface Project Details - " & TT & " - SH.XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 44
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[0]/tbar[0]/okcd").text = "/n"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRLEAVE"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3").select
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3/ssubSUB3:ZHRR_LEAVE_SCREEN:0105/lblGV_DET").setFocus
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3/ssubSUB3:ZHRR_LEAVE_SCREEN:0105/lblGV_DET").caretPosition = 9
session.findById("wnd[0]").sendVKey 2
session.findById("wnd[0]/usr/ctxtP_WERKS-LOW").text = "HTSS"
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").caretPosition = 0
session.findById("wnd[0]").sendVKey 4
session.findById("wnd[1]/usr/cntlCONTAINER/shellcont/shell").selectionInterval = ST & "," & ST
session.findById("wnd[0]/usr/ctxtS_ENDDA-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_ENDDA-LOW").caretPosition = 0
session.findById("wnd[0]").sendVKey 4
session.findById("wnd[1]/usr/cntlCONTAINER/shellcont/shell").selectionInterval = ET & "," & ET
session.findById("wnd[0]/usr/radRD2").setFocus
session.findById("wnd[0]/usr/radRD2").select
session.findById("wnd[0]/usr/btn%_P_CCG1_%_APP_%-VALU_PUSH").press
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,0]").text = "373c100011"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").text = "385C100107"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,2]").text = "385C100160"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,3]").text = "373C100028"
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").setFocus
session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/ctxtRSCSEL-SLOW_I[1,1]").caretPosition = 10
session.findById("wnd[1]").sendVKey 8
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]").sendVKey 0
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Users\e585135\Desktop\SAP\Leave Report\D&G"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Leave Report from " & ST & " to " & ET & " - SH - " & TT & ".XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").setFocus
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 49
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[0]/tbar[0]/btn[3]").press
session.findById("wnd[0]/usr/radRD1").setFocus
session.findById("wnd[0]/usr/radRD1").select
session.findById("wnd[0]/usr/ctxtP_BUKRS").text = "373C"
session.findById("wnd[0]/usr/ctxtP_WERKS-LOW").text = "HTSB"
session.findById("wnd[0]/usr/radRD2").setFocus
session.findById("wnd[0]/usr/radRD2").select
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]").sendVKey 0
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Users\e585135\Desktop\SAP\Leave Report\D&G"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Leave Report from " & ST & " to " & ET & " - BJ - " & TT & ".XLS"
session.findById("wnd[1]/tbar[0]/btn[0]").press

session.findById("wnd[0]/tbar[0]/okcd").text = "/n"
session.findById("wnd[0]").sendVKey 0
