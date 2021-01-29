location    = "uksouth"
name_prefix = "sch1"

# Priority map of security rules for your management IP addresses.
# Each key is the public IP, and the number is the priority it gets in the relevant network security groups (NSGs).
management_ips = {
  "199.199.199.199" : 100,
}

instances = {
  "fw00" = {}
  "fw01" = {}
}

vm_series_vm_size = "Standard_D3_v2"

olb_private_ip = "10.110.0.21"

vmseries_subnet_mgmt    = null
vmseries_subnet_private = null
vmseries_subnet_public  = null

frontend_ips = {}
