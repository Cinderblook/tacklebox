import socket

#create out socket object, specify type of connection
serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#bind info *tuple
bindinginfo=('localhost', 9000)
serversocket.bind(bindinginfo)
stuff=""
i = 1

serversocket.listen()
while True:
    (client,address) = serversocket.accept()
    #print(str(client))
    print("Client " + str(address) + "has connected")
    while True:
        telnetbyte=client.recv(4096).decode()
        if telnetbyte == "\r\n":
            print(stuff)
            sendmessge=(str(i) + ": " + stuff + "\n")
            client.send(sendmessge.encode())
            stuff=""
            i += 1
        else:
            stuff=(stuff+telnetbyte)

