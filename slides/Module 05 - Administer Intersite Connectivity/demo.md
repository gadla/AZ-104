<div dir="ltr" align="left">
<div dir="ltr" align="left">

# Module 05 — Instructor demos

## Prepare once

1. **Check prerequisites.** Use your connected lab session. Confirm `Az`, Bicep CLI, VM quota, and the budget for the demo resources.
2. **Use the new templates.** Keep the `demos` folder intact; do not run the original `deploy.ps1`.
3. **Prepare the session.** Set the folder, check the active subscription, and prepare the region, unique suffix, and VM password:

   ```powershell
   Set-Location "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity"
   $ErrorActionPreference = "Stop"
   Get-AzContext | Select-Object Tenant, Subscription
   $location = "westeurope"
   $run = [guid]::NewGuid().ToString("N")
   $password = Read-Host "Strong VM password" -AsSecureString
   ```

4. **Avoid touching other resources.** Confirm the tenant and subscription. Run one demo at a time, then delete its entire group.
5. **Wait for configuration to finish.** Continue only after deployment shows **Succeeded**, VMs show **Running**, and **Extensions + applications > disable-demo-firewall** shows **Provisioning succeeded** on each Windows VM.
6. **Keep Internet access blocked.** Test private IPs through Run Command; do not open SSH or RDP. Windows Server 2022 spokes use `Standard_B2s`; the Ubuntu NVA uses `Standard_B1s`. Add `-vmSize "<APPROVED-WINDOWS-SIZE>"` to change the Windows size if needed.
7. **Verify the automatic firewall change.** All Windows Firewall profiles are disabled for this disposable lab; NSGs remain enabled. On a Windows VM, open **Run command > RunPowerShellScript**:

   ```powershell
   Get-NetFirewallProfile | Format-Table Name, Enabled
   ```

8. **Confirm readiness.** All three profiles must show `False`. When replacing a Linux demo, use its cleanup command and wait until the entire group is deleted before recreating it; the VM OS cannot be changed in place.

## 1. VNet peering — slides 6–10

1. **Create an isolated peering lab.** Deploy two unconnected VNets and Windows VMs:

   ```powershell
   $rg1 = "rg-m05-peering"
   New-AzResourceGroup -Name $rg1 -Location $location -Tag @{ DemoOwner = "AZ104-M05" }
   New-AzResourceGroupDeployment -ResourceGroupName $rg1 `
       -TemplateFile "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity\demos\01-vnet-peering.bicep" `
       -adminPassword $password
   ```

2. **Test without peering.** On **vm-a > Run command > RunPowerShellScript**, ping `vm-b`:

   ```powershell
   ping.exe -n 4 -w 2000 10.20.1.4
   ```

3. **Confirm isolation.** The ping should fail because the networks are not connected.
4. **Connect both networks.** Open **vnet-a > Peerings > Add**. Select `vnet-b`, local link `a-to-b`, remote link `b-to-a`. Enable virtual network access in both directions; leave forwarded traffic and gateway options disabled. Select **Add**.
5. **Check both links.** Open **Peerings** on each VNet and confirm **Connected**.
6. **Verify connectivity.** Repeat the ping on **vm-a**; expect replies.
7. **Inspect the new path.** Open **nic-vm-a > Effective routes** and find the peering route to `10.20.0.0/16`.
8. **Remove all demo resources.** Check the subscription and resource list, then delete only this lab group:

   ```powershell
   Get-AzContext | Select-Object Tenant, Subscription
   Get-AzResource -ResourceGroupName $rg1 | Select-Object Name, ResourceType
   Remove-AzResourceGroup -Name $rg1
   ```

9. **Confirm cleanup.** Accept the prompt and wait until the group disappears from the portal.

## 2. Route tables and NVA routing — slides 9, 14–16

1. **Build the hub-and-spoke lab.** Deploy a Linux NVA, two Windows spokes, hub/spoke peerings, and two empty route tables:

   ```powershell
   $rg2 = "rg-m05-routing-RT-NVA"
   New-AzResourceGroup -Name $rg2 -Location $location -Tag @{ DemoOwner = "AZ104-M05" }
   New-AzResourceGroupDeployment -ResourceGroupName $rg2 `
       -TemplateFile "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity\demos\02-nva-routing.bicep" `
       -adminPassword $password
   ```

