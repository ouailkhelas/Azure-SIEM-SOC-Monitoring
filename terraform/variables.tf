variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-soc-lab"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "vnet_name" {
  description = "Name of Virtual Network"
  type        = string
  default     = "soc-vnet"
}

variable "vnet_address_space" {
  description = "Address space for VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "Name of Subnet"
  type        = string
  default     = "soc-subnet"
}

variable "subnet_address_prefix" {
  description = "Address prefix for Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "linux_vm_name" {
  description = "Name of Linux VM"
  type        = string
  default     = "linux-vm-soc"
}

variable "windows_vm_name" {
  description = "Name of Windows VM"
  type        = string
  default     = "windows-vm-soc"
}

variable "vm_size" {
  description = "VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
  default     = "P@ssw0rd1234!Azure"
}

variable "law_name" {
  description = "Name of Log Analytics Workspace"
  type        = string
  default     = "law-soc-workspace"
}

variable "law_sku" {
  description = "SKU of Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "retention_days" {
  description = "Retention days for logs"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "SOC-Lab"
    Owner       = "SecurityTeam"
    Purpose     = "IntrustionDetection"
  }
}
