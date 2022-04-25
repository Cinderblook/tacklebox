$myOU = "ou=name,ou=thing,dc=domain,dc=netdomain"

$Creds = Get-Credential 
$Computers = Get-ADComputer -filter * -searchBase $myOU | Select-Object -expand Name

Foreach ($Computer in $Computers) { 
    Invoke-Command -computername $Computer -Credential $Creds -ScriptBlock { Get-WindowsUpdate -AcceptAll -Install -AutoReboot }
}

