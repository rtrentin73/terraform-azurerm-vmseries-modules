//Resource Group
resource "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 1 : 0

  name     = var.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "this" {
  name       = var.resource_group_name
  depends_on = [azurerm_resource_group.this]
}

//Network Security Groups and Rules
resource "azurerm_network_security_group" "this" {
  count = var.create_network_security_group ? 1 : 0

  name                = var.network_security_group_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  dynamic "security_rule" {
    for_each = var.rules

    content {
      name                       = security_rule.value["name"]
      priority                   = security_rule.value["priority"]
      direction                  = security_rule.value["direction"]
      access                     = security_rule.value["access"]
      protocol                   = security_rule.value["protocol"]
      source_port_range          = security_rule.value["source_port_range"]
      destination_port_range     = security_rule.value["destination_port_range"]
      source_address_prefix      = security_rule.value["source_address_prefix"]
      destination_address_prefix = security_rule.value["destination_address_prefix"]
    }
  }
}

data "azurerm_network_security_group" "this" {
  name                = var.network_security_group_name
  resource_group_name = data.azurerm_resource_group.this.name
  depends_on          = [azurerm_network_security_group.this]
}

//VNet and Subnet association
resource "azurerm_virtual_network" "this" {
  count = var.create_virtual_network ? 1 : 0

  name                = var.virtual_network_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = var.address_space

  dynamic "subnet" {
    for_each = var.subnets

    content {
      name           = subnet.value["name"]
      address_prefix = subnet.value["address_prefix"]
      security_group = coalesce(subnet.value["security_group"], data.azurerm_network_security_group.this.id)
    }
  }
  depends_on = [azurerm_network_security_group.this]
}

# data "azurerm_virtual_network" "this" {
#   name                = var.virtual_network_name
#   resource_group_name = data.azurerm_resource_group.this.name
#   depends_on          = [azurerm_virtual_network.this]
# }

//Route Table creation
resource "azurerm_route_table" "this" {
  name                = var.route_table_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  disable_bgp_route_propagation = false

  dynamic "route" {
    for_each = var.routes

    content {
      name           = route.value["name"]
      address_prefix = route.value["address_prefix"]
      next_hop_type  = route.value["next_hop_type"]
    } 
  }

  tags = {
    environment = "Production"
  }
}

//Route Table association
resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = azurerm_subnet.this.id
  route_table_id = azurerm_route_table.this.id
}
