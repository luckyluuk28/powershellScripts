# Replace the parameters with your own values
param (
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$true)]
  [string]$AdministratorPassword
)

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ForceInstall
#installeren van microsoft entraID en andere benodigte packages
Install-Module MicrosoftEntraID -Force


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
