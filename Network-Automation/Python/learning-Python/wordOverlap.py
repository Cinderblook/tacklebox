def overlap(w1,w2):
    for i in range(len(w1)):
        if w2[-i:].__eq__(w1[i:]):
            replaced=w2.replace(w1[i:],'')
            return(w1+replaced)
    return(w1+w2)


overlap("sweden","denmark")



#print("This program will overlap similar words together\n")

#word1 = input("Enter first word here: ")
#word2 = input("Enter second word here:")

#def wordOverlap(firstWord, secondWord):
#    #Create a list for usage with each word, and a combination list
#    word1List = []
#    word2List = []
#    wordcomboList = []
#    wordcomboListIndex = []
#
    #Create a list for letters within words 1 and 2
#    for element in firstWord:
#        word1List.append(element)
#    for element in secondWord:
#        word2List.append(element)
#    if len(word1List) > len(word2List):
#        shortestWordLength = len(word2List)
#    else:
#        shortestWordLength = len(word1List)
#    i = 0
    #Iterate through word and pull overlapping letters into a lsit
#    while i < shortestWordLength:
#        if word1List[i] == word2List[i]:
#            wordcomboList.append(word1List[i])
#            wordcomboListIndex.append(i)
#        i += 1
#    print(wordcomboList)
#    tempWord = ""
#    #Combine overlapping letters into a word
#    for element in wordcomboList:
#        tempWord += element.lower()
#    print("Overlapping letters form: " + tempWord)
#    for element in wordcomboListIndex:
#        word1List[element]
#        print(word1List)


#wordOverlap(word1,word2)
