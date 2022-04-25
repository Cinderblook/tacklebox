#How to use args in python functions

#Arg is going to go in the parentheses
def year_to_day(day, year):
    print("This is year " + year + " This is day " + day)
#function callers
year_to_day( year = "2000", day = "21")

#Arbitrary
def year_info(*yearinfo):
    print(type(yearinfo))
    print("This is yearinfo 0  " + yearinfo[0] + " This is yearinfo 1 " + yearinfo[1])
#function caller
year_info("1999", "19")