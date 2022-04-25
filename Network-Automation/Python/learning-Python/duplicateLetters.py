#Function that accepts phrase or sentence
#Determine if any single word in phrase contains duplicate letters
#IF it does, return true, if it doesn't return false
userinput = input("Enter a phrase or setence to test and see if any words have duplicate letters")

def duplicate_letters(phrase):
    phrase_elements=phrase.split(" ")
    returnvar = ""
    for word in phrase_elements:
        for i in range (len(word)):
            count = word.count(word[i])
            if count > 1:
                returnvar = True
            return("True" if returnvar == True else "FAlsE")

    print(duplicate_letters("the fine wine grows on the vine"))