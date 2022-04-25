#More advanced concepts with lists
#Add two lists into a third list
freshmanClasses = ["EET145","EET247","CIT160"]
sophmoreClasses = ["CIT249","CIT241","CIT240"]
firstTwoYears = freshmanClasses + sophmoreClasses

print(firstTwoYears)
#Extend Lists
freshmanClasses.extend(sophmoreClasses)
print("These are the new freshman classes " + str(freshmanClasses))

#List sorting
freshmanClasses.sort()
print("These are the sorted freshmanClasses " + str(freshmanClasses))

#reverse a sort
freshmanClasses.sort(reverse=True)
print("These are the reverse sorted freshman classes " +str(freshmanClasses)).

#Ignore case of a sort
freshmanClasses.sort(key=str.lower)
print("Ignore Case " + str(freshmanClasses))