# Setup all the networks required for the topology
module "net" {
  source = "../../modules/networking"

  location       = var.location
  name_prefix    = var.name_prefix
  management_ips = var.management_ips
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "panorama" {
  source = "../../modules/panorama"

  location         = var.location
  name_prefix      = var.name_prefix
  subnet_mgmt      = module.net.panorama-mgmt-subnet
  panorama_size    = var.panorama_size
  panorama_version = var.panorama_version
  username         = var.username
  password         = random_password.password.result
}


output panorama_url {
  value = "https://${module.panorama.panorama-publicip}"
}

output panorama_admin_user {
  value = var.username
}

output panorama_admin_password {
  value = random_password.password.result
}

############### Passing Subnets ###############

# output "vmseries_subnet_mgmt" {
#   value = module.net.subnet-mgmt.id
# }

# output "vmseries_subnet_public" {
#   value = module.net.subnet-public.id
# }

# output "vmseries_subnet_private" {
#   value = module.net.subnet-private.id
# }

output "outputs_for_further_use" {
  value = {
    vmseries_subnet_mgmt    = module.net.subnet-mgmt.id
    vmseries_subnet_public  = module.net.subnet-public.id
    vmseries_subnet_private = module.net.subnet-private.id
  }
}

############### Public IP Adresses Pre-Allocated ###############

resource "azurerm_public_ip" "alpha" {
  name                = "${var.name_prefix}alpha"
  resource_group_name = module.net.vnet.resource_group_name
  location            = module.net.vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "beta" {
  name                = "${var.name_prefix}beta"
  resource_group_name = module.net.vnet.resource_group_name
  location            = module.net.vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "gamma" {
  name                = "${var.name_prefix}gamma"
  resource_group_name = module.net.vnet.resource_group_name
  location            = module.net.vnet.location
  sku                 = "Standard"
  allocation_method   = "Static"
}

output "frontend_ips_to_use" {
  value = { for pip in [
    azurerm_public_ip.alpha,
    azurerm_public_ip.beta,
    azurerm_public_ip.gamma,
    ]
    :
    pip.name => {
      create_public_ip     = false
      public_ip_address_id = pip.id
      rules = {
        "testssh" = {
          protocol = "Tcp"
          port     = 22
        }
        "testhttp" = {
          protocol = "Tcp"
          port     = 80
        }
      }
    }
  }
}
