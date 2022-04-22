# Setting up Rancher
Two primary methods: 
1. Setup Rancher with Docker on an external Host outside of the cluster
2. Setup Highly Available Rancher within the cluster
## Method 1: Deplying Rancher with Docker externally
1. First setup and install Docker on your respctive machine
    - For Ubuntu Linux:
        - Setup Pre-requisites for Docker`sudo apt-get update`
        -   ```
            sudo apt-get install \
            ca-certificates \
            curl \
            gnupg \
            lsb-release 
    -  `curl -fsSL https://get.docker.com -o get-docker.sh`
    - `sudo sh get-docker.sh`
2. Setup Docker Container
    - Run ```
         docker run -d --restart=unless-stopped \
         -p 80:80 -p 443:443 \
         --privileged \
         rancher/rancher:latest ```
3. Get Password for first-time login
    - Run `docker logs  container-id  2>&1 | grep "Bootstrap Password:"`

## Method 2: Deploying Rancher on Workers using Helm <br>
This deployment will be using the self-generated Rancher Certificate. <br>
Either from a Master Node, or the Controller machine (If you followed step 4):
1. Add the Helm Chart Repository
    - Install helm 
        - `curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3`
        - `chmod 700 get_helm.sh`
        - `./get_helm.sh`
    - Use Stable release: `helm repo add rancher-stable https://releases.rancher.com/server-charts/stable`
2. Create Namespace within K3s for Rancher
    - `kubectl create namespace cattle-system`
3. Install Cert Manager (Required for self-hosted cert)
    - `kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.5.1/cert-manager.crds.yaml`
    - `helm repo add jetstack https://charts.jetstack.io`
    -  `helm repo update`
    - ```bash
       helm install cert-manager jetstack/cert-manager \
        --namespace cert-manager \
        --create-namespace \
        --version v1.5.1
        ```
      *If you experience an issue running this, such as localhost:8080 error, add KUBECONFIG as an environment variable to fix it:* `export KUBECONFIG=/etc/rancher/k3s/k3s.yaml`
      *If that does not fix it, ensure the .kube config file exists in the proper locaiton* `kubectl config view --raw > ~/.kube/config`
    - Verify it is working w/ `kubectl get pods --namespace cert-manager`

4. Install Rancher using Helm
    - ```
        helm install rancher rancher-stable/rancher \
        --namespace cattle-system \
        --set hostname=port.lan \
        --set replicas=3 \
        --set bootstrapPassword=password
    - Check on deployment w/ `kubectl -n cattle-system rollout status deploy/rancher`
    - Once finished, obtain info on deployment w/ `kubectl -n cattle-system get deploy rancher`
5. Once Rancher is deployed
    - Navigate to {LoadBalancer-DNS} site
		- *It must be the DNS entry of the Load Balancer due to the certification. An IP adddress will NOT work*
    - Find your secret using command given at site login, and log into the site

Bam, Rancher installed, and it is now highly available.
## Troubeshooting Rancher
- If you must uninstall and reinstall Rancher for any reason, I recommend these steps (They are painful)
    - For the name spaces affecting Rancher Directly,
    -   `sudo kubectl delete namespace namespace-name`
    - Check it w/ `kubectl get ns`
    - If stuck in terminating, `kubectl edit ns namespace-name`
        - Delete everything under the finalizer: fields (Sometimes there are two.)