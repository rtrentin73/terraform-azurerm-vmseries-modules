//Options enabling a Greenfield deployment
variable "create_resource_group" {
  description = "Enable this option if you want to create a new Resource Group, default value set to `true`"
  default     = true
}
variable "create_network_security_group" {
  description = "Enable this option if you want to create a new Network Security Group, default value set to `true`"
  default     = true
}

variable "create_virtual_network" {
  description = "Enable this option if you want to create a new VNet, default value set to `true`"
  default     = true
}

//Resource variables
variable "network_security_group_name" {
  description = "Name of the Network Security Group to create."
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network to create."
}

variable "address_space" {
  description = "Address space for VNet."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "Definition of subnets to create."
}

variable "location" {
  description = "Location of the resources that will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group to create."
  type        = string
}