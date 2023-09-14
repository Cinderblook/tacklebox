# Define the path to the file containing server names
$serversFile = "./Server-Lists/servers.txt"

# Check if the file exists
if (Test-Path $serversFile -PathType Leaf) {
    # Read server names from the file
    $serverNames = Get-Content $serversFile

    # Loop through each server name
    foreach ($serverName in $serverNames) {
        try {
            # Query the server for product name information
            $productName = (Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $serverName).Caption

            # Output the result
            Write-Host "Server $serverName has the following product name: $productName"
        } catch {
            # Handle any errors that occur during the query
            Write-Host "Error querying $serverName $_.Exception.Message"
        }
    }
} else {
    Write-Host "The file $serversFile does not exist in the current directory."
}