2. **Turn the NVA into a router.** Open **vm-nva > Run command > RunShellScript**:

   This command enables Linux IPv4 packet forwarding. It resets after reboot; NIC forwarding and both UDRs are also required.

   ```bash
   sysctl -w net.ipv4.ip_forward=1
   ```

3. **Check both forwarding settings.** Confirm `net.ipv4.ip_forward = 1` and **nic-vm-nva > IP configurations > IP forwarding: Enabled**.
4. **Compare hub and spoke access.** On **vm-a > Run command > RunPowerShellScript**, ping the NVA, then the other spoke separately:

   ```powershell
   # Ping the hub NVA. Expect replies because vm-a is peered with the hub.
   ping.exe -n 4 -w 2000 10.0.0.4
   ```

   ```powershell
   # Ping vm-b before adding UDRs. Expect no target replies: peering is not transitive.
   ping.exe -n 4 -w 2000 10.2.0.4
   ```

   Check the ping output, not just Run Command status. Continue only when the NVA replies.

5. **Send requests and replies through the NVA.** Open each route table > **Routes > Add**:

   | Table | Route name | Destination | Next hop type | Next hop IP |
   |:---|:---|:---|:---|:---|
   | `rt-a` | `to-b` | `10.2.0.0/16` | Virtual appliance | `10.0.0.4` |
   | `rt-b` | `to-a` | `10.1.0.0/16` | Virtual appliance | `10.0.0.4` |

6. **Apply the routes to both spokes.** Under **Subnets > Associate**, connect `rt-a` to `vnet-a / snet-demo` and `rt-b` to `vnet-b / snet-demo`. Leave the hub subnet unchanged.
7. **Verify the request and return paths.** Wait for propagation. On **vm-a > Run command > RunPowerShellScript**:

   ```powershell
   # Ping vm-b through the NVA after associating both route tables. Expect replies.
   ping.exe -n 4 -w 2000 10.2.0.4
   ```

   On **vm-b > Run command > RunPowerShellScript**:

   ```powershell
   # Ping vm-a through the NVA to verify connectivity in the reverse direction. Expect replies.
   ping.exe -n 4 -w 2000 10.1.0.4
   ```

8. **Inspect the active UDRs.** On **nic-vm-a > Effective routes**, confirm `10.2.0.0/16`, source **User**, next hop `10.0.0.4`. Check the return route on **nic-vm-b**.
9. **Remove the entire routing lab.** Check the subscription and resource list, then delete only this group:

   ```powershell
   Get-AzContext | Select-Object Tenant, Subscription
   Get-AzResource -ResourceGroupName $rg2 | Select-Object Name, ResourceType
   Remove-AzResourceGroup -Name $rg2
   ```

10. **Confirm cleanup.** Accept the prompt and wait for deletion. Do not redeploy during the demo; it can reset manual routes and associations.

## 3. Service endpoint — slide 17

1. **Restrict Storage access to one subnet.** Deploy a VNet, Storage service endpoint, and empty Storage account. The outputs identify the account and Blob endpoint:

   ```powershell
   $rg3 = "rg-m05-service-$run"
   New-AzResourceGroup -Name $rg3 -Location $location -Tag @{ DemoOwner = "AZ104-M05" }
   $deployment3 = New-AzResourceGroupDeployment -ResourceGroupName $rg3 `
       -TemplateFile "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity\demos\03-service-endpoint.bicep"
   $deployment3.Outputs
   ```

2. **Check the subnet endpoint.** Open **vnet-service > Subnets > snet-demo** and find **Service endpoints: Microsoft.Storage**.
3. **Check the service-side restriction.** Open **Storage > Networking**. Confirm **Public network access: Enabled from selected networks** and the allowed subnet `vnet-service / snet-demo`.
4. **Show that the service retains a public endpoint.** Open **Storage > Endpoints** and show the Blob address. Confirm there is no Private Endpoint connection.
5. **Keep the test configuration-only.** Do not upload data or display access keys; client access is not tested here.
6. **Remove the network and Storage account.** Check the subscription and resource list, then delete only this group:

   ```powershell
   Get-AzContext | Select-Object Tenant, Subscription
   Get-AzResource -ResourceGroupName $rg3 | Select-Object Name, ResourceType
   Remove-AzResourceGroup -Name $rg3
   ```

7. **Confirm cleanup.** Accept the prompt and wait for deletion.

## 4. Private Endpoint and DNS — slides 18–20

1. **Give Storage a private connection.** Deploy a VNet, empty Storage account, Blob Private Endpoint, DNS zone, and VNet link. The outputs identify the account and Blob endpoint:

   ```powershell
   $rg4 = "rg-m05-private-$run"
   New-AzResourceGroup -Name $rg4 -Location $location -Tag @{ DemoOwner = "AZ104-M05" }
   $deployment4 = New-AzResourceGroupDeployment -ResourceGroupName $rg4 `
       -TemplateFile "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity\demos\04-private-endpoint.bicep"
   $deployment4.Outputs
   ```

