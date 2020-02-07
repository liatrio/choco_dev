terraform {
  backend "azurerm" {
    resource_group_name  = "Golden-Image-POC"
    storage_account_name = "liatriogoldenimagepoc"
    container_name       = "golden-image-tfstate"
    key                  = "my-choco-test.tfstate"
  }
}


# Random ID string for pw and vmname.
resource "random_string" "random" {
  length = 12
  special = false
}

# Random password + special vars matches IDs for things.
locals {
  admin_user = "azureuser"
  admin_pass = "${random_string.random.result}Aa1!"
}

# Resource group
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "${random_string.random.result}_ResourceGroup"
    location = var.location

    tags = {
        environment = "Terraform Demo"
    }
}

# Golden Image Lookup
data "azurerm_image" "new_image" {
  name                = "${var.custom_image_name}"
  resource_group_name = "${var.custom_image_resource_group_name}"
}



