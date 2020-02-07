#
#
#  Boot an app server and install some packages w/ init.ps1 script. 
#

data "template_file" "auto_logon" {
  template = file("${path.module}/tpl.auto_logon.xml")
 
  vars = {
    admin_username = local.admin_user
    admin_password = local.admin_pass
  }
}


# Public IP

resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "myPublicIP"
    location                     = var.location
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "Terraform Demo"
    }
}

data "azurerm_public_ip" "myterraformpublicip" {
  name                = azurerm_public_ip.myterraformpublicip.name
  resource_group_name = azurerm_resource_group.myterraformgroup.name
}

# NIC to attach the public IP to the VM

resource "azurerm_network_interface" "myterraformnic" {
    name                        = "myNIC"
    location                    = var.location
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    network_security_group_id   = azurerm_network_security_group.myterraformnsg.id

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "Terraform Demo"
    }
}

# App Server Example using init scripts and choco


resource "azurerm_virtual_machine" "infra_init_vm" {
  name                  = "${random_string.random.result}1"
  location              = var.location
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
//  resource_group_name   = azurerm_resource_group.infra_pipeline_rg.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
//  network_interface_ids = [azurerm_network_interface.infra_pipeline_nic.id]
  vm_size               = "Standard_DS2_v2"
//  vm_size               = "Standard_DS1_v2"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_os_disk {
    name              = "${random_string.random.result}-init-OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    id = data.azurerm_image.new_image.id
  }

  os_profile {
    computer_name  = "myvm2"
    admin_username = local.admin_user
    admin_password = local.admin_pass
    custom_data = file("${path.module}/init.ps1")
  }

  os_profile_windows_config {
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = data.template_file.auto_logon.rendered
    }

    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = file("${path.module}/tpl.first_logon_commands.xml")
    }
    winrm {
      protocol = "http"
    }
  }

  boot_diagnostics {
      enabled     = "true"
//     storage_uri = azurerm_storage_account.infra_pipeline_storage_account.primary_blob_endpoint
      storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

  tags = {
    project = "infra-pipeline-tests"
  }
}


