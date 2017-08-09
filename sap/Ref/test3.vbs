''Dim sapConn As Object 'Declare connection object
Set sapConn = CreateObject("SAP.LogonControl.1") 'Create ActiveX object
'Specify user
sapConn.User = "E427632"
'Then password
sapConn.Password = "Honey1505!"
sapConn.SystemNumber = "03"
'Client
sapConn.Client = "900"
'Target server address
sapConn.ApplicationServer = "erpprod.honeywell.com"
'Language code
sapConn.Language = "EN"

sapConn.AboutBox
sapConn.NewConnection