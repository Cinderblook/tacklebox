#generic list
$days= New-Object 'system.collections.generic.list[String]'
$days.Add("Monday")
$days.add("Tuesday")
$days

$days.Count
$days.Reverse()
#$days.Contains()
$days.Remove("Monday")
$days