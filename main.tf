terraform {
  required_version = "~> 1.9.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  cloud{}
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.container_group_name_prefix}-${var.prefix}-ResourceGroup"
  location = "${var.resource_group_location}"
}

resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "random_string" "storage_account_name" {
  length  = 24
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_name_label      = "${var.container_group_name_prefix}"
  ip_address_type     = "Public"
  os_type             = "Linux"
  restart_policy      = var.restart_policy

  container {
    name   = "${var.container_name_prefix}-${random_string.container_name.result}"
    image  = var.image
    cpu    = var.cpu_cores
    memory = var.memory_in_gb
  }

  container {
    name   = "caddy"
    image  = "caddy"
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = 443
      protocol = "TCP"
    }

    ports {
      port     = 80
      protocol = "TCP"
    }

    volume {
      name                 = azurerm_storage_share.caddy_share_data.name
      mount_path           = "/data"
      storage_account_name = azurerm_storage_account.caddy_storage.name
      storage_account_key  = azurerm_storage_account.caddy_storage.primary_access_key
      share_name           = azurerm_storage_share.caddy_share_data.name
    }

    commands = ["caddy", "reverse-proxy", "--from", "${var.container_group_name_prefix}.${var.resource_group_location}.azurecontainer.io", "--to", "0.0.0.0:${var.port}"]

  }
}

resource "azurerm_storage_account" "caddy_storage" {
  name                       = random_string.storage_account_name.result
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  account_tier               = "Standard"
  account_replication_type   = "LRS"
  https_traffic_only_enabled = true
}

resource "azurerm_storage_share" "caddy_share_data" {
  name                 = "caddy-share-data"
  storage_account_name = azurerm_storage_account.caddy_storage.name
  quota                = 1
}
