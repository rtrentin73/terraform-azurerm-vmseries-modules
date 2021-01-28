# Configure the Azure provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "= 2.43.0"
  features {}
}

provider "random" {
  version = "= 3.0.1"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Setup all the networks required for the topology
module "networks" {
  source = "../../modules/networking"

  location               = var.location
  management_ips         = var.management_ips
  name_prefix            = var.name_prefix
  management_vnet_prefix = var.management_vnet_prefix
  management_subnet      = var.management_subnet
  firewall_vnet_prefix   = var.firewall_vnet_prefix
  private_subnet         = var.private_subnet
  public_subnet          = var.public_subnet
  vm_management_subnet   = var.vm_management_subnet
  # olb_private_ip         = var.olb_private_ip
}

resource "azurerm_resource_group" "vmseries" {
  location = var.location
  name     = "${var.name_prefix}-vmseries-rg"
}

module "bootstrap" {
  source = "../../modules/vm-bootstrap"

  location    = var.location
  name_prefix = var.name_prefix
}

# Create a public IP for management
resource "azurerm_public_ip" "mgmt" {
  name                = "fw00-mgmt"
  location            = azurerm_resource_group.vmseries.location
  resource_group_name = azurerm_resource_group.vmseries.name
  allocation_method   = "Static"
  sku                 = "standard"
}

# Create a firewall
module "inbound-vm-series" {
  source = "../../modules/vm-series"

  resource_group            = azurerm_resource_group.vmseries
  location                  = azurerm_resource_group.vmseries.location
  name_prefix               = var.name_prefix
  username                  = var.username
  password                  = coalesce(var.password, random_password.password.result)
  vm_series_version         = "9.1.3"
  vm_series_sku             = "byol"
  subnet-mgmt               = module.networks.subnet-mgmt
  subnet-private            = module.networks.subnet-private
  subnet-public             = module.networks.subnet-public
  bootstrap-storage-account = module.bootstrap.storage_account
  enable_backend_pool       = false
  instances = {
    "PA-VM" = {
      mgmt_public_ip_address_id = azurerm_public_ip.mgmt.id
    }
  }
}
