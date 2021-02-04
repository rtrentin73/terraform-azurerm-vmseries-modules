provider "azurerm" {
  features {}
}

module "vnet" {
  source = "../../modules/vnet"

  resource_group_name         = "df_rg"
  location                    = "East US"
  address_space               = ["10.100.0.0/16"]
  virtual_network_name        = "df_vnet_1"
  network_security_group_name = "df_nsg"
  rules = {
    "all-inbound" = {
      name                       = "Block_all_inbound"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    "all-outbound" = {
      name                       = "Permit_all_outbound"
      priority                   = 100
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  subnets = {
    "sb_1" = {
      existing       = false
      name           = "mgmt"
      address_prefix = "10.100.0.0/24" // Optional
      security_group = null
      # route_table      = "mgmt_rtb"
      # tags             = { "foo" = "bar" } // Optional
    }
    "sb_2" = {
      existing       = false
      name           = "public"
      address_prefix = "10.100.1.0/24"
      security_group = null
      # route_table      = "public_rtb"
      # tags             = { "foo" = "bar" } // Optional
    }
    "sb_3" = {
      existing       = false
      name           = "private"
      address_prefix = "10.100.2.0/24"
      security_group = null //has to be an ID
      # route_table      = "public_rtb"
      # tags             = { "foo" = "bar" } // Optional
    }
  }
  route_table_name = "route_table_1"
  routes = {
    "route_1" = {
      name           = "route1"
      address_prefix = "10.1.0.0/16"
      next_hop_type  = "vnetlocal"
    }
  }
}