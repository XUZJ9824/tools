REM: we must change SAPGUI option ( Alt+F12 ) to disable warning dialogue 
REM: when a SAP script connect to SAP GUI.

dim bChoseManulMonth

localSAPProfile = "SAP HTSC"

curYear = year(Now)
curMonth = Month(Now)
curDay = Day(Now)

bChoseManulMonth = 0 Rem: switch manual month or auto mode.

if( bChoseManulMonth = 1 ) then
	inputFiscalM = Inputbox("Input Fiscal Month")

	if( not isempty(inputFiscalM) ) then
		 curMonth = inputFiscalM
		 curDay = 10
	end if
end if

lowDate = "01.12.2016" Rem: start date for effort report
highDate = "31.12.2016" Rem: End date for effort report

set_fiscal_month lowDate, highDate

'msgbox lowDate & highDate

REM curMonth = DatePart("m", Now )
REM curDay = DatePart("d", Now )


rem lowDate = "2015/07/26" Rem: start date for effort report
rem highDate = "2015/08/22" Rem: End date for effort report
REM tmpDate = InputBox("Input Start Date", "SAP Effort Report", lowDate)
REM     if IsDate( tmpDate ) then
REM         lowDate = DatePart("d", tmpDate) & "." & DatePart("m", tmpDate) & "." & DatePart("yyyy", tmpDate)
REM     else 
REM         MsgBox "Invalid Date " & tmpDate & ", we use default : " & lowDate
REM     end if

REM tmpDate = InputBox("Input End Date", "SAP Effort Report", highDate)
REM     if IsDate( tmpDate ) then
REM         highDate = DatePart("d", tmpDate) & "." & DatePart("m", tmpDate) & "." & DatePart("yyyy", tmpDate)
REM    else
REM         MsgBox "Invalid Date" & tmpDate & ", we use default : " & highDate
REM     end if

Rem Create the GuiApplication object
Set Application = CreateObject("Sapgui.ScriptingCtrl.1")

Rem Open a connection in synchronous mode
Set Connection  = Application.OpenConnection(localSAPProfile, True)
Rem Set Connection  = Application.OpenConnection("SAP HTSC", False)
Set session     = Connection.Children(0)

'On error resume next

Opt1 = WScript.Arguments.Item(0) 'DAYWISE or ALL or ...

if Opt1 = "" then
	Opt1 = "ALL" 'default to all
end if

'msgbox "Parameter = " & Opt1

if Opt1 = "DAYWISE" then
	Generate_Daywise_Report	
elseif Opt1 = "ETC" then
    Generate_ETC_Effort
elseif Opt1 = "LEAVE" then
    Generate_Leave_Report_BJ
    'Generate_Leave_Report_SH
elseif Opt1 = "EFFORT" then
	Generate_Effort_With_Approved
	Generate_Effort_With_Non_Approved
elseif Opt1 = "ALL" then
	Generate_Effort_By_Now
	Generate_Daywise_Report
	Generate_Effort_With_Approved
	Generate_Effort_With_Non_Approved
	Generate_ETC_Effort
end if

Rem Shutdown the connection
Set session     = Nothing
Connection.CloseSession("ses[0]")
Set Connection  = Nothing

Rem Wait a bit for the connection to be closed completely
Wscript.Sleep 1000
Set Application = Nothing

Public Sub Xls2Xlsx(ByVal fileXls)
        Dim fileXLSX
		Set filesys = CreateObject("Scripting.FileSystemObject")
		
		fileXLSX = fileXls & "X"
		If filesys.FileExists(fileXLSX) Then 
			filesys.DeleteFile(fileXLSX)
		End If
		
        Set ExcelApp = CreateObject("Excel.Application")
        Set ExcelXls = ExcelApp.Workbooks.Open(fileXls)
        ExcelXls.SaveAs fileXls & "X",51
        ExcelXls.Close
		
        Set ExcelXls = Nothing
        ExcelApp.Quit
        Set ExcelApp = Nothing	
		
        If filesys.FileExists(fileXLSX) Then 	
			filesys.DeleteFile(fileXls)			
		End If 
End	Sub

