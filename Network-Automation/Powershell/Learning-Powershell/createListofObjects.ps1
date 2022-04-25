#create a list of objects

$cpObjects = New-Object 'System.Collections.Generic.List[System.Object]'

#Get control panel objects that start with an a
$aObjects = Get-ControlPanelItem -Name -a*
$cObjects = Get-ControlPanelItem -Name -c*

$cpObjects.Add($aObjects)
$cpObjects.Add($cObjects)

foreach ($object in $cpObjects)
{
    echo "parent object - $object"
    foreach($nestedObject in $object)
    {
        echo "nested object - $nestedObject"       
    }

}
