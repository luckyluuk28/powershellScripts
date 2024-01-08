param (
  [Parameter(Mandatory=$true)]
  [string]$DomainName,
  [Parameter(Mandatory=$true)]
  [string]$AdministratorPassword
)

powershell -ExecutionPolicy bypass -File office-proplus-deployment.ps1 -OfficeVersion Office2016
powershell -ExecutionPolicy bypass -File 7ZipSetup.ps1
powershell -ExecutionPolicy bypass -File join-AD.ps1 -IpAddress '10.11.11.11' -Username 'adminuser' -DomainName $DomainName -Password $AdministratorPassword
