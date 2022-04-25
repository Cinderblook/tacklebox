#Display program purpose
Write-Output "This program will calculate a Network ID or Network Broadcast"
#Ask user if looking for Network ID or Broadcast
$userChoice = Read-Host -Prompt " Type 1 to calculate Network ID `n Type 2 to calculate Network Broadcast`n"
#Gather IP and Mask information
$userIP = Read-Host -Prompt "Enter an IP address"
$userMask = Read-Host -Prompt "Enter a Subnet Mask"
#Create function to obtain Network ID
function Get-NetID
{
Param($IPaddress, $IPmask)
   #Calculate NetID
    $userIP = [ipaddress] $IPaddress
    $userMask = [ipaddress] $IPmask
    $networkID = [ipaddress] ($userIP.Address -band $userMask.Address) 
    Write-Output "Your Network ID would be $networkID"
}
#Create function to obtain Network Broadcast
function Get-NetBroadCast
{
Param($IPaddress, $IPmask)
    $userIP = [ipaddress] $IPaddress
    $userMaskIP = [ipaddress] $IPmask
    #Calculate NetID
    $networkID = [ipaddress] ($userIP.Address -band $userMaskIP.Address) 
    #Split Mask, to flip to wildcard
    $splitMask = $userMask.split(".")
    $inverseMask = "$(255 - $splitMask[0]).$(255 - $splitMask[1]).$(255 - $splitMask[2]).$(255 - $splitMask[3])"
    #Set wildcard mask
    $inverseMask = [ipaddress] $inverseMask
    #Use bitwise or to convert Mask
    $networkBroadcast = [ipaddress] $($inverseMask.Address -bor $networkID.Address)
    Write-Output "Your Network Broadcast would be $networkBroadcast"
}


switch ($userChoice) {
    1 {Get-NetID $userIP $userMask;
         break  }
    2 {Get-NetBroadCast $userIP $userMask ;
         break}
    Default {Write-Output "Incorrect Choice"}
}