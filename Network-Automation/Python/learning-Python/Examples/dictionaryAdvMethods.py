#dictionary methods and nuances
lunch = {
    "drink": "tea",
    "entree": "bacon cheesburger",
    "side": "sweet potato fries"
}
#incorrect copy
#This sets dinner = the lunch dictionary, so if lunch changes so will dinner
dinner = lunch
lunch["side"] = "carrots"

#correctly copy to a new dictioanry titled dinner
dinner = lunch.copy()
dinner = dict(lunch)

#