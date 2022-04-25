#Socket Program Script - Communicate back and forth from client to server
import socket


def server_program():
    # get the hostname
    host = ('localhost', 9000)

    server_socket = socket.socket()
    #Set port and ip of server
    server_socket.bind(host)

    # configure so client and server can listen simultaneously
    server_socket.listen(2)
    #Accept new connection
    conn, address = server_socket.accept()
    #Tell server new connection type
    print("Connection from: " + str(address))
    while True:
        # receive data
        data = conn.recv(1024).decode()
        if not data:
            #If no data, just cancel action
            break
        #Display data sent
        print("from connected user: " + str(data))
        data = input(' -> ')
        #Send data back to client
        conn.send(data.encode())
    
    conn.close()  # close the connection

server_program()