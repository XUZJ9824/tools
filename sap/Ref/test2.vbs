''Dim sapConn As Object 'Declare connection object
Set sapConn = CreateObject("SAP.Functions") 'Create ActiveX object

''sapConn.AboutBox

'Specify user
sapConn.Connection.user = "e427632"
'Then password
sapConn.Connection.Password = "Honey1505!"
sapConn.Connection.SystemNumber = "03"
'Client
sapConn.Connection.client = "900"
'Target server address
sapConn.Connection.ApplicationServer = "erpprod.honeywell.com"
'Language code
sapConn.Connection.Language = "EN"

If sapConn.Connection.logon(0, True) <> True Then
    MsgBox "Cannot Log on to SAP" 'Issue message if cannot logon
Else
    MsgBox "Logged on to SAP!"
end if