# Download and save this script as AD-aanmaken.ps1 in a folder of your choice
# Replace the parameters with your own values
param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,
    [Parameter(Mandatory=$true)]
    [string]$NetbiosName,
    [Parameter(Mandatory=$true)]
    [string]$DomainMode,
    [Parameter(Mandatory=$true)]
    [securestring]$SafeModeAdministratorPassword
)

# Import the Server Manager module
Import-Module ServerManager

# Install the AD DS role
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Import the Active Directory module
Import-Module ActiveDirectory

# Create a new domain
New-ADDomain -Name $DomainName -NetbiosName $NetbiosName -DomainMode $DomainMode -SafeModeAdministratorPassword $SafeModeAdministratorPassword

# Download and install the NPS extension for Microsoft Entra multifactor authentication
Invoke-WebRequest -Uri 'https://aka.ms/npsmfa' -OutFile 'npsmfa_setup.exe'
Start-Process -FilePath 'npsmfa_setup.exe' -ArgumentList '/quiet' -Wait

# Configure the NPS server for RADIUS authentication
# Register the NPS server with Microsoft Entra
Register-AzureMfaNpsServer -TenantId '<your-tenant-id>' -ClientId '<your-client-id>' -ClientSecret '<your-client-secret>'
# Add a RADIUS client
New-NpsRadiusClient -Name 'VPN Server' -Address '<your-vpn-server-ip>' -SharedSecret '<your-shared-secret>'
# Create a connection request policy
New-NpsConnectionRequestPolicy -Name 'Microsoft Entra MFA' -Enabled $true -ProcessingOrder 1 -PolicyCondition @{ClientIPv4Address='<your-vpn-server-ip>'} -AuthenticationProvider @{Type='Windows'}
# Create a network policy
New-NpsNetworkPolicy -Name 'Microsoft Entra MFA' -Enabled $true -ProcessingOrder 1 -PolicyCondition @{WindowsGroups='<your-domain>\Domain Users'} -Grant @{AccessPermission='GrantAccess'} -AuthenticationProvider @{Type='Windows'} -EapConfiguration '<your-eap-configuration>'

# Enable the NPS extension for Microsoft Entra multifactor authentication
Enable-NpsExtension -Name 'Microsoft Entra MFA' -Version '1.0'
