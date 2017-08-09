Rem Create the GuiApplication object
Set Application = CreateObject("Sapgui.ScriptingCtrl.1")

Rem Open a connection in synchronous mode
Set Connection  = Application.OpenConnection("SAP HTSC", True)
Rem Set Connection  = Application.OpenConnection("SAP HTSC", False)
Set Session     = Connection.Children(0)

Rem Do something: Either fill out the login screen 
Rem or in case of Single-Sign-On start a transaction.
Session.SendCommand("/ncj20n")

MsgBox "Waiting..."

Rem Shutdown the connection
Set Session     = Nothing
Connection.CloseSession("ses[0]")
Set Connection  = Nothing

Rem Wait a bit for the connection to be closed completely
Wscript.Sleep 1000
Set Application = Nothing

MsgBox "Done"
