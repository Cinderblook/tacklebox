$exists=Test-Path 'C:\path.xml'
if($exists -eq $false)
{
Get-Credential | Export-Clixml "C:\path.xml"
}
$cred=Import-Clixml -Path "C:\path.xml"

$info =
@{
BIOSver = (Systeminfo | Select-String "BIOS Version:").toString().Split(':')[1].Trim()
#$IPAddress = (Systeminfo | Select-String "Network Card(s):").toString()
hostName = hostname
#IPaddress = Test-Connection -ComputerName $($info['hostname']) -Count 1 | Select IPV4Address
IPaddress = (Get-NetIPAddress | Where-Object {$_.InterfaceAlias -eq 'Wi-Fi'}).IPv4Address
totalRAM = (Systeminfo | Select-String "Total Physical Memory:").toString().Split(':')[1].Trim()
}

$mailMessage = @{
from="email:here"
to="email:here"
subject="Assignment 1 Systems Programming"
body="Below is my machine information for Assignment 1
      Hostmachine: $($info['hostName'])
      BIOS Version: $($info['BIOSver'])
      Available RAM: $($info['totalRAM'])
      Network Ipv4 Address: $($info['IPAddress'])"
smtpserver="smtp.office365.com"
port="587"
usessl=$true
credential=$cred
}
#(Get-NetIPAddress | Where-Object {$_.InterfaceAlias -eq 'Wi-Fi'}).IPv4Address
Send-MailMessage @mailMessage