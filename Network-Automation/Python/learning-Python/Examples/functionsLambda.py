#Lamda functions in python
#annonymous functions
#Syntax args (1 or many) : expr

#Illustration of a lambda function to calculate how many days in x years
years=0
days=0

totaldays= lambda years, days : years *days

print(totaldays(2,365))