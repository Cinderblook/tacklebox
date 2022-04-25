# Configures SNMPv3 on Cisco IoS switches/routers
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
b64_passwordsnmp = "===="
# Decode variables just for use in script
#User
base64_bytes_username = b64_username.encode('ascii')
username_bytes = base64.b64decode(base64_bytes_username)
username = username_bytes.decode('ascii')
#Pass
base64_bytes_password = b64_password.encode('ascii')
password_bytes = base64.b64decode(base64_bytes_password)
password = password_bytes.decode('ascii')
#SNMPpass
base64_bytes_passwordsnmp = b64_passwordsnmp.encode('ascii')
passwordsnmp_bytes = base64.b64decode(base64_bytes_passwordsnmp)
passwordsnmp = passwordsnmp_bytes.decode('ascii')

#SNMP Variables
snmpUser = "user"

#Open hpiplist file
ciscoiplist = open(os.path.join(__location__, "ciscoiplist.txt"), "r")

def copyConfigs(usernameDecode, passwordDecode, passwordsnmpDecode, __location__, snmpUser):

    #Open hpiplist file
    ciscoiplist = open(os.path.join(__location__, "ciscoiplist.txt"), "r")
    iplist = [s.rstrip('\n') for s in ciscoiplist]

    for host in iplist:
        #Device configuration
        device = {
            'device_type': 'cisco_ios',
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
            net_connect.enable()
            print("> Entering Config Mode")
            net_connect.send_command_timing("conf t")

            net_connect.send_command_timing("snmp-server group snmpgroup v3 auth access snmpgroup")
            print("> Setup SNMP server group")

            net_connect.send_command_timing("snmp-server user initial " + snmpUser +" v3 auth md5 " + passwordsnmpDecode + "  priv des " + passwordsnmpDecode)
            print("> Setup SNMP user")      

            net_connect.send_command_timing("end")
            print("> End")  
            output = net_connect.send_command("show snmp user")
            print(output)
            net_connect.send_command_timing("copy running-config startup-config")
            print("> save running config")

            net_connect.send_command_timing("")
            #Ensure it sends
            net_connect.send_command_timing("")
            #Disconnect from host
            net_connect.disconnect()
        
        except(NetMikoTimeoutException):
            logging.warning("Timeout while connecting to device " + host + ". Is the device online?")
            continue
        except(NetMikoAuthenticationException):
            logging.warning("Error authenticating to switch/SFTP server on  " + host + ". Did you use the right password?")
        except:
            logging.warning('General error. Is the device working properly?')
    ciscoiplist.close()

copyConfigs(username, password, passwordsnmp, __location__)

