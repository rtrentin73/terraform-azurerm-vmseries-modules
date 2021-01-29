# Configure the Azure provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = ">=2.24.0"
  features {}
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create the VM-Series RG outside of the module and pass it in.
resource "azurerm_resource_group" "vmseries" {
  count = var.existing_resource_group_name == null ? 1 : 0

  location = var.location
  name     = coalesce(var.create_resource_group_name, "${var.name_prefix}-vmseries-rg")
}

locals {
  resource_group_name = coalesce(var.existing_resource_group_name, azurerm_resource_group.vmseries[0].name)
}

# Create a public IP for management
resource "azurerm_public_ip" "mgmt" {
  for_each = var.instances

  name                = "${var.name_prefix}${each.key}-mgmt"
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "standard"
}

# Create another PIP for the outside interface so we can talk outbound
resource "azurerm_public_ip" "public" {
  for_each = var.instances

  name                = "${var.name_prefix}${each.key}-public"
  location            = var.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  sku                 = "standard"
}

module "inbound-lb" {
  source = "../../modules/inbound-load-balancer"

  location     = var.location
  name_prefix  = var.name_prefix
  frontend_ips = var.frontend_ips
}

module "bootstrap" {
  source = "../../modules/vm-bootstrap"

  location           = var.location
  storage_share_name = "ibbootstrapshare"
  name_prefix        = var.name_prefix
  files = {
    "bootstrap_files/authcodes"    = "license/authcodes"
    "bootstrap_files/init-cfg.txt" = "config/init-cfg.txt"
  }
}

# Create VM-Series virtual machines for handling Inbound traffic.
module "inbound" {
  source = "../../modules/vm-series"

  location                  = var.location
  resource_group_name       = local.resource_group_name
  name_prefix               = var.name_prefix
  username                  = var.username
  password                  = coalesce(var.password, random_password.password.result)
  vm_size                   = var.vm_series_vm_size
  vm_series_version         = var.vm_series_version
  vm_series_sku             = var.vm_series_sku
  subnet-mgmt               = { id = var.vmseries_subnet_mgmt }
  subnet-public             = { id = var.vmseries_subnet_public }
  subnet-private            = { id = var.vmseries_subnet_private }
  bootstrap-storage-account = module.bootstrap.storage_account
  bootstrap-share-name      = module.bootstrap.storage_share_name
  lb_backend_pool_id        = module.inbound-lb.backend-pool-id
  instances = { for k, v in var.instances : k => {
    mgmt_public_ip_address_id = azurerm_public_ip.mgmt[k].id
    nic1_public_ip_address_id = azurerm_public_ip.public[k].id
  } }

  depends_on = [module.bootstrap]
}
