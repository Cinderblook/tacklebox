# Must install Paramiko library API - `pip install paramiko` - ensure you are on Py3
# For Windows: I recommend installing Python3 via the Windows Store, so it handles the RUNTIME ENV for you - On Linux, just `apt get py3`
import paramiko
import os
import time
import getpass

# Define the username and password to use for all devices
username = input("Enter username here:" )
password = getpass.getpass("Enter your password: ")

# Function to SSH into a device, retrieve the configuration, and save it locally
def retrieve_switch_config(hostname, save_path):
    try:
        print(f"Connecting to {hostname}...")
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Connect to the device via SSH
        ssh.connect(hostname, username=username, password=password, timeout=10)

        # Start an interactive shell session
        ssh_shell = ssh.invoke_shell()

        # Enter enable mode
        ssh_shell.send("enable\n")
        time.sleep(2)
        ssh_shell.send(password + "\n")
        time.sleep(2)

        # Run the command to retrieve the configuration
        ssh_shell.send("terminal length 0\n")  # To prevent paging
        time.sleep(2)
        ssh_shell.send("show running-config\n")
        time.sleep(20)  # Adjust the sleep duration based on command execution time

        # Read the output
        switch_config = ssh_shell.recv(65535).decode('utf-8')

        # Close the SSH connection
        ssh_shell.send("exit\n")  # Exit enable mode
        ssh_shell.close()

        # Get the current date in the "YYYY-MM-DD" format
        current_date = time.strftime("%Y-%m-%d")

        device_directory = os.path.join("backup_configs", hostname)
        os.makedirs(device_directory, exist_ok=True)

        # Create a file name with the hostname and current date
        #file_name = f"{hostname}_{current_date}_config.txt"
        #file_path = os.path.join(save_path, file_name)
        file_path = os.path.join(device_directory, f"{hostname}_{current_date}_config.txt")

        with open(file_path, "w") as file:
            file.write(switch_config)

        print(f"Configuration saved to {file_path}")
    except Exception as e:
        print(f"Failed to retrieve configuration from {hostname}: {str(e)}")

# Specify the path to the file containing network device hostnames
devices_file = "networkswitch-ip-list.txt"

# Create the save directory if it doesn't exist
#if not os.path.exists(save_directory):
#    os.makedirs(save_directory)

# Read the list of network device hostnames from the file
try:
    with open(devices_file, "r") as file:
        device_lines = file.readlines()

    # Loop through the lines in the file and retrieve configurations
    for line in device_lines:
        hostname = line.strip()
        retrieve_switch_config(hostname, save_directory)
except FileNotFoundError:
    print(f"Error: {devices_file} not found.")

print("Configuration retrieval completed.")
