# Priority map of security rules for your management IP addresses.
# Each key is the public IP, and the number is the priority it gets in the relevant network security groups (NSGs).
management_ips = {
  "199.199.199.199" : 100,
}
location    = "uksouth"
name_prefix = "palo-goldenimage-"
