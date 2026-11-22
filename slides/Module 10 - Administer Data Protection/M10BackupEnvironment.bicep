/*
Module 10 backup demo. Policies and enrollment are left for the live demo.
The adjacent M10BackupResources.bicep module deploys resources into the new RG.

Deploy at subscription scope using Azure PowerShell:
  $password = Read-Host 'VM administrator password' -AsSecureString
  New-AzSubscriptionDeployment -Name M10BackupEnvironment -Location westeurope `
    -TemplateFile '.\M10BackupEnvironment.bicep' -adminPassword $password `
    -adminSourceAddressPrefix '<approved-private-client-CIDR>'
Use Test-AzSubscriptionDeployment first, or -WhatIf on the deployment command.
Supply -tags @{ ... } if your subscription requires additional resource tags.

Check inherited Azure Policy, provider registration, storage-name availability,
region/image/size restrictions, and quota before deploying. Azure Files backup
requires shared-key access; a policy denying it must be resolved, not bypassed.
Storage and vault public access are disabled. The trusted Azure services storage
exception is for backup integration, not general client access.

No public IPs, NAT, Bastion, or corporate connectivity are created. Connect M10
to your existing private network and approved outbound HTTPS path; configure
routes/peering and corporate DNS forwarding before RDP or Run Command. Default
outbound access is disabled. 10.20.0.0/16 overlaps the Module 6 demo VNet; those
overlapping networks cannot be directly peered.

On VmBackup, resolve az104backupgadi.file.core.windows.net to a private IP and
test TCP 445 before mounting \\az104backupgadi.file.core.windows.net\az104backlup
with authorized credentials. Storage/share names must be lowercase. Use your
local portal for backup management; confirm endpoint approval before enrollment.
The vault endpoint serves supported VM/agent scenarios, not Azure Files backup.
Choose Vault-Standard for Azure Files; vaulted restore is full-share, not
file-level. Prepare sample data and a completed backup before the live demo.

Stop protection and delete backup data before cleanup; soft delete can delay
vault deletion. Retain private endpoints/DNS until backup cleanup is complete.
*/

targetScope = 'subscription'

@description('Azure region. The resource module configures vault DNS for West Europe.')
@allowed([
  'westeurope'
])
param location string = 'westeurope'

@description('VM administrator username.')
param adminUsername string = 'azureadmin'

@secure()
@minLength(12)
@maxLength(123)
@description('Windows administrator password, supplied securely at deployment time.')
param adminPassword string

@description('Policy-approved Windows VM size.')
param vmSize string = 'Standard_B2s'

@description('Private client CIDR permitted to use RDP through existing corporate connectivity. Never use a public CIDR or *.')
param adminSourceAddressPrefix string

@minLength(3)
@maxLength(24)
@description('Globally unique storage account name: lowercase letters and numbers only.')
param storageAccountName string = 'az104backupgadi'

@description('Additional policy-required tags.')
param tags object = {}

var resourceTags = union(
  {
    Course: 'AZ-104'
    Module: '10'
    Purpose: 'BackupDemo'
  },
  tags
)

resource backupResourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'AZ104-M10-Backup'
  location: location
  tags: resourceTags
}

module environment 'M10BackupResources.bicep' = {
  name: 'M10BackupEnvironment-resources'
  scope: backupResourceGroup
  params: {
    location: location
    adminUsername: adminUsername
    adminPassword: adminPassword
    vmSize: vmSize
    adminSourceAddressPrefix: adminSourceAddressPrefix
    storageAccountName: storageAccountName
    tags: resourceTags
  }
}

output resourceGroupId string = backupResourceGroup.id
output virtualNetworkId string = environment.outputs.virtualNetworkId
output virtualMachineId string = environment.outputs.virtualMachineId
output virtualMachinePrivateIp string = environment.outputs.virtualMachinePrivateIp
output storageAccountId string = environment.outputs.storageAccountId
output fileShareUncPath string = environment.outputs.fileShareUncPath
output recoveryServicesVaultId string = environment.outputs.recoveryServicesVaultId
