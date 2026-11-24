param location string = resourceGroup().location
param vmSize string = 'Standard_B2s'
param createNetworkWatcher bool = false

@secure()
param adminPassword string

resource watcher 'Microsoft.Network/networkWatchers@2023-11-01' = if (createNetworkWatcher) {
  name: 'nw-demo'
  location: location
}

module network '01-vnet-peering.bicep' = {
  name: 'watcher-network'
  params: {
    location: location
    vmSize: vmSize
    adminPassword: adminPassword
    createPeering: true
  }
  dependsOn: [
    watcher
  ]
}

resource vmA 'Microsoft.Compute/virtualMachines@2024-03-01' existing = {
  name: 'vm-a'
}

resource vmB 'Microsoft.Compute/virtualMachines@2024-03-01' existing = {
  name: 'vm-b'
}

resource agentA 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  parent: vmA
  name: 'AzureNetworkWatcherExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
  dependsOn: [
    network
  ]
}

resource agentB 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = {
  parent: vmB
  name: 'AzureNetworkWatcherExtension'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
    enableAutomaticUpgrade: true
  }
  dependsOn: [
    network
  ]
}

output vmAId string = network.outputs.vmAId
output vmBId string = network.outputs.vmBId
