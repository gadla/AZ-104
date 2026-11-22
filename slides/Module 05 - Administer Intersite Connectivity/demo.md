<div dir="rtl" align="right">

# <span dir="ltr">Demo: VNet peering, NVA, and UDRs</span>

<span dir="ltr">Peering is **not transitive**. This demo first shows isolated spokes, then connects them through a hub Linux NVA using UDRs.</span>

<div dir="ltr" align="right">

```text
VM1 (10.1.0.4) -- peering -- NVA (10.0.0.4) -- peering -- VM2 (10.2.0.4)
```

</div>


## <span dir="ltr">1. Deploy (instructor and participants)</span>

<span dir="ltr">**Required:** Azure subscription with deployment permissions and VM quota, Azure PowerShell (`Az`), Bicep CLI on your PATH, and an SSH client. Resources incur charges.</span>

1. <span dir="ltr">Copy [main.bicep](./main.bicep) and [deploy.ps1](./deploy.ps1) into one folder. Open local PowerShell there.</span>
2. <span dir="ltr">Select your subscription and deploy:</span>

   <div dir="ltr" align="right">

   ```powershell
   Connect-AzAccount
   Get-AzSubscription | Select-Object Name, Id
   Set-AzContext -SubscriptionId "<your-subscription-id>"
   .\deploy.ps1
   ```

   </div>


3. <span dir="ltr">Enter a strong VM password; the username is `azureadmin`. The script uses `rg-az104-routing-demo` in `westeurope`: use a fresh lab resource group with no unrelated resources. Resolve deployment errors before proceeding.</span>
4. <span dir="ltr">**The script deallocates all three VMs.** In the portal, wait until `vm-nva`, `vm-1`, and `vm-2` show **Stopped (deallocated)**, then start each VM and wait for **Running**.</span>
5. <span dir="ltr">In **Network security groups > nsg-az104-demo > Inbound security rules > Allow-SSH-Inbound**, set **Source** to **IP Addresses**, enter your public IPv4 address with `/32`, and save. SSH otherwise allows any source.</span>
6. <span dir="ltr">In each VM's **Overview**, copy its public IP. Open a separate terminal for each VM and run `ssh azureadmin@<public-ip>`, using the deployment password. All VMs run Ubuntu; use **private IPs** for the tests below.</span>

## <span dir="ltr">2. Show peering without transit</span>

1. <span dir="ltr">Inside **the NVA**, run:</span>

   <div dir="ltr" align="right">

   ```bash
   sudo cloud-init status --wait
   sysctl net.ipv4.ip_forward
   ```

   </div>


   <span dir="ltr">Expect successful initialization and `net.ipv4.ip_forward = 1`.</span>

2. <span dir="ltr">In each VNet's portal **Peerings** page, confirm all four directional hub/spoke peerings are **Connected**, with forwarded traffic allowed. There is no direct spoke peering.</span>
3. <span dir="ltr">Inside **VM1**, run:</span>

   <div dir="ltr" align="right">

   ```bash
   ping -c 4 -W 2 10.0.0.4
   ping -c 4 -W 2 10.2.0.4
   ```

   </div>


   <span dir="ltr">**Expected:** NVA replies; VM2 does not. Peering alone does not provide transit.</span>

## <span dir="ltr">3. Connect the spokes through the NVA</span>

1. <span dir="ltr">In portal **Route tables**, inspect each table's **Routes**, then use **Subnets > Associate**:</span>

   | <span dir="ltr">Route table</span> | <span dir="ltr">Destination</span> | <span dir="ltr">VNet / subnet to associate</span> |
   |---:|---:|---:|
   | <span dir="ltr">`rt-vnet1-to-vnet2`</span> | <span dir="ltr">`10.2.0.0/16`</span> | <span dir="ltr">`vnet-1` / `subnet-1`</span> |
   | <span dir="ltr">`rt-vnet2-to-vnet1`</span> | <span dir="ltr">`10.1.0.0/16`</span> | <span dir="ltr">`vnet-2` / `subnet-2`</span> |

   <span dir="ltr">Both routes use **Virtual appliance**, next-hop IP **10.0.0.4**. Associate **both** tables for request and return traffic; leave the hub subnet unchanged.</span>

2. <span dir="ltr">Allow changes to propagate. On **VM1**, repeat `ping -c 4 -W 2 10.2.0.4`. On **VM2**, run `ping -c 4 -W 2 10.1.0.4`. **Both should receive replies.**</span>
3. <span dir="ltr">To verify the path, run on **the NVA**, then repeat a spoke ping:</span>

   <div dir="ltr" align="right">

   ```bash
   sudo tcpdump -ni any 'icmp and host 10.1.0.4 and host 10.2.0.4'
   ```

   </div>


   <span dir="ltr">Expect requests and replies. Stop with **Ctrl+C**. If missing, install with `sudo apt-get update && sudo apt-get install -y tcpdump`.</span>

## <span dir="ltr">4. Reset and cleanup</span>

- <span dir="ltr">**Reset:** dissociate both spoke subnets from their route tables; after propagation, spoke pings should fail again.</span>
- <span dir="ltr">**If tests fail:** check running VMs, SSH source IP, connected peerings, both UDR associations, NSG rules, and NVA forwarding. Spoke NIC **Effective routes** should show the other spoke's `/16` through `10.0.0.4`.</span>
- <span dir="ltr">**Redeployment warning:** it can remove manual route associations and restores unrestricted SSH.</span>
- <span dir="ltr">**Cleanup:** in local PowerShell, confirm the subscription and delete **only your dedicated lab resource group**, accepting the confirmation:</span>

  <div dir="ltr" align="right">

  ```powershell
  Get-AzContext
  Remove-AzResourceGroup -Name "rg-az104-routing-demo"
  ```

  </div>


  <span dir="ltr">To retain the lab, stop each VM through the portal and verify **Stopped (deallocated)**. Disks and public IPs still incur charges.</span>

</div>
