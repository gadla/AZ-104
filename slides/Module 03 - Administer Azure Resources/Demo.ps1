<#
    Demo.ps1

    AZ 104 Classroom Demo

    Demonstrates deploying Azure Storage Accounts using:

    1. ARM JSON with Azure PowerShell
    2. Bicep with Azure PowerShell
    3. ARM JSON with Azure CLI
    4. Bicep with Azure CLI

    Prerequisites:
    Azure PowerShell
    Azure CLI
    Existing Resource Group: rg-az104-demo
    storage.json and storage.bicep in the current directory

    Note:
    Azure CLI requires its own authenticated session.
    Run 'az login' separately if needed.
#>


# ==========================================
# 1. Connect to Azure
# ==========================================

Connect-AzAccount -UseDeviceAuthentication


# ==========================================
# 2. ARM JSON using Azure PowerShell
# ==========================================


# Create the Resource Group only if it does not exist
if (-not (Get-AzResourceGroup -Name "rg-az104-demo" -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup `
        -Name "rg-az104-demo" `
        -Location "israelcentral"
}

# Deploy the storage account using the ARM JSON template
New-AzResourceGroupDeployment `
    -ResourceGroupName "rg-az104-demo" `
    -TemplateFile ".\storage.json" `
    -storageAccountName "az104demops12345"

# Delete the storage account that was just created and recreate it with Bicep
Remove-AzStorageAccount `
    -ResourceGroupName "rg-az104-demo" `
    -Name "az104demops12345" `
    -Force

# ==========================================
# 3. Bicep using Azure PowerShell
# ==========================================

# Create the Resource Group only if it does not exist
if (-not (Get-AzResourceGroup -Name "rg-az104-demo" -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup `
        -Name "rg-az104-demo" `
        -Location "israelcentral"
}

# Deploy the storage account using the Bicep template
New-AzResourceGroupDeployment `
    -ResourceGroupName "rg-az104-demo" `
    -TemplateFile ".\storage.bicep" `
    -storageAccountName "az104demobicepps12345"


# ==========================================
# 4. ARM JSON using Azure CLI
# ==========================================

az deployment group create `
    --resource-group "rg-az104-demo" `
    --template-file ".\storage.json" `
    --parameters storageAccountName=az104demojson12345


# ==========================================
# 5. Bicep using Azure CLI
# ==========================================

az deployment group create `
    --resource-group "rg-az104-demo" `
    --template-file ".\storage.bicep" `
    --parameters storageAccountName=az104demobicep12345