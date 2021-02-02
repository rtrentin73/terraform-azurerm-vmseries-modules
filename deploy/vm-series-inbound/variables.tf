#----------------------#
#   Global Variables   #
#----------------------#
variable "location" {
  type        = string
  description = "The Azure region to use."
  default     = "UK South"
}

variable "name_prefix" {
  type        = string
  description = "A prefix for all naming conventions - used globally"
  default     = "pan"
}

variable "create_resource_group_name" {
  description = "Name for a created resource group. The input is ignored if `existing_resource_group_name` is set. If null, uses an auto-generated name."
  default     = null
  type        = string
}

variable "existing_resource_group_name" {
  description = "Name of an existing resource group to use. If null, use instead `create_resource_group_name`."
  default     = null
  type        = string
}

variable "username" {
  description = "Initial administrative username to use for all systems."
  default     = "panadmin"
  type        = string
}

variable "password" {
  description = "Initial administrative password to use for all systems. Set to null for an auto-generated password."
  default     = null
  type        = string
}

variable "instances" {
  description = "Map of VM-Series firewall instances to deploy. The keys are the firewall hostnames."
}

#----------------------#
#      Networking      #
#----------------------#
variable "management_ips" {
  type        = map(any)
  description = "A list of IP addresses and/or subnets that are permitted to access the out of band Management network."
}

variable "vmseries_subnet_mgmt" {
  description = "Management subnet."
}

variable "vmseries_subnet_public" {
  description = "External/public subnet."
}

variable "vmseries_subnet_private" {
  description = "Internal/private subnet."
}

variable "olb_private_ip" {
  description = "The private IP address to assign to the Outbound Load Balancer. This IP **must** fall in the `vmseries_subnet_private` network."
}

variable "frontend_ips" {
  description = <<-EOF
  A map of objects describing Inbound LB Frontend IP configurations. Keys of the map are the names and values are { create_public_ip, public_ip_address_id, rules }. Example:

  ```
  {
    "pip-existing" = {
      create_public_ip     = false
      public_ip_address_id = azurerm_public_ip.this.id
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
    "pip-created" = {
      create_public_ip = true
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
  ```
  EOF
}

#----------------------#
#      VM Options      #
#----------------------#

variable "vm_series_sku" {
  default = "byol"
}

variable "vm_series_version" {
  default = "9.1.6"
}

variable "vm_series_vm_size" {
  description = "Azure VM size (type) to be created. Consult the *VM-Series Deployment Guide* as only a few selected sizes are supported."
  default     = "Standard_D3_v2"
  type        = string
}

# SCHRODERS ADDITIONS
variable subscription_id {}
variable tenant_id {}
