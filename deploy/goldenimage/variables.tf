#----------------------#
#   Global Variables   #
#----------------------#
variable "location" {
  type        = string
  description = "The Azure region to use."
  default     = "Australia Central"
}

variable "name_prefix" {
  type        = string
  description = "A prefix for all naming conventions - used globally"
  default     = "palo-goldenimage-"
}

variable "username" {
  default     = "panadmin"
  description = "Username to use for all systems"
}

variable "password" {
  description = "Admin password to use for all systems"
  default     = null
}

#----------------------#
#      Networking      #
#----------------------#
variable "management_ips" {
  type        = map(any)
  description = "A list of IP addresses and/or subnets that are permitted to access the out of band Management network."
}

# Subnet definitions
#  All subnet defs are joined with their vnet prefix to form a full CIDR prefix
#  ex. for management, ${management_vnet_prefix}${management_subnet}
#  Thus to change the VNET addressing you only need to update the relevent _vnet_prefix variable.

variable "management_vnet_prefix" {
  description = "The private prefix used for the management virtual network"
  default     = "10.255."
}

variable "management_subnet" {
  description = "The private network that terminates all FW and Panorama IP addresses."
  default     = "0.0/24"
}

variable "firewall_vnet_prefix" {
  description = "The private prefix used for all firewall networks"
  default     = "10.110."
}

variable "vm_management_subnet" {
  description = "The subnet used for the management NICs on the vm-series"
  default     = "255.0/24"
}

variable "public_subnet" {
  description = "The private network that is the external or public side of the VM series firewalls (eth1/1)"
  default     = "129.0/24"
}

variable "private_subnet" {
  description = "The private network behind or on the internal side of the VM series firewalls (eth1/2)"
  default     = "0.0/24"
}

#----------------------#
#      VM Options      #
#----------------------#

variable "vm_series_sku" {
  description = "VM-series SKU - list available with az vm image list --publisher paloaltonetworks --all"
  default     = "byol"
}

variable "vm_series_version" {
  description = "VM-series Software version"
  default     = "9.1.3"
}
