output "container_ipv4_address" {
  value = azurerm_container_group.azure_container_instance.ip_address
}

output "container_fqdn" {
  value = "https://${azurerm_container_group.azure_container_instance.fqdn}"
}

