# Honestly not sure where I found this bootstrap script, but I've stripped it down to basics.
# Apologies to the original author for not crediting.

# windows powershell bootstrap script
$host.ui.RawUI.WindowTitle = "Bootstrapping Windows"

# supress network location Prompt
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

# set network to private
$ifaceinfo = Get-NetConnectionProfile

# enable winrm on http
set-wsmanquickconfig -force

# config winrm settings to work with packer
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="2048"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'
winrm set winrm/config/winrs '@{MaxConcurrentUsers="200"}'
winrm set winrm/config/winrs '@{MaxShellsPerUser="200"}'

#Stop windows updtes from starting immediatly
$WUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$WUSettings.NotificationLevel=1
$WUSettings.save()

#Kill Server Manager
Get-Process "ServerManager" | Stop-Process

#Add WinRM firewall rule
New-NetFirewallRule -DisplayName 'WinRM-Packer-Temp' -Profile @('Domain', 'Private','Public') -Direction Inbound -Action Allow -Protocol TCP -LocalPort 5985

#install VMware Tools
mkdir C:\Temp
Write-Host "Install VMware Tools..."
E:\Setup64.exe /S /v/qn
#"/qn REBOOT=R ADDLOCAL=ALL" /l C:\Temp\VMwareToolsInstall.log



