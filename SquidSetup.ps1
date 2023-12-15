https://packages.diladele.com/squid/4.14/squid.msi

Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux


# Define variables
$downloadUrl = "http://www.squid-cache.org/Versions/v6/squid-6.6.tar.gz"
$downloadPath = "C:\Squid"
$port = 3128
$newPorts = @(3130, 3131)  # Additional ports to be configured

# Step 1: Download and extract Squid proxy
Invoke-WebRequest -Uri $downloadUrl -OutFile "$downloadPath\squid.tar.gz"
Expand-Archive -Path "$downloadPath\squid.tar.gz" -DestinationPath $downloadPath -Force

# Step 2: Rename files in C:\Squid\etc folder
Get-ChildItem -Path "$downloadPath\squid\etc" -Filter "*default*" | Rename-Item -NewName { $_.Name -replace ' default', '' }

# Step 3: Create swap directory
Set-Location -Path "$downloadPath\squid\sbin"
.\squid.exe -z

# Step 4: Install Squid as a Windows Service
.\squid.exe -i

# Step 5: Start and stop Squid service
# (Manual action: Start/Stop service from services.msc)

# Step 6: Setup Windows firewall for Squid proxy
New-NetFirewallRule -DisplayName "Squid_Services" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow -Profile Domain, Public, Private

# Step 7: Adding multiple IPs with different ports
foreach ($newPort in $newPorts) {
    $newIP = "45.XX1.1XX.2XX"
    # Modify squid.conf with the required configurations for each new port and IP
    Add-Content -Path "$downloadPath\squid\etc\squid.conf" -Value "http_port $newIP:$newPort`n`r acl myip_$newIP myip $newIP`n`r tcp_outgoing_address $newIP myip_$newIP`n`r http_access allow myip_$newIP"
}

# Restart Squid service (Manual action: Restart service from services.msc)
