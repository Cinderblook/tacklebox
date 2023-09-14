# Define a list of essential Windows Server features
$essentialFeatures = @(
    "AD-Domain-Services",
    "AD-DS",
    "Active Directory",
    "DNS",
    "File-Services",
    "Print-Services",
    "Web-Server",
    "Remote-Desktop-Services",
    "Remote-Desktop-Session-Host",
    "Hyper-V",
    "Windows-Server-Backup",
    "DHCP",
    "NPS",
    "WINS",
    "FS-DFS-Namespace",
    "FS-DFS-Replication",
    "Storage-Services",
    "Web-App-Dev",
    "Windows-Identity-Foundation",
    "Telnet-Client",
    "Telnet-Server",
    "Telnet-Server-Full",
    "Telnet-Client-GUI",
    "Remote-Server-Administration-Tools",
    "Remote-Server-Administration-Tools-Feature",
    "Remote-Server-Administration-Tools-Role",
    "Remote-Server-Administration-Tools-AD",
    "Remote-Server-Administration-Tools-ADDS",
    "Remote-Server-Administration-Tools-DHCP",
    "Remote-Server-Administration-Tools-DNS",
    "Remote-Server-Administration-Tools-Print-Services",
    "Remote-Server-Administration-Tools-Web",
    "Remote-Server-Administration-Tools-WDS",
    "Remote-Server-Administration-Tools-Cluster",
    "RSAT-Clustering",
    "RSAT-Hyper-V-Tools",
    "RSAT-Storage-Replica",
    "RSAT-Storage-Migration-Service",
    "RSAT-Datacenter-Bridging",
    "RSAT-Datacenter-Bridging-Tools",
    "RSAT-NAT",
    "RSAT-VPN",
    "RSAT-WINS",
    "RSAT-RemoteAccess-Role",
    "RSAT-RemoteAccess-Management-Tools",
    "RSAT-RemoteAccess-PowerShell",
    "RSAT-RemoteAccess-Mgmt-Con",
    "RSAT-RemoteAccess-Mgmt-Tools",
    "RSAT-RemoteAccess-PowerShell",
    "RSAT-RemoteAccess-Mgmt-Con",
    "RSAT-RDS-Connection-Broker",
    "RSAT-RDS-Management-Tools",
    "RSAT-RDS-Virtualization-Host",
    "RSAT-RDS-RAP",
    "RSAT-RDS-Gateway",
    "RSAT-RDS-Licensing",
    "RSAT-DHCP",
    "RSAT-DNS-Server",
    "RSAT-File-Services",
    "RSAT-Print-Services",
    "RSAT-Remote-Desktop-Services",
    "RSAT-Remote-Desktop-Licensing",
    "RSAT-Web-Server",
    "RSAT-Azure-AD-PowerShell",
    "RSAT-ADDS-Tools",
    "RSAT-AD-Powershell",
    "AD-Certificate-Services",
    "WINS",
    "NPAS",
    "WDS",
    "Print-and-Document-Services",
    "WSUS",
    "Windows-Server-Essentials",
    "Windows-Server-Backup",
    "Web-Server-IIS",
    "File-and-Storage-Services",
    "Failover-Clustering",
    "PowerShell"
    # Add more essential features as needed
)

# Read the list of target servers from servers.txt file
$servers = Get-Content -Path "./Server-Lists/servers.txt"

# Initialize an empty array to store the results
$results = @()

# Loop through the list of servers
foreach ($server in $servers) {
    # Use Try-Catch to handle potential errors
    try {
        # For 2008 server usage
        Import-Module ServerManager
        $serverResult = Invoke-Command -ComputerName $server -ErrorAction Stop -ScriptBlock {
            Get-WindowsFeature | Where-Object {
                $_.Installed -and
                $using:essentialFeatures -contains $_.Name
            } | Select-Object DisplayName 
        }
        
        # Create an object with the server name and comma-separated display names
        $resultObject = [PSCustomObject]@{
            PSComputerName = $server
            InstalledFeatures = $serverResult.DisplayName -join ', '
        }
        
        # Add the result object to the array
        $results += $resultObject
    }
    catch {
        # Handle errors, e.g., if the server is not accessible or the command fails
        Write-Host "Error querying features on server $server $_"
    }
}

# Export the results to a CSV file
$results | Export-Csv -Path 'ServiceInfo.csv' -NoTypeInformation
