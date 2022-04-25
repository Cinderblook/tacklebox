#Dictionaries are similar to associative arrays in Linux/PHP
#We will create these with curly braces. Key/Pair Combo

#Simple formatting, of dictionary
lunch = {
"drink": "tea",
"entree": "bacon cheeseburger",
"side": "sweet potato fries"
}
#Output dictionary
print(lunch)
#Find length
print(len(lunch))

#Getting stuff out
print (lunch["entree"])
print(lunch.get("drink"))

#getting with keys
print(lunch.keys())
#getting the values
print(lunch.values())

#adding an item
lunch["side1"] = "salad"
#via update
lunch.update({"dessert":"cake"})
print(lunch)

#removal
lunch.pop("side1")
print(lunch)
#delete entire dictionary
#del lunch
#clear dictionary
#lunch.clear()