import socket

connect_address=('localhost', 9000)

with socket.socket(socket.AF_INET,socket.SOCK_STREAM) as socket:
    socket.connect(connect_address)
    socket.sendall(big_data.encode())
    socket.sendall(b'\r\n')