#!/bin/bash

set -e

echo "=========================================="
echo "Azure SOC & Intrusion Detection Lab"
echo "Deployment Script"
echo "=========================================="
echo ""

if [ ! -f "terraform/main.tf" ]; then
    echo "Error: terraform/main.tf not found!"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "Step 1: Initializing Terraform..."
cd terraform/
terraform init

echo ""
echo "Step 2: Planning Terraform deployment..."
terraform plan -out=tfplan

echo ""
echo "Step 3: Applying Terraform configuration..."
terraform apply tfplan

echo ""
echo "=========================================="
echo "Infrastructure Deployed Successfully!"
echo "=========================================="
echo ""

LINUX_IP=$(terraform output -raw linux_vm_public_ip)
WINDOWS_IP=$(terraform output -raw windows_vm_public_ip)
LAW_NAME=$(terraform output -raw log_analytics_workspace_name)

echo " Deployment Summary:"
echo "Linux VM Public IP: $LINUX_IP"
echo "Windows VM Public IP: $WINDOWS_IP"
echo "Log Analytics Workspace: $LAW_NAME"
echo ""
echo "Next Steps:"
echo "1. Wait 5-10 minutes for agents to connect"
echo "2. Go to Azure Portal → Log Analytics Workspace"
echo "3. Enable Microsoft Sentinel"
echo "4. Create Analytics Rules (see portal/sentinelconfig.md)"
echo "5. Run KQL queries (see queries.txt)"
echo ""
echo " SSH to Linux VM:"
echo "   ssh azureuser@$LINUX_IP"
echo ""
echo " RDP to Windows VM:"
echo "   Remote Desktop Connection to $WINDOWS_IP"
echo ""
