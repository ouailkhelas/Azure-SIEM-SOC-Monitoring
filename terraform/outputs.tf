output "resource_group_id" {
  description = "ID of resource group"
  value       = azurerm_resource_group.rg.id
}

output "linux_vm_id" {
  description = "ID of Linux VM"
  value       = azurerm_linux_virtual_machine.linux_vm.id
}

output "linux_vm_public_ip" {
  description = "Public IP of Linux VM"
  value       = azurerm_public_ip.linux_pip.ip_address
}

output "windows_vm_id" {
  description = "ID of Windows VM"
  value       = azurerm_windows_virtual_machine.windows_vm.id
}

output "windows_vm_public_ip" {
  description = "Public IP of Windows VM"
  value       = azurerm_public_ip.windows_pip.ip_address
}

output "log_analytics_workspace_id" {
  description = "ID of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_name" {
  description = "Name of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.law.name
}

output "vnet_id" {
  description = "ID of Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "ID of Subnet"
  value       = azurerm_subnet.subnet.id
}