public sub Generate_Daywise_Report
    If curMonth < 3 Then 
		tmpMonth = 1
	Else
		tmpMonth = curMonth - 2
    End If
	
	'iWeekday = Weekday(Now(), vbFriday)
	iWeekday = Weekday(Now(), vbSunday)
    LastSunday = Now - (iWeekday - 1)		   
	
    strInit = "01" & "." & tmpMonth & "." & Year(Now)
	if( tmpMonth = 1 ) then
		strInit = "01" & "." & 12 & "." & (Year(Now) - 1)
	end if
	
	strNow = Day(LastSunday) & "." & Month(LastSunday) & "." & Year(LastSunday)
	'msgbox strNow
	
	session.findById("wnd[0]").maximize
	session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRDAYWISE"
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373c"
	session.findById("wnd[0]/usr/ctxtS_KOSTL-LOW").text = "373C100012"
	session.findById("wnd[0]/usr/ctxtS_KOSTL-LOW").setFocus
	session.findById("wnd[0]/usr/ctxtS_KOSTL-LOW").caretPosition = 10
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/radR3").setFocus
	session.findById("wnd[0]/usr/radR3").select
	session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = strInit
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = strNow
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 9
	session.findById("wnd[0]/tbar[1]/btn[8]").press
	session.findById("wnd[0]/tbar[1]/btn[46]").press
	session.findById("wnd[0]/tbar[1]/btn[45]").press
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
	session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "BJ_Daywise_Effort.XLS"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 21
	'session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/tbar[0]/btn[11]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	
	session.findById("wnd[0]").maximize
	session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRDAYWISE"
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "385c"
	session.findById("wnd[0]/usr/ctxtS_KOSTL-LOW").text = "385C100108"
	session.findById("wnd[0]/usr/ctxtS_KOSTL-LOW").setFocus
	session.findById("wnd[0]/usr/ctxtS_KOSTL-LOW").caretPosition = 10
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/radR3").setFocus
	session.findById("wnd[0]/usr/radR3").select
	session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = strInit
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = strNow
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 9
	session.findById("wnd[0]/tbar[1]/btn[8]").press
	session.findById("wnd[0]/tbar[1]/btn[46]").press
	session.findById("wnd[0]/tbar[1]/btn[45]").press
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
	session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "SH_Daywise_Effort.XLS"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 21
	'session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/tbar[0]/btn[11]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	
	REM copy file to share drive,
    set filesys=CreateObject("Scripting.FileSystemObject")
    rem If filesys.FileExists("c:\sourcefolder\anyfile.txt") Then
    strResultBJ = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "BJ_Daywise_Effort_" & curYear & ".XLS"
    strResultSH = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "SH_Daywise_Effort_" & curYear & ".XLS"
		
    If filesys.FileExists(strResultBJ) Then filesys.DeleteFile(strResultBJ)
    filesys.CopyFile "c:\TEMP\BJ_Daywise_Effort.XLS", strResultBJ

    If filesys.FileExists(strResultSH) Then filesys.DeleteFile(strResultSH)
    filesys.CopyFile "c:\TEMP\SH_Daywise_Effort.XLS", strResultSH
	
	set filesys = nothing
		
	Xls2Xlsx strResultBJ
	Xls2Xlsx strResultSH
	
end sub

