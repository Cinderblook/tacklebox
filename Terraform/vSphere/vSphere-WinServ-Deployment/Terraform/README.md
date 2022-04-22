## Terraform
Main role: Deploy the Virtual Machines
-   Setup the four Windows Servers (Primary Domain Controller, Replica Domain Controller, DHCP, Fileshare)
    - Using the vSphere provider:
        - Assign appropriate resources to each machine 
- Once prepared with appropriate values and the networking is in place: 
    - Navigate to the Terraform directory and run these commands
    - `terraform init` Pull proper Terraform providers and modules used
    - `terraform validate` This will return whether the configuration is valid or not
    - `terraform apply` ... `yes` Actually apply the configuration
## Terraform Variable files 
- *variables.tf*
    - Declare variables that will be used with the Terraform configuration
- *terraform.tfvars*
    - Assign variables that will be used with the Terraform configuration

## Useful Terraform Resources
- Terraform [Documentation](https://www.terraform.io/docs)