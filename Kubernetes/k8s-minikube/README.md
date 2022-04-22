# Overview
Creating a K8S cluster using Minikube

# Getting Started
1. navigate to [minikube's site](https://minikube.sigs.k8s.io/docs/start/) and install minikube to your local machine
   - This will include installing Docker, and setting up the [driver for Docker](https://minikube.sigs.k8s.io/docs/drivers/docker/),
2. start your cluster with `minikube start --driver docker`
   - Check status with `minikube status` and check total node count with `kubectl get node` 
3. Change variables within deployment files
   - In mongo-secret.yaml file, enter username and password. These must be base64. Generate the user/pass with `echo -n PASSWORD/USERNAME-HERE | base64`
4. Launch deployments in correct order
   1. `kubectl apply -f mongo-config.yaml`
   2. `kubectl apply -f mongo-secret.yaml`
   3. `kubectl apply -f mongo.yaml`
   4. `kubectl apply -f webapp.yaml`
5. Confirm it worked `kubectl get all`
   - Check for running services, deployments, and replicas. There should be 3 services, 2 deploymentss, and 2 replicas running.
   - Also check `kubectl get svc` to see exact services running on which ports.
   - See minkube's ip address with `minikube ip`
6. Connect to site hosted with minikube `x.x.x.x:30100`

<br>

## K8s manifest files in use
- mongo-config.yaml
- mongo-secret.yaml
- mongo.yaml
- webapp.yaml

## Useful Commands
- Applying K8 files `kubectl apply -f *filename*`

- Start minikube `minikube start --vm-driver=hyperkit `

- Check status  `minikube status`

- Get node ip address `minikube ip`
  
Basic info about k8s components
- `kubectl get node`
- `kubectl get pod`
- `kubectl get svc`
- `kubectl get all`

Extended info about components
- `kubectl get pod -o wide`
- `kubectl get node -o wide`

Detailed info about a specific component
- `kubectl describe svc {svc-name}`
- `kubectl describe pod {pod-name}`

Application logs
- `kubectl logs {pod-name}`

Stop Minikube cluster
- `minikube stop`


## Resources
- [mongodb image on Docker Hub](https://hub.docker.com/_/mongo)
- [webapp image on Docker Hub](https://hub.docker.com/repository/docker/nanajanashia/k8s-demo-app)
- [k8s official documentation](https://kubernetes.io/docs/home/)
- [webapp code repo](https://gitlab.com/nanuchi/developing-with-docker/-/tree/feature/k8s-in-hour)