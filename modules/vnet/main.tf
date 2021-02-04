//Resource Group
resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "this" {
  name       = var.resource_group_name
  depends_on = [azurerm_resource_group.this]
}

//Network Security Groups
resource "azurerm_network_security_group" "this" {
  count = var.create_network_security_group ? 1 : 0

  name                = var.network_security_group_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
}

data "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  resource_group_name = data.azurerm_resource_group.this.name
  depends_on          = [azurerm_network_security_group.this]
}

//VNet
resource "azurerm_virtual_network" "this" {
  count = var.create_virtual_network ? 1 : 0

  name                = var.virtual_network_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = var.address_space
}

data "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.this.name
  depends_on          = [azurerm_virtual_network.this]
}

//Subnets
// Since subnet can be configured both inline and via the separate azurerm_subnet 
// resource, we have to explicitly set it to empty slice ([]) to remove it.

resource "azurerm_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s if s.existing != true }

  name                 = each.value.name
  resource_group_name  = data.azurerm_virtual_network.this.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes
  # security_group       = data.network_security_group_name.this.id
}

# data "azurerm_subnet" "this" {
#   for_each = { for s in var.subnets : s.name => s if s.existing == true }

#   name                 = each.value.name //each key?
#   resource_group_name  = data.azurerm_resource_group.this.name
#   virtual_network_name = data.azurerm_virtual_network.this.name
#   security_group       = data.network_security_group_name.this.id
#   depends_on           = [azurerm_subnet.this]
# }

# resource "azurerm_network_security_rule" "custom" {
#   for_each = var.rules

#   name                        = each.key
#   resource_group_name         = data.azurerm_virtual_network.this.resource_group_name
#   network_security_group_name = "nsg_1"

#   priority                   = each.value.priority
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_port_range          = "*"
#   destination_port_ranges    = ["22", "80", "1000-2000"]
#   source_address_prefixes    = ["10.0.0.0/24", "10.1.0.0/24"]
#   destination_address_prefix = "*"
# }


#   security_rule {
#     name                       = each.key
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   tags = {
#     environment = "Production"
#   }
# }





// odwroc kolejnosc, pierw sprawdzaj source i na jego podstawie dobij resource

# data "azurerm_subnet" "this" {
#   for_each             = { for s in var.subnets : s.name => var.virtual_network_name }
#   name                 = each.key
#   virtual_network_name = each.value
#   resource_group_name  = data.azurerm_resource_group.this.name
#   depends_on           = [azurerm_subnet.this]
# }

