# Create a virtual machine in vSphere
#First connect to server
$myvSphereServer = "fqdn-or-ipaddress"
$myvSphereUser = "username"
connect-viserver -server $myvSphereServer -Protocol https -User $myvSphereUser
#Assign variables
$myCluster = Get-Cluster -Name EsxiClust01 #Your Cluster name
$myDataStoreClust = Get-DatastoreCluster -Name DatastoreCluster #Datastorecluster Name here
$myTemplate = Get-Template -Name Ubuntu-Template #Name of Template being used
$myVMName = "Linux-Computer!"
#Create VM with Template
New-VM -Name $myVMName -ResourcePool $myCluster -Template $myTemplate -Datastore $myDataStoreClust

# Purpose of this is to take a template created in vSphere and create a virutal machine using this script
# In theory it could be used to make multiple or just one based on a as needed basis