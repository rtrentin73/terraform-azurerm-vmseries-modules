# Palo Alto Networks Terraform Modules for Azure

## Directories

- `deploy/goldenimage` - temporarily deploy the VM-Series just as a bed for creating a custom cloud image; simplified setup which is not intended to handle traffic.
- `deploy/lab_infra` - for the lab only, simulate the resources already existing on the Production environment
- `deploy/vm-series-inbound` - deploy the VM-Series that handle traffic from the Internet towards trusted networks
- `deploy/vm-series-outbound` - deploy the VM-Series that handle traffic from the trusted networks towards the Internetz
- `examples` - various illustrative examples on using `modules`
- `modules` - the basic reusable building blocks
