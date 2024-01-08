param (
  [Parameter(Mandatory=$true)]
  [string]$IpAddress
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$true)]
  [string]$Username
  [Parameter(Mandatory=$true)]
  [string]$Password
)

powershell -ExecutionPolicy bypass -File office-proplus-deployment.ps1 -OfficeVersion Office2016
powershell -ExecutionPolicy bypass -File 7ZipSetup.ps1
powershell -ExecutionPolicy bypass -File join-AD.ps1 -IpAddress $IpAddress -Username $Username -DomainName $DomainName -Password $Password
