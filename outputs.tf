output "container_ipv4_address" {
  value = azurerm_container_group.container.ip_address
}

output "container_fqdn" {
  value = "http://${azurerm_container_group.container.fqdn}:${var.port}"
}

