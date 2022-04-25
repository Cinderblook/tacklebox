
#PowerShell Leap Year Calculator
#Goal: User enters a year and this will calculate whether or not it is a leap year

#Set Year Object and its NoteProperties to be used within the script
$year = New-Object -TypeName psobject
$year | Add-Member -MemberType NoteProperty -Name year -Value ''
$year | Add-Member -MemberType NoteProperty -Name status -Value ""
$year | Add-Member -MemberType NoteProperty -Name isValid -Value ""
#Setup Method to be called later on
$year | Add-Member -MemberType ScriptMethod -Name "leapYear" -Value {
#Check if it is divisible by 4
if($This.year % 4 -ne 0){
    $This.status = "normal"}
#Check if it is divisible by 100
elseif($This.year % 100 -ne 0 ){
    $This.status = "leap"}
#Check if it is dibisible by 400
elseif($This.year % 400 -ne 0){
    $This.status = "normal"}
#If divisible by all of the above
else{
    $This.status = "leap"}
#Write output of whether it is leap or normal year
if($This.status -eq "leap"){
    Write-Host "The year you entered, $($This.year); is a leap year"}
else{
    Write-Host "The year you entered, $($This.year); is a normal year"}
}
#Upon running the program, tells user its purpose
Write-Host "Use this program to determine if a year is a leap year"

#Runs until input is an integer (Valid Year) Tells user if there is an error
DO{
Try{
[int] $year.year = Read-Host "Enter year "
$year.isValid ="true"}
catch{
Write-Host "The year entered is invalid, please try again"
$year.isValid ="false"}
}while($year.isValid -eq "false")

#Call Method to determine if it is leap or normal
$year.leapYear()










