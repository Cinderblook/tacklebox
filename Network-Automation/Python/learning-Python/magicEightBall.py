
import random
import http.client
import json
import urllib.parse


#Introduce user to the program, offer an exit strategy
print("Hello! I am the Magic Eight Ball!")
print("Feel free to leave by entering 'Quit'")
#Create a list of possible answers
#ResponsePool = ["Maybe","I am not sure","Ask again","Really? Why even ask that","Yes","Of course","You already know the answer"]

#EightBall function, asks user to enter a question. Loops till user types 'Quit'
def Eightball():
    #Set variable to break while loop later
    x = 0
    #Loop until user wants to quit
    while x != 1:
        #Ask for question
        question = urllib.parse.quote(input("Enter your question, and I shall answer:   \n \n"))
        #Determine if user asked question or wants to quit
        if question in ["quit","q","Quit","Q"]:
            x = 1
        else:
            #Shake ball for random answer from the API
            ShakeBall(question)

def ShakeBall(question):
    conn = http.client.HTTPSConnection("8ball.delegator.com")
    conn.request('GET', '/magic/JSON/' + question)
    response = conn.getresponse()
    print('\n' + json.loads(response.read())['magic']['answer'] + '\n')

Eightball()

