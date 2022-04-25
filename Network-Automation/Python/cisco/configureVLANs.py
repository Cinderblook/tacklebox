#Netmiko Project using Cisco devices

from netmiko import ConnectHandler
from getpass import getpass

#Set Dictionary information for devices
ajb1 = {"device_type": "cisco_ios","host": "10.175.133.81","username": "user","password": "password","secret": "passwordd"}
ajb2 = {"device_type": "cisco_ios","host": "10.175.133.82","username": "user","password": "password","secret": "passwordd"}
ajb3 = {"device_type": "cisco_ios","host": "10.175.133.83","username": "user","password": "password","secret": "passwordd"}
ajb4 = {"device_type": "cisco_ios","host": "10.175.133.84","username": "user","password": "password","secret": "passwordd"}

def setupMultiRouter():
    NetAddressNumber = int(input("This will be based on a 192.168.x.1 addressing scheme\nWhat IP range would you like to use for the VLANS? (Must be between 1-254 minus total device count)"))
    for device in(ajb1, ajb2, ajb3, ajb4):
        #Set commands to be sent, iteration of IP addres occurs through
        config = [
        "vlan 1","exit",
        "interface vlan 1", "no shut",
        "ip address 192.168.1." + str(NetAddressNumber) +  " 255.255.255.0", "exit",
        "ip route 192.168.1.0 255.255.255.0 10.175.133.65", "exit",
        ]
        net_connect = ConnectHandler(**device, timeout = 20)
        net_connect.enable()
        net_connect.send_config_set(config,cmd_verify=False)
        output = net_connect.send_command('sh run')
        net_connect.save_config()
        print(output)
        net_connect.disconnect()
        NetAddressNumber += 1
       

#def setupSingleRouter():
    #Connect to desired router
    #NetAddressNumber = int(input("This will be based on a 192.168.x.1 addressing scheme\nWhat IP range would you like to begin the VLANS at? (Must be between 1-254 minus total device count)"))
    #config = [
       # "vlan " + str(vlanStart),"exit",
       # "interface vlan " + str(vlanStart), "no shut",
      #  "ip address 192.168.1." + str(NetAddressNumber) +  "255.255.255.0", "exit",
       # "ip route 192.168.1.0 255.255.255.0 10.175.133.65", "exit",
      #  ]
  #  net_connect = ConnectHandler(**ajb1)
  #  net_connect.enable()
  #  net_connect.send_config_set(config,cmd_verify=False)
  #  output = net_connect.send_command('sh run')
 #   #output += net_connect.save_config()
  #  print(output)
  #  net_connect.disconnect()


setupMultiRouter()