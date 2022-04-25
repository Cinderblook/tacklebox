#this will show a few mroe ideas surroudning nested dictionaries
#accepting input
qty=input("How many devices: ")
devices=dict()
for i in range(int(qty)):
    device_name=input("enter the device name: ")
    device_ip=input ("enter the IP address: ")
    devices[i] = {"Device Name": device_name, "Device IP": device_ip}

print(devices)