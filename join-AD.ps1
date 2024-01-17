# Replace the parameters with your own values
param (
  [Parameter(Mandatory=$false)]
  [string]$IpAddress = '10.11.11.111',
  [Parameter(Mandatory=$false)]
  [string]$Username = 'adminuser',
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$true)]
  [string]$Password
)

$interfaces = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses -ne $null }
Set-DnsClientServerAddress -InterfaceAlias $interfaces.InterfaceAlias -ServerAddresses ($IpAddress,"168.63.129.16")

$DomainUser = $Username + '@' + $DomainName

$Cred = New-Object System.Management.Automation.PSCredential ($DomainUser, (ConvertTo-SecureString $Password -AsPlainText -Force))
Add-Computer -DomainName $DomainName -Credential $Cred

Restart-Computer -Force -Wait
