#Array Exmaple

#array of 1-7
$array1 = 1,2,3,4,5
#array of 1-10000
$array2 = 1..10000
#Polymorphic array
$array3 = 1,"Austin",(Get-Date)

#$array3.GetType()
#$array3 | Get-Member

$array2[0,98,1000]


$hashTest = @{Test="Testing"; Hash2="Hash Number 2"; IP="172.168.0.16"}

$hashTest["Test"]
$hashTest.Hash2