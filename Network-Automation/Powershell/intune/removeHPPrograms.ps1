# Create a tag file just so Intune knows this was installed
if (-not (Test-Path "$($env:ProgramData)\HP\RemoveHPBloatware"))
{
    Mkdir "$($env:ProgramData)\HP\RemoveHPBloatware"
}
Set-Content -Path "$($env:ProgramData)\HP\RemoveHPBloatware\RemoveHPBloatware.ps1.tag" -Value "Installed"

# Start logging
Start-Transcript "$($env:ProgramData)\HP\RemoveHPBloatware\RemoveHPBloatware.log"

# List of built-in apps to remove
$UninstallPackages = @(
    "AD2F1837.HPEasyClean"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPProgrammableKey"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPWorkWell"
    "AD2F1837.myHP"
    "Tile.TileWindowsApplication"
)

# List of programs to uninstall
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Wolf Security"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
)

$HPidentifier = "AD2F1837"
