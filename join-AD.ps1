# Replace the parameters with your own values
param (
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$true)]
  [string]$AdministratorPassword
)

Set-DnsClientServerAddress -InterfaceIndex 1 -ServerAddresses ("10.11.11.11","168.63.129.16")

Install-PackageProvider -Name NuGet -Force
#installeren van microsoft entraID en andere benodigte packages
Install-Module MicrosoftEntraID -Force -Confirm:$false


# Import the Microsoft Entra ID module
Import-Module MicrosoftEntraID

# Connect to the Microsoft Entra tenant
Connect-MicrosoftEntraID -TenantId $env:TenantId

# Get the managed domain details
$managedDomain = Get-MicrosoftEntraIDManagedDomain -Name $DomainName

# Join the VM to the managed domain
$joinResult = Add-MicrosoftEntraIDComputerToManagedDomain -ManagedDomain $managedDomain -AdministratorPassword $AdministratorPassword

# Check the join result
if ($joinResult.IsSuccess) {
  Write-Output "Successfully joined the VM to the managed domain $DomainName"
} else {
  Write-Error "Failed to join the VM to the managed domain $DomainName. Error: $joinResult.Error"
}
