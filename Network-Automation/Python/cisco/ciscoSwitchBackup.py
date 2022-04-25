# Saves current running configs of Cisco IoS switches to a chosen directory
from netmiko import ConnectHandler
from netmiko.ssh_exception import NetMikoTimeoutException
import argparse
import getpass

#Initialize parser
parser = argparse.ArgumentParser(description="Saves running configs of HP ProCurve switches from a given IP list to a given directory.")

#Help prompts:
userPrompt = "Set username to log in with"
passPrompt = "Set password to log in with"
secretPrompt = "Set secret  to enable with"
directoryPrompt = "Set directory to output to. Ex. Z:\\Path\\To\\Folder"

#Add optional arguments
parser.add_argument("-u", "--Username", help = userPrompt)
parser.add_argument("-p", "--Password", help = passPrompt)
parser.add_argument("-s", "--Secret", help = secretPrompt)
parser.add_argument("-d", "--Directory", help = directoryPrompt)

#Read arguments from command line
args = parser.parse_args()

#If read arguments contain information, use those
if bool(args.Username) and bool(args.Password):
    username = args.Username
    password = args.Password
    secret = args.Secret
    directory = args.Directory
#Otherwise, ask user for username/password for switches
else:
    username = input(userPrompt + "\n")
    password = getpass.getpass("\n" + passPrompt + "\n")
    secret = getpass.getpass("\n" + secretPrompt + "\n")
    directory = input("\n" + pathPrompt + "\n")


def GetConfig(givenUsername, givenPassword, givenSecret, givenDirectory):
    #Open ciscoiplist file
    ciscoiplist = open("ciscoiplist.txt", "r")
    #Strip newlines from file for later use
    iplist = [s.rstrip('\n') for s in ciscoiplist]
    
    for host in iplist:
        #Device configuration
        device = {
            'device_type': 'cisco_ios',
            'ip': host,
            'username': givenUsername,
            'password': givenPassword,
            'secret': givenSecret,
            'use_keys': True
        }

        #Connect to host
        try:
            print("\n> Connecting to host " + host)
            net_connect = ConnectHandler(**device)

            print("\n> Getting configuration from memory")
            #Enter executive priviledge mode
            net_connect.enable()

            #Send command 'sh run'
            output = net_connect.send_command_timing("sh run", strip_command=False, strip_prompt=False)
        except(NetMikoTimeoutException):
            print("\n> Timeout while connecting to device " + host)
            output  = "Timeout while connecting to device...\n     No configuration gathered."

        #Open file to write running config to
        save_file = open(givenDirectory + "\\" + host + "Config.txt",'w')
        #Write to file
        save_file.write(output)
        #Close file
        save_file.close()

GetConfig(username, password, secret, directory)
