


output "public_ip_address" {
  value = data.azurerm_public_ip.myterraformpublicip.ip_address
}

output "instance_admin_user" {
  value = local.admin_user
}

output "instance_admin_pass" {
  value = local.admin_pass
}
