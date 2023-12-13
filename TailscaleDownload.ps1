Invoke-WebRequest -Uri "https://pkgs.tailscale.com/stable/tailscale-setup-latest.exe" -OutFile ".\Tailscale-Setup.exe"
Start-Process -FilePath ".\Tailscale-Setup.exe" -ArgumentList "/S" -Wait
Remove-Item ".\Tailscale-Setup.exe"
