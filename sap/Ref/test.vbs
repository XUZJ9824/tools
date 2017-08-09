set WshShell = CreateObject("WScript.Shell")
Set proc = WshShell.Exec("C:\Program Files\SAP\FrontEnd\SAPgui\saplogon.exe")
            Do While proc.Status = 0
            WScript.Sleep 100
      Loop

Set SapGui = GetObject("SAPGUI")
Set Appl = SapGui.GetScriptingEngine

Set Connection = Appl.Openconnection("SAP HTSC", True)
Set session = Connection.Children(0)
session.findById("wnd[0]/usr/txtRSYST-BNAME").Text = "User"
session.findById("wnd[0]/usr/pwdRSYST-BCODE").Text = "Password11"
session.findById("wnd[0]/usr/txtRSYST-LANGU").Text = "E"
session.findById("wnd[0]").sendVKey 0