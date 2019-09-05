# tf-aws-ec2-instance
This module will build development instance into an existing VPC.  The instances will be directly accessible to the defined ingress cidr block on defined ports (defaults: 22, 80, 443).  These will be running ubuntu.

## Quickstart
```
vi variables.tf
```
* Define your unique name.  This will be used for your resources (name_prefix)
* Get the TFE Workspace name currently managing your Network and update the tfe variables (tfe_workspace, tfe_host, tfe_org)
* Set the number of instance you want to build (count)
* Set a secure ingress CIDR block (ingress_cidr_block).  The default is unsecure (0.0.0.0)
* If you want custom HTTP, and HTTP ports set the http variables (http_port, https_port)

### TFE UI
Build your personal workspace with AWS env variables, and terraform variables.

Now Queue a Run.

### TFE CLI
**create your .terraformrc file to include your TFE credentials with apply privilages**
```
terraform init
terraform plan
terraform apply -auto-approve
```


