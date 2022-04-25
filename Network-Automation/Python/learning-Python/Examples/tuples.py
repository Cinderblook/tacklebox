#Illustrating Tuples (Can't be changed - unlike lists)
freshmanClasses = ("EET145","MTH180","CIT160")
#Assigning Contents
(Class1,class2,class3)=freshmanClassesprint("This is class 1" + class1 + "This is class 2" + Class2 + "This is class 3" + Class3)
#Assign 1 var, 1 list
(class1,*classes,class3)=freshmanClasses
print("This is the content of class1" + class1)
print("This is the content of classes") +str(classes))
print("This is the content of class3" + class3)
#printing a Tuple
print(freshmanClasses)
#Printing a specific index
print(freshmanClasses[1])
#Mixing data types
coursePrefs = (True, False, 22,"Records")
print(coursePrefs)