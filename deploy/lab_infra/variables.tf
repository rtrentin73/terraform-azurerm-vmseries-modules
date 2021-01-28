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
  type        = map(any)
  description = "A list of IP addresses and/or subnets that are permitted to access the out of band Management network."
}
