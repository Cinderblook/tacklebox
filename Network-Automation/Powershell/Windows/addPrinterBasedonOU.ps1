$myOU = "ou=test,ou=test,ou=test,dc=domain,dc=netdomain"

$Creds = Get-Credential 
$Computers = Get-ADComputer -filter * -searchBase $myOU | Select-Object -expand Name

Foreach ($Computer in $Computers) { 
  Invoke-Command -computername $Computer -Credential $Creds -ScriptBlock {
    #Check if the printer port existsd if not add local Printer Port
    $printerPortName = "\\printserver\publicprinter"
    $portExists = Get-PrinterPort -Name $printerPortName -ErrorAction SilentlyContinue
    
    if ( -not $portExists) {
        Add-PrinterPort -Name $printerPortName
    }
    
    
    #Check if the print driver exists if not add the driver
    $printDriver = "HP Universal Printing PCL 6"
    $driverExists = Get-PrinterDriver -Name $printDriver -ErrorAction SilentlyContinue
     
    if ( -not $driverExists) {
        Add-PrinterDriver -Name $printDriver
    }
    
    # Check if the printer exists if not add the printer
    $printerName = "Printer-Name"
    $printerExists = Get-Printer -Name $printerName -ErrorAction SilentlyContinue
    
    if ( -not $printerExists) {
        Add-Printer -Name $printerName -DriverName $printDriver -PortName $printerPortName
    }
  }
}


