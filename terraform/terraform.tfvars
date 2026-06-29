resource_group_name = "rg-soc-lab-prod"
location             = "eastus"
environment          = "prod"

vnet_name              = "soc-monitoring-vnet"
vnet_address_space     = "10.0.0.0/16"
subnet_name            = "soc-monitoring-subnet"
subnet_address_prefix  = "10.0.1.0/24"

linux_vm_name   = "linux-soc-vm"
windows_vm_name = "windows-soc-vm"
vm_size         = "Standard_B2s"

admin_username = "*******"
admin_password = "***********"

law_name      = "law-soc-monitoring"
law_sku       = "PerGB2018"
retention_days = 30

tags = {
  Environment = "Production"
  Project     = "SOC-Lab"
  Owner       = "SecurityTeam"
  Purpose     = "IntrustionDetection"
  CostCenter  = "Security"
}
