import paramiko
import getpass

hosts = ['10.92.16.54',
    '10.92.16.56',
    '10.92.16.57',
    '10.92.16.45']

pi1 = '10.92.16.54'
pi2 = '10.92.16.56'
pi3 = '10.92.16.57'
pi4 = '10.92.16.45'

def multiHost():
    for host in hosts:
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(host, username='pi', password='DDCoffee4Me!')
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("sudo reboot")
        print("Host: " + host + " has been rebooted")

def singleHost(singleHostUse):
    ssh = paramiko.SSHClient()
    ssh.load_system_host_keys()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh.connect(singleHostUse, username='pi', password='DDCoffee4Me!')
    ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("sudo reboot")
    print("Host: " + singleHostUse + " has been rebooted")

#Ask wheather to run all or single pi script
userInput = input("all or single?\n")

if userInput == "all":
    multiHost()
else:
    Choice = input("pi1 (10.92.16.54), pi2(10.92.16.56), pi3(10.92.16.57), pi4(10.92.16.45)?\n")
    if Choice == 'pi1':
        singleHost(pi1)
    elif Choice == 'pi2':
        singleHost(pi2)
    elif Choice == 'pi3':
        singleHost(pi3)
    elif Choice == 'pi4':
        singleHost(pi4)
    else:
        print("Error, try again")

    