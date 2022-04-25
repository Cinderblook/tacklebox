#creating nested dictionaries
meals = {
    "lunch":{
        "drink": "soda",
        "entree": "shrimp"
    },
    "dinner":{
        "drink": "water",
        "entree": "steak"
    }
}
#print entire meal dictionary (including sub dictionaries
print(meals)
#print drink within lunch dictionary, within meals dictionary
print(meals["lunch"]["drink"])