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
  default     = "pantf"
}

#------------------------#
#   Panorama Variables   #
#------------------------#

variable "panorama_size" {
  description = "Virtual Machine size."
  default     = "Standard_D5_v2"
}

variable "panorama_version" {
  default     = "9.1.2"
  description = "PAN-OS Software version. List published images with `az vm image list --publisher paloaltonetworks --offer panorama --all`"
}

variable "username" {
  description = "Panorama Username."
  default     = "panadmin"
}

#----------------------#
#      Networking      #
#----------------------#
variable "management_ips" {
  description = "A map where the keys are the IP addresses or ranges that are permitted to access the out-of-band management interfaces belonging to firewalls and Panorama devices. The map's values are priorities, integers in the range 102-60000 inclusive. All priorities should be unique."
  type        = map(number)
}


# SCHRODERS ADDITIONS
variable subscription_id {}
variable tenant_id {}
