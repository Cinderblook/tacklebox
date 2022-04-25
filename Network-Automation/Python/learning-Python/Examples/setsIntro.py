#This script is going to illustrate sets in python

#the syntax of a set looks like this
#multiple "items" get placed into the set
winter_colors = {"white", "grey", "blue",}

#print entire set
print(winter_colors)
#iterate through set
for color in winter_colors:
    print(color)
#Check to see if something exists in the set
print("white" in winter_colors)

#Adding to set
winter_colors.add("pruple")
#Create set
spring_colors = {"pink","yellow","red"}
#Create list
fall_colors = ["orange","brown"]
#adding a set to another set
winter_colors.update(spring_colors)
#adding a list to a set
winter_colors.update(fall_colors)

#removing from list
winter_colors.remove("orange")
print(winter_colors)
