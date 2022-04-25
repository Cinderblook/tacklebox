def total_caps (word):
    #Create empty List
    return_list=[]
    #Iterate through entire string char by char
    for i in range (len(word)):
        #If statemnet, add index to a list, already ordered
        if word[i].isupper(): return_list.append(i)
    return return_list
    #call it
print(total_caps("Test String Filled With Capitals"))
    