#!/bin/bash

# Step 1: Exec into the docker container
docker exec -it <container_name> sh

# Step 2: Pull SSH Keys from systems
systems=("system1" "system2" "system3")  # Add your system names or IP addresses here

for system in "${systems[@]}"; do
    scp user@$system:~/.ssh/id_rsa.pub ~/.ssh/$system.pub
done

# Step 3: Exit the docker container
exit
