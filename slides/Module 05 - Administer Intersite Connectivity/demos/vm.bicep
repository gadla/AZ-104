param location string = resourceGroup().location
param vmName string
param subnetId string
param privateIp string
param enableIPForwarding bool = false
param vmSize string = 'Standard_B2s'
param adminUsername string = 'azureadmin'

@allowed([
  'Windows'
  'Linux'
])
param osType string = 'Windows'

@secure()
param adminPassword string

// Explicit outbound connectivity is required by Run Command and VM extensions.
resource publicIp 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: 'pip-${vmName}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: 'nic-${vmName}'
  location: location
  properties: {
    enableIPForwarding: enableIPForwarding
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: privateIp
          subnet: {
            id: subnetId
          }
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
  }
}

resource vm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: osType == 'Windows'
        ? {
            provisionVMAgent: true
            enableAutomaticUpdates: true
          }
        : null
      linuxConfiguration: osType == 'Linux'
        ? {
            disablePasswordAuthentication: false
            provisionVMAgent: true
          }
        : null
    }
    storageProfile: {
      imageReference: osType == 'Windows'
        ? {
            publisher: 'MicrosoftWindowsServer'
            offer: 'WindowsServer'
            sku: '2022-datacenter-g2'
            version: 'latest'
          }
        : {
            publisher: 'Canonical'
            offer: '0001-com-ubuntu-server-jammy'
            sku: '22_04-lts-gen2'
            version: 'latest'
          }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}

// Disposable lab only. The subnet NSG still blocks inbound Internet traffic.
resource disableFirewall 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = if (osType == 'Windows') {
  parent: vm
  name: 'disable-demo-firewall'
  location: location
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.10'
    autoUpgradeMinorVersion: true
    settings: {
      commandToExecute: 'powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False -ErrorAction Stop"'
    }
  }
}

output vmId string = vm.id