2. **Check that public access is blocked.** Open **Storage > Networking** and confirm **Public network access: Disabled**.
3. **Check connection approval.** Open **Private endpoint connections** and confirm **Approved**.
4. **Identify the private address.** Open **pe-blob > Network interface** and note the IP in `10.40.1.0/24`.
5. **Check the DNS mapping.** Open **Private DNS zones > privatelink.blob.core.windows.net > Recordsets**. Confirm the account's **A** record matches that IP.
6. **Check which network uses the zone.** Open **Virtual network links** and confirm `link-demo` links to `vnet-private`.
7. **Highlight the difference.** Compare with demo 3: Service Endpoint retains the service's public address; Private Endpoint has a private NIC/IP and DNS configuration. This does not test client DNS or data access.
8. **Remove the connection, Storage, and dedicated DNS zone.** Check the subscription and resource list, then delete only this group:

   ```powershell
   Get-AzContext | Select-Object Tenant, Subscription
   Get-AzResource -ResourceGroupName $rg4 | Select-Object Name, ResourceType
   Remove-AzResourceGroup -Name $rg4
   ```

9. **Confirm cleanup.** Accept the prompt and wait for deletion.

## 5. Network Watcher connectivity — slide 24

1. **Prepare a separate diagnostic lab.** Reuse the regional Network Watcher if one exists; otherwise create one. Deploy two peered Windows VMs and their agents in a new group:

   ```powershell
   $rg5 = "rg-m05-watcher-$run"
   $watchers = @(Get-AzNetworkWatcher | Where-Object Location -EQ $location)
   if ($watchers.Count -gt 1) { throw "Review the regional Network Watcher instances before continuing." }
   $createWatcher = $watchers.Count -eq 0
   New-AzResourceGroup -Name $rg5 -Location $location -Tag @{ DemoOwner = "AZ104-M05" }
   New-AzResourceGroupDeployment -ResourceGroupName $rg5 `
       -TemplateFile "C:\Repo\AZ-104\slides\Module 05 - Administer Intersite Connectivity\demos\05-network-watcher.bicep" `
       -adminPassword $password -createNetworkWatcher $createWatcher
   ```

2. **Check that diagnostics are ready.** On both VMs, open **Extensions + applications** and confirm **AzureNetworkWatcherExtension: Provisioning succeeded**.
3. **Test the peered connection.** Open **Network Watcher > Connection troubleshoot**. Select source **vm-a** in `$rg5`, destination IP `10.20.1.4`, protocol **ICMP**, and **Connectivity**. Run the test; expect **Reachable**.
4. **Verify with a VM-side ping.** Run this from your connected PowerShell session; Run Command executes it on `vm-a` without RDP:

   ```powershell
   Invoke-AzVMRunCommand -ResourceGroupName $rg5 -VMName "vm-a" `
       -CommandId "RunPowerShellScript" -ScriptString "ping.exe -n 4 -w 2000 10.20.1.4"
   ```

5. **Break the network connection.** After confirming ping replies, delete `a-to-b` and `b-to-a` from the VNets' **Peerings** pages.
6. **Compare the failed result.** Wait for propagation, then repeat both tests. Expect **Unreachable** and no ping replies.
7. **Preserve shared diagnostics.** `nw-demo`, if created, belongs to `$rg5`. Leave any pre-existing regional watcher and its group untouched.
8. **Remove this diagnostic lab.** Check the subscription and resource list, then delete its VMs, agents, networks, and any watcher created in the group:

   ```powershell
   Get-AzContext | Select-Object Tenant, Subscription
   Get-AzResource -ResourceGroupName $rg5 | Select-Object Name, ResourceType
   Remove-AzResourceGroup -Name $rg5
   ```

9. **Confirm cleanup without affecting other labs.** Accept the prompt and wait for deletion. Do not delete an automatically created or shared `NetworkWatcherRG`.

</div>
</div>
