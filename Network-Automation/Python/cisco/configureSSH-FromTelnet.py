import telnetlib
import time

# Function to configure SSH on a Cisco switch
def configure_ssh(hostname, domain, user, telnet_password, enable_password, ssh_password):
    try:
        print(f"Configuring SSH on {hostname}...")
        
        # Attempt to establish the Telnet connection
        tn = telnetlib.Telnet(hostname, 23)

        tn.read_until(b"Password: ")
        tn.write(telnet_password.encode('utf-8') + b"\n")
        #tn.read_until(b"> ")
        print(f"Logged in to {hostname} via Telnet.")

        tn.write(b"enable\n")
        tn.read_until(b"Password: ")
        tn.write(enable_password.encode('utf-8') + b"\n")
        tn.read_until(b"#")
        print(f"Entered enable mode on {hostname}.")

        tn.write(b"configure terminal\n")
        tn.read_until(b"(config)#")
        tn.write(f"ip domain-name {domain}\n")
        tn.read_until(b"(config)#")
        print(f"Configured domain name on {hostname}.")

        tn.write(b"crypto key generate rsa modulus 2048\n")  # Generate SSH key
        time.sleep(25)  # Wait for key generation
        tn.read_until(b"(config)#")
        print(f"Generated SSH key on {hostname}.")

        tn.write(b"aaa new-model\n")
        print(f"Enabled aaa on {hostname}.")
        tn.read_until(b"(config)#")
        tn.write(b"ip ssh version 2\n")
        tn.read_until(b"(config)#")
        print(f"Configured SSH version on {hostname}.")

        tn.write(f"enable secret {ssh_password}\n".encode('utf-8'))
        tn.read_until(b"(config)#")
        tn.write(b"username " + {user} + " secret " + ssh_password.encode('utf-8') + b"\n")
        tn.read_until(b"(config)#")
        print(f"Configured user authentication on {hostname}.")

        tn.write(b"line vty 0 15\n")
        tn.read_until(b"(config-line)#")
        tn.write(b"transport input ssh\n")
        tn.read_until(b"(config-line)#")
        tn.write(b"end\n")
        tn.read_until(b"#")
        print(f"SSH configuration completed on {hostname}.")

        tn.write(b"write memory\n")
        tn.read_until(b"#")
        print(f"Saved configuration on {hostname}.")

        tn.write(b"exit\n")
        tn.close()

        print(f"SSH configured successfully on {hostname}")
    except Exception as e:
        print(f"Failed to configure SSH on {hostname}: {str(e)}")

# Read switches from a text file (one per line)
switches_file = "locaton_of_file"
try:
    with open(switches_file, "r") as file:
        switches = [line.strip() for line in file.readlines()]
except FileNotFoundError:
    print(f"Error: {switches_file} not found.")
    exit(1)

# Prompt for Telnet and SSH credentials
domain = input("Enter your domain here")
user = input("Enter your username here")
telnet_password = input("Enter your Telnet password: ")
enable_password = input("Enter your enable mode password: ")
ssh_password = input("Enter your SSH password: ")

# Loop through the list of switches and configure SSH
for switch in switches:
    configure_ssh(switch, domain, user, telnet_password, enable_password, ssh_password)

print("All switches updated to use SSH.")
