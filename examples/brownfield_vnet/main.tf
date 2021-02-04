provider "azurerm" {
  features {}
}

module "vnet" {
  source = "../../modules/vnet"

  location            = "East US"
  resource_group_name = "df_vnet_test_rg"

  virtual_network_name        = "df_vnet_1"
  address_space               = ["10.100.0.0/16"]
  network_security_group_name = "df_nsg_1"
  subnets = {
    "sb_1" = {
      existing         = false
      name             = "mgmt"
      address_prefixes = ["10.100.0.0/24"], // Optional
      security_group   = "df_nsg_1"
      # route_table      = "mgmt_rtb"
      # tags             = { "foo" = "bar" } // Optional
    }
    "sb_2" = {
      existing         = false
      name             = "public"
      address_prefixes = ["10.100.1.0/24"],
      security_group   = "df_nsg_1"
      # route_table      = "public_rtb"
      # tags             = { "foo" = "bar" } // Optional
    }
    "sb_3" = {
      existing         = false
      name             = "private"
      address_prefixes = ["10.100.2.0/24"],
      security_group   = "df_nsg_1"
      # route_table      = "public_rtb"
      # tags             = { "foo" = "bar" } // Optional
    }
  }
}
# network_security_groups = {
#   nsg_1 = {
#     # resource_group_name = "rg_2" // Optional, if not defined use the parent RG
#     name = "df_nsg_1"
#     tags = { "foo" = "bar" }
#   }
# }
#   rules = {
#     all-inbound = {
#       name                       = "Permit All traffic outbound"
#       priority                   = 100
#       direction                  = "Inbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#     all-outbound = {
#       name                       = "Permit All outbound traffic"
#       priority                   = 100
#       direction                  = "Outbound"
#       access                     = "Allow"
#       protocol                   = "Tcp"
#       source_port_range          = "*"
#       destination_port_range     = "*"
#       source_address_prefix      = "*"
#       destination_address_prefix = "*"
#     }
#   }
# }
#