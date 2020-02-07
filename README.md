# Windows Dev Box On-Demand


## Clone this repo

```
git clone https://github.com/liatrio/choco_dev.git

```
## EDIT THE STATE FILE KEY IN MAIN.TF

 until we have terragrunt template/randomize this so we don't clash.

## Create an azure app/key provider file. 

Get values by creating a service principal via cli
 or
by using the console to create an approle in the portal.

Then granting permissions

See This Guide:

https://www.terraform.io/docs/providers/azurerm/guides/service_principal_client_secret.html

#### Example provider file.

```
cat provider.tf

provider "azurerm" {
    subscription_id = "5e1a2851-dontuse-my-secret-ids"
    client_id       = "cd80ecf8-dontuse-my-secret-ids"
    client_secret   = "getyourownclientsecret"
    tenant_id       = "1b4a4fed-thisis-mytenant-id"
    skip_provider_registration = true
}

```

## Then stand it up. 
```
terraform init
terraform apply --auto-approve

# Required to run it again to get the IP output to work for now.
terraform apply --auto-approve
```
## Login w/ windows RDP client (Available in Mac App store)

Enter the creds and go code!
Launch vs code + Powershell
```
# Make a new package
cd c:\
# Create a new package template 
choco new test2 -a --version 0.0.1 maintainername="'myusername'"
choco pack
choco push
choco install test2

```
## Helpful Links
### Choco docs
https://chocolatey.org/docs

### example pkgs
https://github.com/liatrio/choco_poc

### Helpers
https://chocolatey.org/docs/helpers-get-chocolatey-web-file

### Troubleshooting install shield errors and inputs
https://www.symantec.com/connect/articles/windows-system-error-codes-exit-codes-description

http://www.silentinstall.org/InstallShield
https://www.itninja.com/blog/view/installshield-setup-silent-installation-switches
https://www.itninja.com/static/090770319967727eb89b428d77dcac07.pdf



## Destroy it when done

```
terraform destroy
```
