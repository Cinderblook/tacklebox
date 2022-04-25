#illustrate a few dictionary concepts

firstCar = {
    "make":"pontiac",
    "model":"G6",
    "year":"2006"

}
#create variable with values, update original dictionary, changes persist in the variable
values = firstCar.values()
print(values)
firstCar["year"]="1999"
print(values)

#iterate through dictionary keys
for things in firstCar:
    print(things)
for things in firstCar.keys():
    print(things)
#iterate through values
for things in firstCar:
    print(firstCar[things])
    
for things in firstCar.values():
    print(things)

#for key/values
for the_key,the_value in firstCar.items():
    print(the_key,the_value)