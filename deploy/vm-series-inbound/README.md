# Palo Alto Networks VM-Series Firewalls

## Description

This module creates VM-Series firewalls and corresponding Load Balancers.

This module consumes pre-existing subnets and public IP addresses.

## Usage

Inside directory `bootstrap_files`:

1. The file `authcodes` is not committed to git, so that a random person couldn't mistakenly run their VM-series firewall on your licensing account. Add a single authcode there as an only line.

2. The file `init-cfg.txt` contains credentials to Panorama, update these manually. Example contents:

    ``` ini
    type=dhcp-client
    op-command-modes=mgmt-interface-swap
    vm-auth-key=<vmauthkey>
    panorama-server=<panorama-ip>
    tplname=<panorama-template-stack>
    dgname=<panorama-device-group>
    dhcp-send-hostname=yes
    dhcp-send-client-id=yes
    dhcp-accept-server-hostname=yes
    dhcp-accept-server-domain=yes
    ```

Having that:

```sh
terraform init
terraform apply
```
