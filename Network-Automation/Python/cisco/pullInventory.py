import paramiko
import os

# Function to collect inventory data from a Cisco device
def collect_inventory_data(hostname, username, password):
    try:
        print(f"Collecting inventory data from {hostname}...")
        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        
        # Connect to the device via SSH
        ssh.connect(hostname, username=username, password=password, timeout=10)
        
        # Run the command to retrieve inventory data
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command("show inventory")
        inventory_data = ssh_stdout.read().decode('utf-8')
        
        # Close the SSH connection
        ssh.close()
        
        # Create a directory for the device's data
        device_directory = os.path.join("inventory_data", hostname)
        os.makedirs(device_directory, exist_ok=True)
        
        # Create a file for the inventory data
        file_path = os.path.join(device_directory, "inventory.txt")
        with open(file_path, "w") as file:
            file.write(inventory_data)
        
        print(f"Inventory data saved to {file_path}")
    except Exception as e:
        print(f"Failed to collect inventory data from {hostname}: {str(e)}")

# Specify the path to the file containing device hostnames or IP addresses
devices_file = "device_list.txt"

# Specify the username as "admin"
username = input(f"Enter the username for SSH connection: ")
password = input(f"Enter the password for SSH connection: ")
# Create a directory to store inventory data
os.makedirs("inventory_data", exist_ok=True)

# Read the list of device hostnames or IP addresses from the file
try:
    with open(devices_file, "r") as file:
        device_lines = file.readlines()

    # Loop through the lines in the file and collect inventory data
    for line in device_lines:
        hostname = line.strip()
        
        collect_inventory_data(hostname, username, password)
except FileNotFoundError:
    print(f"Error: {devices_file} not found.")

print("Inventory data collection completed.")
