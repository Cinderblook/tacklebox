$url = "https://url-here.com"
$directory = "C:\MDM\"
md $directory -erroraction silentlycontinue
$LockScreenDestinationFile = "$directory\LockScreen.png" 
$LockScreenImageValue = "$LockScreenDestinationFile"

Start-BitsTransfer -Source $WallpaperURL -Destination "$WallpaperDestinationFile"
Start-BitsTransfer -Source $LockscreenUrl -Destination "$LockScreenDestinationFile"

$RegKeyPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PersonalizationCSP'
$LockScreenPath = "LockScreenImagePath"
$LockScreenStatus = "LockScreenImageStatus"
$LockScreenUrl = "LockScreenImageUrl"
$StatusValue = "1"


If ((Test-Path -Path $directory) -eq $false)

{

New-Item -Path $directory -ItemType directory

}

$wc = New-Object System.Net.WebClient

$wc.DownloadFile($url, $LockScreenImageValue)

if (!(Test-Path $RegKeyPath))

{

Write-Host "Creating registry path $($RegKeyPath)."

New-Item -Path $RegKeyPath -Force | Out-Null

}

New-ItemProperty -Path $RegKeyPath -Name $LockScreenStatus -Value $Statusvalue -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $LockScreenPath -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null
New-ItemProperty -Path $RegKeyPath -Name $LockScreenUrl -Value $LockScreenImageValue -PropertyType STRING -Force | Out-Null

stop-process -name explorer –force
$error.clear()