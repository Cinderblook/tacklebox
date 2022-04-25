# Connect to vServer
$server = "server.com"
$user = "user-here"
connect-viserver -server $server -Protocol https -User $user
# Gather Data, send it to a file
Get-Datacenter | Get-Cluster | Get-Datastore | Get-VMHost | Format-Custom | Out-File -FilePath hostdata.txt