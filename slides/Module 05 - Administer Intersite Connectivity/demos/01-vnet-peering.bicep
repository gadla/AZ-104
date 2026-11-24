param location string = resourceGroup().location
param vmSize string = 'Standard_B2s'
param createPeering bool = false

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
    name: 'a'
    prefix: '10.10.0.0/16'
    subnet: '10.10.1.0/24'
    vmIp: '10.10.1.4'
  }
  {
    name: 'b'
    prefix: '10.20.0.0/16'
    subnet: '10.20.1.0/24'
    vmIp: '10.20.1.4'
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
    name: 'vm-${network.name}'
    params: {
      location: location
      vmName: 'vm-${network.name}'
      subnetId: vnets[i].properties.subnets[0].id
      privateIp: network.vmIp
      vmSize: vmSize
      adminPassword: adminPassword
    }
  }
]

resource aToB 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = if (createPeering) {
  parent: vnets[0]
  name: 'a-to-b'
  properties: {
    remoteVirtualNetwork: {
      id: vnets[1].id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

resource bToA 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = if (createPeering) {
  parent: vnets[1]
  name: 'b-to-a'
  properties: {
    remoteVirtualNetwork: {
      id: vnets[0].id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output vmAId string = vms[0].outputs.vmId
output vmBId string = vms[1].outputs.vmId
