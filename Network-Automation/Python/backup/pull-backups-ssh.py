import os
import paramiko

# SSH connection details
ssh_hosts = ["remote_host1", "remote_host2"]  # List of remote hosts
ssh_username = "username"
ssh_password = "password"
ssh_port = 22

# Source directory on remote hosts
source_directory = "/path/to/backup"

# Destination directory on local machine
destination_directory = "/path/to/new_location"

# Iterate over each remote host
for host in ssh_hosts:
    # Connect to the remote host
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(host, port=ssh_port, username=ssh_username, password=ssh_password)

    # Transfer backup files using SCP
    sftp_client = ssh_client.open_sftp()
    for root, dirs, files in sftp_client.walk(source_directory):
        relative_path = os.path.relpath(root, source_directory)
        remote_path = os.path.join(destination_directory, host, relative_path)

        # Create local directories if they don't exist
        os.makedirs(remote_path, exist_ok=True)

        # Transfer files from remote host to local machine
        for file in files:
            remote_file = os.path.join(root, file)
            local_file = os.path.join(remote_path, file)
            sftp_client.get(remote_file, local_file)
            print(f"Transferred: {host}:{remote_file} -> {local_file}")

    # Close the SSH and SFTP connections for the current host
    sftp_client.close()
    ssh_client.close()

print("Backup transfer completed.")
