# Download WinSyslog-installatiekopie
Invoke-WebRequest -Uri "https://download.adiscon.com/wnsyslog162.exe" -OutFile ".\WinSyslogSetup.exe"

# Voer de installatie uit
Start-Process -FilePath ".\WinSyslogSetup.exe" -ArgumentList "/S" -Wait

Remove-Item ".\WinSyslogSetup.exe"
