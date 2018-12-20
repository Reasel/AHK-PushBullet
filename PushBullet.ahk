#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#SingleInstance force
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input

PB_DebugMessage(msg)
{
  ; Debug Test message, 
	return PB_PushNote("[Debug]", msg, "<Insert Debug channel name here>")
}

; Will capture and send the current window to the debug channel
PB_WindowCap()
{
	clipboard = ; Empty the clipboard
	Send {PrintScreen} ; Bound in ShareX to be "Capture Active Window"
	ClipWait ; Wait till after ShareX uploads the image so that the Imgur URL is copied to the clipboard.
	return PB_PushLink("Screenshot Upload", "Screenshot sent from AHK.", Clipboard)
}

PB_PushLink(PB_Title, PB_Message, PB_URL)
{
	return DoPB("POST", "https://api.pushbullet.com/v2/pushes", "{""type"": ""link"", ""title"": """ PB_Title """, ""body"": """ PB_Message """, ""url"": """ PB_URL """, ""channel_tag"": ""tannerdebug""}")
}

PB_PushNote(PB_Title, PB_Message, tag="")
{
	if (tag = "")
	{
		return DoPB("POST", "https://api.pushbullet.com/v2/pushes", "{""type"": ""note"", ""title"": """ PB_Title """, ""body"": """ PB_Message """}")
	}
	else
	{
		return DoPB("POST", "https://api.pushbullet.com/v2/pushes", "{""type"": ""note"", ""title"": """ PB_Title """, ""body"": """ PB_Message """, ""channel_tag"": """ tag """}")
	}
}

ListSubs()
{
	return DoPB("GET", "https://api.pushbullet.com/v2/subscriptions")
}

PBDebug(Message)
{
	return DoPB("POST", "https://api.pushbullet.com/v2/pushes", "{""type"": ""note"", ""title"": ""Debug Info"", ""body"": """ PB_Message """, ""channel_iden"": ""<Insert Debug Channel iden here>""}")
}


DoPB(type, URL, body="", contentType="application/json")
{
  ; Insert your PushBullet API Token here
	PB_Token   := ""
	
	WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
	WinHTTP.SetProxy(0)
	WinHTTP.Open(type, URL, 0)
	WinHTTP.SetCredentials(PB_Token, "", 0)
	WinHTTP.SetRequestHeader("Content-Type", contentType)
	WinHTTP.Send(body)
	Result := WinHTTP.ResponseText
	Status := WinHTTP.Status
	
	clipboard = %Result%
	return Result
}
