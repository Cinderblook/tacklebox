# Backup running config using SCP 
import string
from netmiko import ConnectHandler
from netmiko.ssh_exception import NetMikoTimeoutException, NetMikoAuthenticationException
import argparse
import os
import logging 
import base64
from datetime import date

# Set Month w/ abbreviation, day and year	
today = date.today()
date = today.strftime("%b-%d-%Y")

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
b64_sftppassword = "===="

# Decode variables just for use in script
#User
base64_bytes_username = b64_username.encode('ascii')
username_bytes = base64.b64decode(base64_bytes_username)
username = username_bytes.decode('ascii')
#Pass
base64_bytes_password = b64_password.encode('ascii')
password_bytes = base64.b64decode(base64_bytes_password)
password = password_bytes.decode('ascii')
#SFTPpass
base64_bytes_sftp = b64_sftppassword.encode('ascii')
sftp_bytes = base64.b64decode(base64_bytes_sftp)
sftppassword = sftp_bytes.decode('ascii')

# Server Variables
snmpServer = "host"
#Open hpiplist file
ciscoiplist = open(os.path.join(__location__, "ciscoiplist.txt"), "r")

def copyConfigs(usernameDecode, passwordDecode, sftppasswordDecode, __location__, snmpServer):
    
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
            print("> Entering Config Mode")
            #Send command to copy config
            net_connect.send_command_timing("copy running-config scp:", strip_command=False, strip_prompt=False)
            print("> Copying config to SFTP server")
            #Send confirm for SSH command
            net_connect.send_command_timing(snmpServer)
            print("> Assign IP of SFTP server")      
                        #Send confirm for SSH command
            net_connect.send_command_timing(str(usernameDecode))
            print("> Designate User to connect with")  
                        #Send confirm for SSH command
            net_connect.send_command_timing(str(host) + "-" + date + ".txt")
            print("> Set filename")        
            #Send password command
            net_connect.send_command_timing(str(sftppasswordDecode))
            print("> Secure Password")
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

copyConfigs(username, password, sftppassword, __location__, snmpServer)

