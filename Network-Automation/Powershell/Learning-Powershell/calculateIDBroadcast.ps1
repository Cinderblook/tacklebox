#Ask user for required data
$requestedIP = Read-Host -Prompt "Enter an IP address"
$requestedMask = Read-Host -Prompt "Enter a Subnet Mask"


#Change string to IP address for requested
$requestedIP = [ipaddress] $requestedIP

#Change string to IP to calculate NetIP
$MaskIP = [ipaddress] $requestedMask

#Calculate NetID
$networkID = [ipaddress] ($requestedIP.Address -band $MaskIP.address)

#Split Mask, to flip to wildcard
$splitMask = $requestedMask.split(".")
$inverseMask = "$(255 - $splitMask[0]).$(255 - $splitMask[1]).$(255 - $splitMask[2]).$(255 - $splitMask[3])"

#Set mask back from string to IP address
$inverseMask = [ipaddress] $inverseMask

#Use bitwise or to convert Mask 
$networkBroadcast = [ipaddress] $($inverseMask.Address -bor $networkID.Address)

#($networkBroadcast.Address -bor -bnot  $requestedMask.Address)
Echo $networkID
Echo $networkBroadcast

