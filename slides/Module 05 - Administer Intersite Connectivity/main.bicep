@description('Location for all resources')
param location string = resourceGroup().location

@description('Admin username for the VMs')
param adminUsername string = 'azureadmin'

@secure()
@description('Admin password for the VMs')
param adminPassword string

@description('Linux VM size for all three VMs')
param vmSize string = 'Standard_B1s'

var nvaPrivateIp = '10.0.0.4'

// 1. Network Security Group (internal traffic and SSH)
resource demoNsg 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: 'nsg-az104-demo'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-Internal-VNet-Traffic'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '10.0.0.0/8'
          destinationAddressPrefix: '10.0.0.0/8'
        }
      }
      {
        name: 'Allow-SSH-Inbound'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// 2. Virtual Networks (Hub, VNet1, VNet2)
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-hub'
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.0.0.0/16' ] }
    subnets: [
      {
        name: 'snet-hub'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: { id: demoNsg.id }
        }
      }
    ]
  }
}

resource vnet1 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-1'
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.1.0.0/16' ] }
    subnets: [
      {
        name: 'subnet-1'
        properties: {
          addressPrefix: '10.1.0.0/24'
          networkSecurityGroup: { id: demoNsg.id }
        }
      }
    ]
  }
}

resource vnet2 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: 'vnet-2'
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.2.0.0/16' ] }
    subnets: [
      {
        name: 'subnet-2'
        properties: {
          addressPrefix: '10.2.0.0/24'
          networkSecurityGroup: { id: demoNsg.id }
        }
      }
    ]
  }
}

// 3. VNet Peerings (bidirectional with forwarded traffic allowed)
resource peerHubToVnet1 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: hubVnet
  name: 'hub-to-vnet1'
  properties: {
    remoteVirtualNetwork: { id: vnet1.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource peerVnet1ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: vnet1
  name: 'vnet1-to-hub'
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource peerHubToVnet2 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: hubVnet
  name: 'hub-to-vnet2'
  properties: {
    remoteVirtualNetwork: { id: vnet2.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource peerVnet2ToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: vnet2
  name: 'vnet2-to-hub'
  properties: {
    remoteVirtualNetwork: { id: hubVnet.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

// 4. Public IPs for SSH to all three Linux VMs
resource pipNva 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'pip-vm-nva'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

resource pipVm1 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'pip-vm-1'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

resource pipVm2 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'pip-vm-2'
  location: location
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static' }
}

// 5. Network Interfaces (NVA uses static IP 10.0.0.4 with IP forwarding enabled)
resource nicNva 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vm-nva'
  location: location
  properties: {
    enableIPForwarding: true
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: nvaPrivateIp
          subnet: { id: hubVnet.properties.subnets[0].id }
          publicIPAddress: { id: pipNva.id }
        }
      }
    ]
  }
}

resource nicVm1 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vm-1'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.1.0.4'
          subnet: { id: vnet1.properties.subnets[0].id }
          publicIPAddress: { id: pipVm1.id }
        }
      }
    ]
  }
}

resource nicVm2 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-vm-2'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.2.0.4'
          subnet: { id: vnet2.properties.subnets[0].id }
          publicIPAddress: { id: pipVm2.id }
        }
      }
    ]
  }
}

// 6. Virtual Machines (Ubuntu 22.04 LTS)
var nvaCloudInit = '''#cloud-config
runcmd:
  - sysctl -w net.ipv4.ip_forward=1
  - echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
'''

resource vmNva 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-nva'
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: 'vm-nva'
      adminUsername: adminUsername
      adminPassword: adminPassword
      customData: base64(nvaCloudInit)
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Standard_LRS' }
      }
    }
    networkProfile: {
      networkInterfaces: [ { id: nicNva.id } ]
    }
  }
}

resource vm1 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-1'
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: 'vm-1'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Standard_LRS' }
      }
    }
    networkProfile: {
      networkInterfaces: [ { id: nicVm1.id } ]
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: 'vm-2'
  location: location
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: 'vm-2'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Standard_LRS' }
      }
    }
    networkProfile: {
      networkInterfaces: [ { id: nicVm2.id } ]
    }
  }
}

// 7. Route Tables (ready to associate with subnets during the live classroom demo)
resource rtVnet1 'Microsoft.Network/routeTables@2023-11-01' = {
  name: 'rt-vnet1-to-vnet2'
  location: location
  properties: {
    routes: [
      {
        name: 'route-to-vnet2-via-nva'
        properties: {
          addressPrefix: '10.2.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: nvaPrivateIp
        }
      }
    ]
  }
}

resource rtVnet2 'Microsoft.Network/routeTables@2023-11-01' = {
  name: 'rt-vnet2-to-vnet1'
  location: location
  properties: {
    routes: [
      {
        name: 'route-to-vnet1-via-nva'
        properties: {
          addressPrefix: '10.1.0.0/16'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: nvaPrivateIp
        }
      }
    ]
  }
}

output vm1PublicIp string = pipVm1.properties.ipAddress
output vm2PublicIp string = pipVm2.properties.ipAddress
