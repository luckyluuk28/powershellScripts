param (
  [Parameter(Mandatory=$true)]
  [string]$IpAddress,
  [Parameter(Mandatory=$true)]
  [string]$Username,
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$false)]
  [securestring]$Password
)

Set-TimeZone -Id "W. Europe Standard Time"  

New-Item -ItemType Directory -Path "C:\Program Files\Splunk"
Invoke-WebRequest -Uri "https://download.splunk.com/products/universalforwarder/releases/9.1.2/windows/splunkforwarder-9.1.2-b6b9c8185839-x64-release.msi" -OutFile "C:\Program Files\Splunk\splunkforwarder.msi"
Start-Process msiexec.exe -Wait -ArgumentList '/i "C:\Program Files\Splunk\splunkforwarder.msi" DEPLOYMENT_SERVER="10.1.0.31:8089" RECEIVING_INDEXER="10.1.0.31:9997" LAUNCHSPLUNK=1 SERVICESTARTTYPE=auto WINEVENTLOG_APP_ENABLE=1 WINEVENTLOG_SEC_ENABLE=1 WINEVENTLOG_SYS_ENABLE=1 WINEVENTLOG_FWD_ENABLE=1 WINEVENTLOG_SET_ENABLE=1 ENABLEADMON=1 SPLUNKPASSWORD="Kaaseter!1" PRIVILEGEBACKUP=1 PRIVILEGESECURITY=1 AGREETOLICENSE=yes /quiet /qn"' 

New-Item -ItemType Directory -Path "C:\Program Files\WindowsExporter"
Invoke-WebRequest -Uri "https://github.com/prometheus-community/windows_exporter/releases/download/v0.25.1/windows_exporter-0.25.1-amd64.msi" -OutFile "C:\Program Files\WindowsExporter\windows_exporter-amd64.msi"
Start-Process -FilePath "msiexec" -ArgumentList '/i "C:\Program Files\WindowsExporter\windows_exporter-amd64.msi"  /qn' -Wait

$dlurl = 'https://7-zip.org/' + (Invoke-WebRequest -UseBasicParsing -Uri 'https://7-zip.org/' | Select-Object -ExpandProperty Links | Where-Object {($_.outerHTML -match 'Download')-and ($_.href -like "a/*") -and ($_.href -like "*-x64.exe")} | Select-Object -First 1 | Select-Object -ExpandProperty href)
$installerPath = Join-Path $env:TEMP (Split-Path $dlurl -Leaf)
Invoke-WebRequest $dlurl -OutFile $installerPath
Start-Process -FilePath $installerPath -Args "/S" -Verb RunAs -Wait
Remove-Item $installerPath

powershell -ExecutionPolicy bypass -File office-proplus-deployment.ps1 -OfficeVersion Office2016

$interfaces = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses -ne $null }
Set-DnsClientServerAddress -InterfaceAlias $interfaces.InterfaceAlias -ServerAddresses ($IpAddress,"168.63.129.16")

$DomainUser = $Username + '@' + $DomainName

$Cred = New-Object System.Management.Automation.PSCredential ($DomainUser, $Password)
Add-Computer -DomainName $DomainName -Credential $Cred

Restart-Computer -Force -Wait