public sub Generate_Effort_With_Non_Approved
 ''''''''''''''''''''Record From SAP Scripting Shanghai With Un-Approved''''''''''
    session.findById("wnd[0]").maximize
    session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRTASKGRP"
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = lowDate
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = highDate
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 10
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "385c"
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").text = "85C10108"
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").setFocus
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").caretPosition = 8
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    session.findById("wnd[0]/tbar[1]/btn[46]").press
    session.findById("wnd[0]/tbar[1]/btn[45]").press
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "SH_Effort_With_Non_Approved.XLS"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 9
    session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	if err.number <> 0  then
	rem MsgBox "Error1: num " & Err.Number & " Desc: " & Err.Description
	end if

    ''''''''''''''''''''Record From SAP Scripting Beijing With Un-Approved''''''''''
    session.findById("wnd[0]").maximize
    session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRTASKGRP"
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = lowDate
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = highDate
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 10
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373c"
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").text = "73C10012"
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").setFocus
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").caretPosition = 8
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    session.findById("wnd[0]/tbar[1]/btn[46]").press
    session.findById("wnd[0]/tbar[1]/btn[45]").press
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "BJ_Effort_With_Non_Approved.XLS"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 9
    session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    
	if err.number <> 0  then
	rem MsgBox "Error2: num " & Err.Number & " Desc: " & Err.Description
	end if

    REM copy file to share drive,
    set filesys=CreateObject("Scripting.FileSystemObject")
    rem If filesys.FileExists("c:\sourcefolder\anyfile.txt") Then
    strResultBJ = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "CNS_BJ_Effort_With_Non_Approved_Fiscal_" & curMonth & ".XLS"
    strResultSH = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "CNS_SH_Effort_With_Non_Approved_Fiscal_" & curMonth & ".XLS"

    If filesys.FileExists(strResultBJ) Then filesys.DeleteFile(strResultBJ)
    filesys.CopyFile "c:\TEMP\BJ_Effort_With_Non_Approved.XLS", strResultBJ

    If filesys.FileExists(strResultSH) Then filesys.DeleteFile(strResultSH)
    filesys.CopyFile "c:\TEMP\SH_Effort_With_Non_Approved.XLS", strResultSH
	set filesys = nothing
		
	Xls2Xlsx strResultBJ
	Xls2Xlsx strResultSH
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
end sub

