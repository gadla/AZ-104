param location string = resourceGroup().location
@description('Size of the Windows spoke VMs. The Linux NVA uses Standard_B1s.')
param vmSize string = 'Standard_B2s'

@secure()
param adminPassword string

module nsg 'nsg.bicep' = {
  name: 'lab-nsg'
  params: {
    location: location
  }
}

var networks = [
  {
    name: 'hub'
    prefix: '10.0.0.0/16'
    subnet: '10.0.0.0/24'
    vmName: 'vm-nva'
    vmIp: '10.0.0.4'
  }
  {
    name: 'a'
    prefix: '10.1.0.0/16'
    subnet: '10.1.0.0/24'
    vmName: 'vm-a'
    vmIp: '10.1.0.4'
  }
  {
    name: 'b'
    prefix: '10.2.0.0/16'
    subnet: '10.2.0.0/24'
    vmName: 'vm-b'
    vmIp: '10.2.0.4'
  }
]

resource vnets 'Microsoft.Network/virtualNetworks@2023-11-01' = [
  for network in networks: {
    name: 'vnet-${network.name}'
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: [
          network.prefix
        ]
      }
      subnets: [
        {
          name: 'snet-demo'
          properties: {
            addressPrefix: network.subnet
            defaultOutboundAccess: false
            networkSecurityGroup: {
              id: nsg.outputs.id
            }
          }
        }
      ]
    }
  }
]

module vms 'vm.bicep' = [
  for (network, i) in networks: {
    name: network.vmName
    params: {
      location: location
      vmName: network.vmName
      subnetId: vnets[i].properties.subnets[0].id
      privateIp: network.vmIp
      enableIPForwarding: i == 0
      osType: i == 0 ? 'Linux' : 'Windows'
      vmSize: i == 0 ? 'Standard_B1s' : vmSize
      adminPassword: adminPassword
    }
  }
]

@batchSize(1)
resource hubToSpokes 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = [
  for i in range(1, 2): {
    parent: vnets[0]
    name: 'hub-to-${networks[i].name}'
    properties: {
      remoteVirtualNetwork: {
        id: vnets[i].id
      }
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: true
    }
  }
]

resource spokesToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = [
  for i in range(1, 2): {
    parent: vnets[i]
    name: '${networks[i].name}-to-hub'
    properties: {
      remoteVirtualNetwork: {
        id: vnets[0].id
      }
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: true
    }
  }
]

resource routeTables 'Microsoft.Network/routeTables@2023-11-01' = [
  for name in ['a', 'b']: {
    name: 'rt-${name}'
    location: location
    properties: {
      routes: []
    }
  }
]

output nvaPrivateIp string = networks[0].vmIp
