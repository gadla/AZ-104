@description('Azure region for all resources')
param location string = 'westeurope'

@description('Admin username for the Ubuntu VMs')
param adminUsername string = 'azureadmin'

@secure()
@description('Admin password for the Ubuntu VMs')
param adminPassword string

@description('VM size')
param vmSize string = 'Standard_B2s'

// 1. Virtual Networks
resource vnetNm1 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-nm1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-nm1'
        properties: {
          addressPrefix: '10.10.1.0/24'
          networkSecurityGroup: {
            id: nsgNm1.id
          }
        }
      }
    ]
  }
}

resource vnetNm2 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-nm2'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-nm2'
        properties: {
          addressPrefix: '10.20.1.0/24'
          networkSecurityGroup: {
            id: nsgNm2.id
          }
        }
      }
    ]
  }
}

// 2. Network Security Groups (attached to Subnets so IP Flow Verify & Effective Rules are super clear)
resource nsgNm1 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-nm1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-VNet-SSH-Inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nsgNm2 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-nm2'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-VNet-SSH-Inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: 'VirtualNetwork'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// 3. Bidirectional VNet Peering
resource peering1to2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: vnetNm1
  name: 'peer-nm1-to-nm2'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    remoteVirtualNetwork: {
      id: vnetNm2.id
    }
  }
}

resource peering2to1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: vnetNm2
  name: 'peer-nm2-to-nm1'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    remoteVirtualNetwork: {
      id: vnetNm1.id
    }
  }
}

// 4. Network Interfaces (Private IP only - no Public IP)
resource nicNm1 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vmnm1'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.10.1.10'
          subnet: {
            id: vnetNm1.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

resource nicNm2 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vmnm2'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.20.1.10'
          subnet: {
            id: vnetNm2.properties.subnets[0].id
          }
        }
      }
    ]
  }
}

// 5. Ubuntu Virtual Machines
resource vmNm1 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vmnm1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'vmnm1'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicNm1.id
        }
      ]
    }
  }
}

resource vmNm2 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vmnm2'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: 'vmnm2'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicNm2.id
        }
      ]
    }
  }
}

// 6. Pre-install Network Watcher Agent Extension on both VMs
resource nwExtNm1 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  parent: vmNm1
  name: 'NetworkWatcherAgentLinux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
  }
}

resource nwExtNm2 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  parent: vmNm2
  name: 'NetworkWatcherAgentLinux'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
  }
}

output vmNm1PrivateIp string = nicNm1.properties.ipConfigurations[0].properties.privateIPAddress
output vmNm2PrivateIp string = nicNm2.properties.ipConfigurations[0].properties.privateIPAddress