public sub Generate_Effort_With_Approved
    ''''''''''''''''''''Record From SAP Scripting Beijing''''''''''''''''''''''''''''''''''
    session.findById("wnd[0]").maximize
    session.findById("wnd[0]/tbar[0]/okcd").text = "ZHREMPEFF"
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = lowDate
    session.findById("wnd[0]/usr/ctxtS_DATE-LOW").caretPosition = 2
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = highDate
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 1
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373c"
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").setFocus
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").caretPosition = 4
    session.findById("wnd[0]").sendVKey 0
    Rem session.findById("wnd[0]/usr/ctxtS_PERNR-LOW").text = "427632"
    Rem session.findById("wnd[0]/usr/ctxtS_PERNR-LOW").setFocus
    Rem session.findById("wnd[0]/usr/ctxtS_PERNR-LOW").caretPosition = 2
    Rem session.findById("wnd[0]").sendVKey 0
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
    session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Temp"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "BJ_Effort.XLS"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 2
    session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	if err.number <> 0  then
	rem MsgBox "Error3: num " & Err.Number & "Desc " & Err.Description
	end if
    ''''''''''''''''''''Record From SAP Scripting Shanghai''''''''''''''''''''''''''
    session.findById("wnd[0]").maximize
    session.findById("wnd[0]/tbar[0]/okcd").text = "ZHREMPEFF"
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = lowDate
    session.findById("wnd[0]/usr/ctxtS_DATE-LOW").caretPosition = 2
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = highDate
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
    session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 1
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "385c"
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").setFocus
    session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").caretPosition = 4
    session.findById("wnd[0]").sendVKey 0
    Rem session.findById("wnd[0]/usr/ctxtS_PERNR-LOW").text = "427632"
    Rem session.findById("wnd[0]/usr/ctxtS_PERNR-LOW").setFocus
    Rem session.findById("wnd[0]/usr/ctxtS_PERNR-LOW").caretPosition = 2
    Rem session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").text = "85C10108"
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").setFocus
    session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").caretPosition = 8
    session.findById("wnd[0]").sendVKey 0
    session.findById("wnd[0]/tbar[1]/btn[8]").press
    session.findById("wnd[0]/tbar[1]/btn[46]").press
    session.findById("wnd[0]/tbar[1]/btn[45]").press
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
    session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
    session.findById("wnd[1]/tbar[0]/btn[0]").press
    session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Temp"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "SH_Effort.XLS"
    session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 2
    session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	if err.number <> 0  then
	rem MsgBox "Error4: num " & Err.Number & "Desc " & Err.Description
	end if
	
    REM copy file to share drive,
    set filesys=CreateObject("Scripting.FileSystemObject")
    rem If filesys.FileExists("c:\sourcefolder\anyfile.txt") Then
    strResultBJ = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "CNS_BJ_Effort_Fiscal_" & curMonth & ".XLS"
    strResultSH = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "CNS_SH_Effort_Fiscal_" & curMonth & ".XLS"

    If filesys.FileExists(strResultBJ) Then filesys.DeleteFile(strResultBJ)
    filesys.CopyFile "c:\TEMP\BJ_Effort.XLS", strResultBJ

    If filesys.FileExists(strResultSH) Then filesys.DeleteFile(strResultSH)
    filesys.CopyFile "c:\TEMP\SH_Effort.XLS", strResultSH
    set filesys = nothing
	
	Xls2Xlsx strResultBJ
	Xls2Xlsx strResultSH
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
end sub

public sub Generate_Effort_By_Now	
    tmpMonth = 1
    
    'If curMonth > 4 Then 	
	'	tmpMonth = curMonth - 3
    'End If
	
    strInit = "01" & "." & tmpMonth & "." & Year(Now)
	
	if( curMonth = 1 ) then
		strInit = "01" & "." & 12 & "." & (Year(Now) - 1)
	end if
	
	strNow = Day(now) & "." & Month(now) & "." & Year(Now)
	'msgbox strNow
	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	session.findById("wnd[0]").maximize
	session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRTASKGRP"
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = strInit
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = strNow
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 2
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373c"
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
	session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Effort_By_Now_BJ.XLS"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 13
	'session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	if err.number <> 0  then
	rem MsgBox "Error5: num " & Err.Number & "Desc " & Err.Description
	end if	
	''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	session.findById("wnd[0]").maximize
	session.findById("wnd[0]/tbar[0]/okcd").text = "ZHRTASKGRP"
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtS_DATE-LOW").text = strInit
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").text = strNow
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").setFocus
	session.findById("wnd[0]/usr/ctxtS_DATE-HIGH").caretPosition = 2
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "385c"
	session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").text = "85C10108"
	session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").setFocus
	session.findById("wnd[0]/usr/ctxtS_ARBPL-LOW").caretPosition = 8
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/tbar[1]/btn[8]").press
	session.findById("wnd[0]/tbar[1]/btn[46]").press
	session.findById("wnd[0]/tbar[1]/btn[45]").press
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
	session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Effort_By_Now_SH.XLS"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 13
	'session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/tbar[0]/btn[11]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    session.findById("wnd[0]/tbar[0]/btn[15]").press
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
	if err.number <> 0  then
	rem MsgBox "Error6: num " & Err.Number & "Desc " & Err.Description
	end if
	
    REM copy file to share drive,
    set filesys=CreateObject("Scripting.FileSystemObject")
    rem If filesys.FileExists("c:\sourcefolder\anyfile.txt") Then
    strResultBJ = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "CNS_BJ_Effort_By_Now.xls"
    strResultSH = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "CNS_SH_Effort_By_Now.xls"

    If filesys.FileExists(strResultBJ) Then filesys.DeleteFile(strResultBJ)
    filesys.CopyFile "c:\TEMP\Effort_By_Now_BJ.XLS", strResultBJ

    If filesys.FileExists(strResultSH) Then filesys.DeleteFile(strResultSH)
    filesys.CopyFile "c:\TEMP\Effort_By_Now_SH.XLS", strResultSH
    set filesys = nothing
	
	Xls2Xlsx strResultBJ
	Xls2Xlsx strResultSH
end sub

Rem: set fiscal month start / end information.
public sub set_fiscal_month( byref DateStart, byref DateEnd )
    select case curMonth
        case "1"
	            DateStart = "30.11.2016" Rem: start date for fiscal month
                DateEnd = "28.01.2017" Rem: End date for fiscal month

                if curDay > 28 Then
                    DateStart = "29.01.2017" Rem: start date for fiscal month
                    DateEnd = "25.02.2017" Rem: End date for fiscal month                    
                    curMonth = 2
                end if 
        case "2"
				DateStart = "29.01.2017" Rem: start date for fiscal month
                DateEnd = "25.02.2017" Rem: End date for fiscal month

                if curDay > 25 Then
                    DateStart = "26.02.2017" Rem: start date for fiscal month
                    DateEnd = "01.04.2017" Rem: End date for fiscal month                    
                    curMonth = 3
                end if 
				
        case "3"
					DateStart = "26.02.2017" Rem: start date for fiscal month
                    DateEnd = "01.04.2017" Rem: End date for fiscal month  
					
        case "4"
				DateStart = "02.04.2017" Rem: start date for fiscal month
                DateEnd = "29.04.2017" Rem: End date for fiscal month
	            
				if curDay < 2 Then
                    DateStart = "26.02.2017" Rem: start date for fiscal month
                    DateEnd = "01.04.2017" Rem: End date for fiscal month  
                    curMonth = 3
                end if
				
				if curDay > 29 then
				    DateStart = "30.04.2017" Rem: start date for fiscal month
                    DateEnd = "27.05.2017" Rem: End date for fiscal month  
                    curMonth = 5
				end if
        case "5"				
				DateStart = "30.04.2017" Rem: start date for fiscal month
                DateEnd = "27.05.2017" Rem: End date for fiscal month
				if curDay > 27 Then
                    DateStart = "28.05.2017" Rem: start date for fiscal month
                    DateEnd = "01.07.2017" Rem: End date for fiscal month  
                    curMonth = 6
                end if

        case "6"				
				DateStart = "28.05.2017" Rem: start date for fiscal month
                DateEnd = "01.07.2017" Rem: End date for fiscal month
				
        case "7"
				DateStart = "02.07.2017" Rem: start date for fiscal month
                DateEnd = "29.07.2017" Rem: End date for fiscal month
				
				if curDay < 2 Then
                    DateStart = "28.05.2017" Rem: start date for fiscal month
                    DateEnd = "01.07.2017" Rem: End date for fiscal month  
                    curMonth = 6				
                end if		
				
				if curDay > 29 Then
                    DateStart = "30.07.2017" Rem: start date for fiscal month
                    DateEnd = "26.08.2017" Rem: End date for fiscal month  
                    curMonth = 8				
                end if		

        case "8"
				DateStart = "30.07.2017" Rem: start date for fiscal month
                DateEnd = "26.08.2017" Rem: End date for fiscal month
				
				if curDay > 26 Then
                    DateStart = "27.08.2017" Rem: start date for fiscal month
                    DateEnd = "01.10.2017" Rem: End date for fiscal month  
                    curMonth = 9				
                end if	 
                
        case "9"
                DateStart = "27.08.2017" Rem: start date for fiscal month
                DateEnd = "01.10.2017" Rem: End date for fiscal month 
		    
                
        case "10"
				DateStart = "01.10.2017" Rem: start date for fiscal month
                DateEnd = "28.10.2017" Rem: End date for fiscal month	
   				
				if curDay > 28 Then
                    DateStart = "29.10.2017" Rem: start date for fiscal month
                    DateEnd = "25.11.2017" Rem: End date for fiscal month  
                    curMonth = 11				
                end if		
				
        case "11"
                DateStart = "29.10.2017" Rem: start date for fiscal month
                DateEnd = "25.11.2017" Rem: End date for fiscal month  
                if curDay > 25 Then
                    DateStart = "26.11.2017" Rem: start date for fiscal month
                    DateEnd = "31.12.2017" Rem: End date for fiscal month             
                    curMonth = 12
                end if  
				
        case "12"        
                DateStart = "26.11.2017" Rem: start date for fiscal month
                DateEnd = "31.12.2017" Rem: End date for fiscal month
        case else
                msgbox "invalid date"
    end Select
end Sub

public sub Generate_ETC_Effort
	
	session.findById("wnd[0]").maximize
	session.findById("wnd[0]/tbar[0]/okcd").text = "zpsaiprojdet"
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtP_NWTYPE").text = "OUTCHB"
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-LOW").text = strStart
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-HIGH").text = strEnd
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-HIGH").setFocus
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-HIGH").caretPosition = 10
	session.findById("wnd[0]/tbar[1]/btn[8]").press
	session.findById("wnd[0]/tbar[1]/btn[45]").press
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
	session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "ETC_Hours_Beijing.XLS"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 21
	session.findById("wnd[1]/tbar[0]/btn[11]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press	
	
	session.findById("wnd[0]").maximize
	session.findById("wnd[0]/tbar[0]/okcd").text = "zpsaiprojdet"
	session.findById("wnd[0]").sendVKey 0
	session.findById("wnd[0]/usr/ctxtP_NWTYPE").text = "OUTCHS"
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-LOW").text = strStart
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-HIGH").text = strEnd
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-HIGH").setFocus
	rem session.findById("wnd[0]/usr/ctxtS_AEROSD-HIGH").caretPosition = 10
	session.findById("wnd[0]/tbar[1]/btn[8]").press
	session.findById("wnd[0]/tbar[1]/btn[45]").press
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
	session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
	session.findById("wnd[1]/tbar[0]/btn[0]").press
	session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\temp\"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "ETC_Hours_Shanghai.XLS"
	session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = 21
	session.findById("wnd[1]/tbar[0]/btn[11]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	session.findById("wnd[0]/tbar[0]/btn[15]").press
	
	REM copy file to share drive,
    set filesys=CreateObject("Scripting.FileSystemObject")
    rem If filesys.FileExists("c:\sourcefolder\anyfile.txt") Then
    strResultBJ = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "ETC_Hours_CNS_BJ_" & curYear & ".XLS"
    strResultSH = "\\Ch01W0103\CNSCOE\Process\SAP\Effort_2017\" & "ETC_Hours_CNS_SH_" & curYear & ".XLS"

    If filesys.FileExists(strResultBJ) Then filesys.DeleteFile(strResultBJ)
    filesys.CopyFile "c:\TEMP\ETC_Hours_Beijing.XLS", strResultBJ

    If filesys.FileExists(strResultSH) Then filesys.DeleteFile(strResultSH)
    filesys.CopyFile "c:\TEMP\ETC_Hours_Shanghai.XLS", strResultSH
    set filesys = nothing
	
	
	Xls2Xlsx strResultBJ
	Xls2Xlsx strResultSH
    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
end sub

public sub Generate_Leave_Report_BJ
dateStart = "13.02.2017"
dateEnd = "31.12.2017"

session.findById("wnd[0]").maximize
session.findById("wnd[0]/tbar[0]/okcd").text = "zhrleave"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3").select
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3/ssubSUB3:ZHRR_LEAVE_SCREEN:0105/lblGV_DET").setFocus
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3/ssubSUB3:ZHRR_LEAVE_SCREEN:0105/lblGV_DET").caretPosition = 5
session.findById("wnd[0]").sendVKey 2
session.findById("wnd[1]/usr/btnBUTTON_1").press
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "373c"
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").text = dateStart
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").caretPosition = 2
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Temp\"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Leave_record_BJ.XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = len("Leave_record_BJ.XLS")
session.findById("wnd[1]/tbar[0]/btn[11]").press
session.findById("wnd[0]/tbar[0]/btn[15]").press
session.findById("wnd[0]/tbar[0]/btn[15]").press
session.findById("wnd[0]/tbar[0]/btn[15]").press

end sub

public sub Generate_Leave_Report_SH
dateStart = "13.02.2017"
dateEnd = "31.12.2017"

session.findById("wnd[0]").maximize
session.findById("wnd[0]/tbar[0]/okcd").text = "zhrleave"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3").select
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3/ssubSUB3:ZHRR_LEAVE_SCREEN:0105/lblGV_DET").setFocus
session.findById("wnd[0]/usr/tabsTABC/tabpTAB3/ssubSUB3:ZHRR_LEAVE_SCREEN:0105/lblGV_DET").caretPosition = 5
session.findById("wnd[0]").sendVKey 2
session.findById("wnd[1]/usr/btnBUTTON_1").press
session.findById("wnd[0]/usr/ctxtS_BUKRS-LOW").text = "385c"
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").text = dateStart
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").setFocus
session.findById("wnd[0]/usr/ctxtS_BEGDA-LOW").caretPosition = 2
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]/tbar[1]/btn[8]").press
session.findById("wnd[0]/tbar[1]/btn[45]").press
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").select
session.findById("wnd[1]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[1,0]").setFocus
session.findById("wnd[1]/tbar[0]/btn[0]").press
session.findById("wnd[1]/usr/ctxtDY_PATH").text = "C:\Temp\"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "Leave_record_SH.XLS"
session.findById("wnd[1]/usr/ctxtDY_FILENAME").caretPosition = len("Leave_record_SH.XLS")
session.findById("wnd[1]/tbar[0]/btn[11]").press
session.findById("wnd[0]/tbar[0]/btn[15]").press
session.findById("wnd[0]/tbar[0]/btn[15]").press
session.findById("wnd[0]/tbar[0]/btn[15]").press

end sub