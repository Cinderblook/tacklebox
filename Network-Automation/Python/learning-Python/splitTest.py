sent_one_words=""
sent_two_words=""
def Shadow_Sentence(sent_one, sent_two):
    #Check to see same number of words
    sent_one_words_count = len(sent_one.split())
    sent_two_words_count = len(sent_two.split())
    if sent_one_words_count != sent_two_words_count:
        return False
    sent_one_words=sent_one.split()
    sent_two_words=sent_two.split()
#Word length the same
    for i in range (len(sent_one_words)):
        if len(sent_one_words[i]) == len(sent_two_words[i]):
            for x, letter in enumerate(sent_one_words[i]):
                if sent_two_words[i].__contains__(letter):
                    return False
        else:
            return False
    return True

print(Shadow_Sentence("They are round", "fold two times"))
