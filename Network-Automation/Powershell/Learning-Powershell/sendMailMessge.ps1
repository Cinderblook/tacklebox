$exists=Test-Path 'path.here'
if($exists -eq $false){
Get-Credential | Export-Clixml "path.here"
}
$sysinfo=Get-ComputerInfo
$cred=Import-Clixml -Path "path.here"

#$joke=Invoke-RestMethod -Uri "https://api.chucknorris.io/jokes/random"
#$joke=Invoke-RestMethod -Uri "https://api.icndb.com/jokes/random?exclude=[explicit]"
#echo $joke.value.joke


$mailMessage = @{
from="email:here"
to="email:here"
subject="Joke of the day"
body="Windows Product ID - $($sysinfo.WindowsProductId)"
smtpserver="smtp.office365.com"
port="587"
usessl=$true
credential=$cred
}

Send-MailMessage @mailMessage
