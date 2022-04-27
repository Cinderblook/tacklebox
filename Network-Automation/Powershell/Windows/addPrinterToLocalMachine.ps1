
#Check if the printer port existsd if not add local Printer Port
$printerPortName = "\\Print-Server\public-printer"
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
$printerName = "printer-name"
$printerExists = Get-Printer -Name $printerName -ErrorAction SilentlyContinue

if ( -not $printerExists) {
    Add-Printer -Name $printerName -DriverName $printDriver -PortName $printerPortName
}


