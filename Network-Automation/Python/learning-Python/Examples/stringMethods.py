#this program will illustrate string methods

test_string = "   This-is-a-test-string    "
#print capital
print(test_string.upper())
#print lower
print(test_string.lower())

#split string
print(test_string.split("-"))
#string replacement
print(test_string.replace("-", " "))
#whitespace removal
print(test_string.strip())
#centers between specified amnt of chars
print(test_string.center(40))
#prints count of a value occurs
print(test_string.count("e"))

#formate method

day=29
year=2021
month=3
hour=16
minute=19
statement="Today is the {}th day of the year {}, in the {}rd month"
print(statement.format(day,year,month))

#decimal
decimal=10.29129129921394812935791234
print("{:.2f}".format(decimal))

#Print multiple times
print(10*statement)