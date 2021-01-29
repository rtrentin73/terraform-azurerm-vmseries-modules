terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 2.3.1"
    }
  }
}

# SCHRODERS ADDITIONS
provider "azurerm" {
    subscription_id = var.subscription_id 
    tenant_id       = var.tenant_id
    features {}
}