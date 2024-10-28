terraform {
  required_providers {
     azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.0.0"
    } 
  }
  required_version = "~> 1.9.0"
}

provider "azurerm" {
  features {}
}

variable "prefix" {
  default = "terraform"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-ResourceGroup"
  location = "Australia East"
}
