#!/bin/bash
# Set of commands to be used for initial setup of High Availability Kubernetes cluster agent servers

# Requires NGINX Reverse Proxy (Load Balancer) to be set up already (Step 1)
# Requires mysql database to be setup already (Step 2)
# Requires obtaining of kubernetes token using the following the command:
#   - sudo cat /var/lib/rancher/k3s/server/node-token
# Usage:
#    - curl -sfL https://get.k3s.io | K3S_URL=[PROXY_ADDRESS]:6443 K3S_TOKEN=[KUBERNETES_TOKEN] sh -
curl -sfL https://get.k3s.io | K3S_URL=https://10.175.133.200:6443 K3S_TOKEN=AJAKEKGA3453434FDKJBN443453KJADHKNJLN sh -

