This covers the set of commands to be used for initial setup of High Availability Kubernetes cluster server and client nodes
# Server Nodes
1. On the first Server node run these commands (Also see in file ServerNodes-Setup.sh):
    - export K3S_DATASTORE_ENDPOINT='mysql://user:password@tcp(sqlhost:3306)/database-name'
    - curl -sfL https://get.k3s.io | sh -s - server --node-taint CriticalAddonsOnly=true:NoExecute --tls-san 'Load-Balancer-Address'
After it has connected and you can successfully see nodes with `sudo kubectl get nodes`
    - Obtain node-token from `sudo cat /var/lib/rancher/k3s/server/node-token`
2. On additional server nodes (Also see in file ClientAgents-Setup.sh):
    - export K3S_DATASTORE_ENDPOINT='mysql://user:password@tcp(sqlhost:3306)/database-name
    - Curl -sfL https://get.k3s.io | sh -s - server --node-taint CriticalAddonsOnly=true:NoExecute --tls-san 'Load-Balancer-Address' --token asdxhuiserver-token-here1254hi sh -
# Client Agents
On all client agents to be added to cluster
- export K3S_DATASTORE_ENDPOINT='mysql://user:password@tcp(sqlhost:3306)/database-name'
- curl -sfL https://get.k3s.io | K3S_URL=https://'Load-Balance-Address':6443 K3S_TOKEN=TOKENHERE sh -

# Controller
1. Once Cluster has been setup
    - install k3s on controller machine w/ `curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`
    - On a server node run:
        - `sudo nano /etc/rancher/k3s/k3s.yaml`
    - Copy contents of that file to a file on your dev machine at location /home/user/.kube/config (Change IP address in config to match your Load Balancer)
    - verify it is working w/ `kubectl cluster-info`
