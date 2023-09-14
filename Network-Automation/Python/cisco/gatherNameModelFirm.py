from netmiko import ConnectHandler
from tabulate import tabulate

def connect_and_gather_info(ip, user, ssh_password, enable_password):
    # Set up connection details
    device = {
        'device_type': 'cisco_ios',
        'ip': ip,
        'username': user,
        'password': ssh_password,
        'secret': enable_password
    }

    connection = ConnectHandler(**device)
    connection.enable()  # This enters enable mode

    name = connection.find_prompt().strip('#>').strip()
    model_info = connection.send_command("show version | include Model").strip()
    version_info = connection.send_command("show version | include Version").strip()

    model = model_info.split(":")[-1].strip()
    version = version_info.split(":")[-1].strip()

    connection.disconnect()

    return name, model, version

def main():
    user = input("Ener username here: ")
    ssh_password = input("Enter the SSH password for devices: ")
    enable_password = input("Enter the enable password for devices: ")
    results = []

    # Read IPs from txt file
    with open("device_list.txt", "r") as file:
        ips = file.readlines()

    for ip in ips:
        ip = ip.strip()
        try:
            name, model, version = connect_and_gather_info(ip, user, ssh_password, enable_password)
            results.append([name, ip, model, version])
        except Exception as e:
            print(f"Error connecting to {ip}: {e}")
            continue

    # Print results in table format
    print(tabulate(results, headers=["Name", "IP", "Device Model", "Firmware Version"]))

if __name__ == "__main__":
    main()
