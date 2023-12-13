# Download WinSyslog-installatiekopie
Invoke-WebRequest -Uri "https://download.adiscon.com/wnsyslog162.exe" -OutFile "C:\Temp\WinSyslogSetup.exe"

# Voer de installatie uit
Start-Process -FilePath "C:\Temp\WinSyslogSetup.exe" -ArgumentList "/S" -Wait
