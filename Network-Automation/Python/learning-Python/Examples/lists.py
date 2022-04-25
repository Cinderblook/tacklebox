#This script is designed to illustrate the functionality of lists.

sophmoreClasses = ["CIT241", "CIT240", "CIT246"]
#Dump all contets
print(sophmoreClasses)
#Check length
print(len(sophmoreClasses))
#Accesss by Index
print(sophmoreClasses[0])
#Add to the end of an Existing List
sophmoreClasses.append("IAS312")
#Add to a specified location in a list
sophmoreClasses.insert(0,"MGT115")
#Change Range
sophmoreClasses[0:3]="EET247"
#Change an index
sophmoreClasses[1]="CIT360"
#Removing items
sophmoreClasses.remove("MGT115")
#Removing specified items
sophmoreClasses.pop(2)
del sophmoreClasses[1]
#Wipe the entire list
del sophmoreClasses

print(sophmoreClasses)
