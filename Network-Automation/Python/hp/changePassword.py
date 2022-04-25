# Change HP Procurve Password for a specified user
from netmiko import ConnectHandler
from netmiko.ssh_exception import NetMikoTimeoutException, NetMikoAuthenticationException
import argparse
import os

#Set location of current directory for reliable file opening
__location__ = os.path.realpath(
    os.path.join(
        os.getcwd(),
        os.path.dirname(
            __file__
        )
    )
)

#Initialize parser
# NOTE This will only work if the password is the same across all switches
parser = argparse.ArgumentParser(description="Changes manager password of HP ProCurve switches")

#Help prompts:
userPrompt = "Set username to log in with"
passPrompt = "Set password to log in with"
newPassPrompt = "Set new password for manager"

#Add optional arguments
parser.add_argument("-u", "--Username", help = userPrompt, required=True)
parser.add_argument("-p", "--Password", help = passPrompt, required=True)
parser.add_argument("-n", "--New", help= newPassPrompt, required=True)

#Read arguments from command line
args = parser.parse_args()

#Set argument values to variables
username = args.Username
password = args.Password
newPass  = args.New

def ChangePassword(givenUsername, givenPassword, givenNewPass, __location__):
    #Open hpiplist file
    hpiplist = open(os.path.join(__location__, "hpiplist.txt"), "r")

    for host in hpiplist:
        #Device configuration
        device = {
            'device_type': 'hp_procurve',
            'ip': host,
            'username': givenUsername,
            'password': givenPassword,
            'use_keys': True
        }

        #Connect to host
        try:
            print("\n> Connecting to host " + host)
            net_connect = ConnectHandler(**device)

            print("> Entering Config Mode")
            #Send command 'conf'
            net_connect.send_command_timing("conf", strip_command=False, strip_prompt=False)

            print("> Changing password of user manager")
            #Send password command
            net_connect.send_command_timing("password " + username + " plaintext " + givenNewPass)

            print("> Saving configuration")
            #Send save command
            net_connect.send_command_timing("save")

            #Disconnect from host
            net_connect.disconnect()


        except(NetMikoTimeoutException):
            print("\n> Timeout while connecting to device " + host + ". Is the device online?")
            continue
        except(NetMikoAuthenticationException):
            print("\n> Error authenticating to switch " + host + ". Did you use the right password?")
        except:
            print("\n> General error. Is the device working properly?")
    
    #Close file
    hpiplist.close()


ChangePassword(username, password, newPass, __location__)