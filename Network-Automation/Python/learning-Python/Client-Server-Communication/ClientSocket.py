#Client side
#Socket Program Script - Communicate back and forth from client to server
import socket

print("Enther 'bye' to close connection")

def client_program():
    host = 'localhost'  
    port = 9000 

    client_socket = socket.socket() 
    client_socket.connect((host, port))  # connect to the server

    message = input(" -> ")  # take input

    #Loop and allow connection until user types bye
    while message.lower().strip() != 'bye':
        client_socket.send(message.encode())
        data = client_socket.recv(1024).decode()

        #print server response
        print('Received from server: ' + data) 

        #continually ask for input
        message = input(" -> ") 
    #Close Connection
    client_socket.close() 

client_program()