# Replace the parameters with your own values
param (
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$true)]
  [string]$AdministratorPassword
)

$interfaces = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object { $_.ServerAddresses -ne $null }
Set-DnsClientServerAddress -InterfaceAlias $interfaces.InterfaceAlias -ServerAddresses ("10.11.11.11","168.63.129.16")

Restart-Computer -Wait

$Cred = New-Object System.Management.Automation.PSCredential ("adminuser", (ConvertTo-SecureString $AdministratorPassword -AsPlainText -Force))
Add-Computer -DomainName $DomainName -Credential $Cred -Restart

# Check the join result
if ($joinResult.IsSuccess) {
  Write-Output "Successfully joined the VM to the managed domain $DomainName"
} else {
  Write-Error "Failed to join the VM to the managed domain $DomainName. Error: $joinResult.Error"
}
