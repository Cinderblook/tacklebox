txt = "I have a cat. I have a mat. Things are going swell."

def sentence_searcher(textString, String):
    #Create a split of the string txt for total word count
    txtSplit = textString.split(".")
    for element in txtSplit:
        if element.__contains__(String):
            print (txtSplit)





sentence_searcher(txt, "have")
sentence_searcher(txt, "MAT")
sentence_searcher(txt, "things")
sentence_searcher(txt, "flat")



