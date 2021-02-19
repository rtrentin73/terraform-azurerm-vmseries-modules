variable "resource_group_name" {
  description = "Name of the Resource Group to use."
  type        = string
}

variable "subnets" {
  description = "Definition of subnets to create."
  default     = {}
}

variable "network_security_group" {
  description = "Network Security Groups to create."
}

variable "route_table" {
  description = "Route Tables to create."
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network to create."
}

variable "address_space" {
  description = "Address space for VNet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}