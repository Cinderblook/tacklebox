#advancedargs

#specify default value
def year_to_day(day, year = "2000"):
    print("This is year " +year+" This is day " + day)
#function call, of you do this approach, default values should be at the end
year_to_day("19")

#unkown args with keywords (kwargs)
def lunch_chocies(**items):
    print(type(items))
    print(items)

lunch_chocies(drink1 = "pepsi", entree1 = "sandwich", entree2 = "salad")