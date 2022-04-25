# Setup NPS on HP Procurve Switches 
import string
from netmiko import ConnectHandler
from netmiko.ssh_exception import NetMikoTimeoutException, NetMikoAuthenticationException
import argparse
import os
import logging 
import base64

#Set location of current directory for reliable file opening
__location__ = os.path.realpath(
    os.path.join(
        os.getcwd(),
        os.path.dirname(
            __file__
        )
    )
)
# Set variables using Base64
b64_username = "===="
b64_password = "===="
b64_npsserver = "===="
b64_npskey = "===="
# Decode variables just for use in script
#User
base64_bytes_username = b64_username.encode('ascii')
username_bytes = base64.b64decode(base64_bytes_username)
username = username_bytes.decode('ascii')
#Pass
base64_bytes_password = b64_password.encode('ascii')
password_bytes = base64.b64decode(base64_bytes_password)
password = password_bytes.decode('ascii')
# NPS IP Address
base64_bytes_npsserver = b64_npsserver.encode('ascii')
npsserver_bytes = base64.b64decode(base64_bytes_npsserver)
npsserver = npsserver_bytes.decode('ascii')
# NPS Key
base64_bytes_npskey = b64_npskey.encode('ascii')
npskey_bytes = base64.b64decode(base64_bytes_npskey)
npskey = npskey_bytes.decode('ascii')

#Open hpiplist file
hpiplist = open(os.path.join(__location__, "hpiplist.txt"), "r")

def copyConfigs(usernameDecode, passwordDecode, npsserverDecode, npskeyDecode):

    #Open hpiplist file
    hpiplist = open(os.path.join(__location__, "hpiplist.txt"), "r")
    iplist = [s.rstrip('\n') for s in hpiplist]

    for host in iplist:
        #Device configuration
        device = {
            'device_type': 'hp_procurve',
            'ip': host,
            'username': usernameDecode,
            'password': passwordDecode,
            'secret': str(passwordDecode),
            'port': "22"
            #'use_keys': True
        }
        #Connect to host
        try:
            print("\n> Connecting to host " + host)
            net_connect = ConnectHandler(**device)
            
            print("> Entering Config Mode")
            net_connect.send_command_timing("conf t", strip_command=False, strip_prompt=False)
            
            print("> Setup Server Host 1")
            net_connect.send_command_timing("radius-server host " + npsserverDecode + " key " + npskeyDecode, strip_command=False, strip_prompt=False)        
            
            print("> Setup Server Host 2") 
            net_connect.send_command_timing("radius-server host " + npsserverDecode + " key " + npskeyDecode, strip_command=False, strip_prompt=False)

            print("> Setup NPS timeout")              
            net_connect.send_command_timing("radius-server retransmit 2", strip_command=False, strip_prompt=False)

            print("> Setup NPS retransmit")              
            net_connect.send_command_timing("radius-server retransmit 2", strip_command=False, strip_prompt=False)

            print("> Setup nps-server group with host 1")  
            net_connect.send_command_timing("aaa server-group radius nps-servers host " + npsserverDecode, strip_command=False, strip_prompt=False)
            
            print("> Setup nps-server group with host 2")  
            net_connect.send_command_timing("aaa server-group radius nps-servers host " + npsserverDecode, strip_command=False, strip_prompt=False)
           
            print("> Setup Authentication")  
            net_connect.send_command_timing("aaa authentication console enable radius server-group nps-servers local", strip_command=False, strip_prompt=False)
            net_connect.send_command_timing("aaa authentication ssh login radius server-group nps-servers local", strip_command=False, strip_prompt=False)
            net_connect.send_command_timing("aaa authentication ssh enable radius server-group nps-servers local", strip_command=False, strip_prompt=False)
            net_connect.send_command_timing("aaa authentication login privilege-mode")
            
            print("> save")  
            net_connect.send_command_timing("save", strip_command=False, strip_prompt=False)
           
            print("> Ensure it finished")
            net_connect.send_command_timing("")
            
            net_connect.disconnect()
        
        except(NetMikoTimeoutException):
            logging.warning("Timeout while connecting to device " + host + ". Is the device online?")
            continue
        except(NetMikoAuthenticationException):
            logging.warning("Error authenticating to switch/SFTP server on  " + host + ". Did you use the right password?")
        except:
            logging.warning('General error. Is the device working properly?')
    hpiplist.close()

copyConfigs(username, password, npsserver, npskey)

