@description('Deploy this module through M10BackupEnvironment.bicep.')
param location string

param adminUsername string

@secure()
param adminPassword string

param vmSize string

param adminSourceAddressPrefix string

param storageAccountName string

param tags object

var vmPrivateIp = '10.20.0.10'
var shareName = 'az104backlup'
var storageDnsSuffix = environment().suffixes.storage
var dnsZoneNames = [
  'privatelink.file.${storageDnsSuffix}'
  'privatelink.we.backup.windowsazure.com'
  'privatelink.blob.${storageDnsSuffix}'
  'privatelink.queue.${storageDnsSuffix}'
]

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-vmbackup'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-Private-RDP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: adminSourceAddressPrefix
          destinationAddressPrefix: vmPrivateIp
        }
      }
      {
        name: 'Deny-Other-RDP'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Deny'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'M10'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  parent: vnet
  name: 'snet-backup'
  properties: {
    addressPrefix: '10.20.0.0/24'
    defaultOutboundAccess: false
    privateEndpointNetworkPolicies: 'Disabled'
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vmbackup'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: vmPrivateIp
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'VmBackup'
  location: location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'VmBackup'
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: 'disk-vmbackup-os'
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        deleteOption: 'Delete'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            primary: true
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    // Required by Azure Files backup; private networking still restricts client access.
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      defaultAction: 'Deny'
      bypass: 'AzureServices'
    }
  }
}

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: storage
  name: 'default'
  properties: {
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 14
    }
  }
}

resource fileShare 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-05-01' = {
  parent: fileService
  name: shareName
  properties: {
    enabledProtocols: 'SMB'
    accessTier: 'TransactionOptimized'
    shareQuota: 100
  }
}

resource vault 'Microsoft.RecoveryServices/vaults@2024-04-01' = {
  name: 'rsv-m10-backup'
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'Standard'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    redundancySettings: {
      standardTierStorageRedundancy: 'LocallyRedundant'
      crossRegionRestore: 'Disabled'
    }
    securitySettings: {
      softDeleteSettings: {
        softDeleteState: 'Enabled'
        softDeleteRetentionPeriodInDays: 14
      }
    }
  }
}

resource dnsZones 'Microsoft.Network/privateDnsZones@2020-06-01' = [
  for zoneName in dnsZoneNames: {
    name: zoneName
    location: 'global'
    tags: tags
    properties: {}
  }
]

resource dnsLinks 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = [
  for (zoneName, i) in dnsZoneNames: {
    parent: dnsZones[i]
    name: 'M10-link'
    location: 'global'
    tags: tags
    properties: {
      registrationEnabled: false
      virtualNetwork: {
        id: vnet.id
      }
    }
  }
]

resource filesEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: 'pe-m10-files'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'files'
        properties: {
          privateLinkServiceId: storage.id
          groupIds: [
            'file'
          ]
        }
      }
    ]
  }
}

resource filesDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: filesEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'files'
        properties: {
          privateDnsZoneId: dnsZones[0].id
        }
      }
    ]
  }
}

resource vaultEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: 'pe-m10-vault'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnet.id
    }
    privateLinkServiceConnections: [
      {
        name: 'backup'
        properties: {
          privateLinkServiceId: vault.id
          groupIds: [
            'AzureBackup'
          ]
        }
      }
    ]
  }
}

resource vaultDnsGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: vaultEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      for i in range(1, length(dnsZoneNames) - 1): {
        name: 'backup-zone-${i}'
        properties: {
          privateDnsZoneId: dnsZones[i].id
        }
      }
    ]
  }
}

output virtualNetworkId string = vnet.id
output virtualMachineId string = vm.id
output virtualMachinePrivateIp string = vmPrivateIp
output storageAccountId string = storage.id
output fileShareUncPath string = '\\\\${storage.name}.file.${storageDnsSuffix}\\${fileShare.name}'
output recoveryServicesVaultId string = vault.id
