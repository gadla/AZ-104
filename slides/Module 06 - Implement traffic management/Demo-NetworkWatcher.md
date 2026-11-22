<div dir="rtl" align="right">

# <span dir="ltr">Network Watcher Demo Checklist (Step-by-Step)</span>

<span dir="ltr">Open [Azure Portal](https://portal.azure.com) > **Network Watcher**.</span>\
<span dir="ltr">Target Resource Group: **`network-monitor`** | Region: **`West Europe`** (or your deployed region).</span>

---

## <span dir="ltr">Step 0: Preparation</span>

1. <span dir="ltr">Verify that `vmnm1` and `vmnm2` are **Running**, both VNet peerings show **Connected**, and the `NetworkWatcherAgentLinux` extensions are provisioned.</span>
2. <span dir="ltr">Verify the static private IP addresses after deploying the updated template:</span>
   * <span dir="ltr">**VM1-IP (`vmnm1`):** `10.10.1.10`</span>
   * <span dir="ltr">**VM2-IP (`vmnm2`):** `10.20.1.10`</span>
3. <span dir="ltr">Use `vmnm1` as the source and `vmnm2` as the destination; test **TCP port 22 (SSH)**.</span>

---

## <span dir="ltr">Step 1: Topology</span>

1. <span dir="ltr">In the Azure portal search box, search for **monitoring**, select **Networking monitoring & management**, then open the **Monitoring** blade on the left and select **Topology**.</span>
2. <span dir="ltr">Set **Scope**:</span>
   * <span dir="ltr">**Subscription:** Your subscription</span>
   * <span dir="ltr">**Resource group:** `network-monitor`</span>
   * <span dir="ltr">**Location:** `West Europe`</span>
3. <span dir="ltr">Expand both VNets (`vnet-nm1` and `vnet-nm2`) and their resources.</span>
4. <span dir="ltr">Highlight the VMs, NICs, Subnets, NSGs (`nsg-nm1`, `nsg-nm2`), and the VNet peering link. *(Note: Topology visualizations can lag slightly behind recent changes).*</span>

---

## <span dir="ltr">Step 2: Baseline Diagnostics (Healthy State)</span>

<span dir="ltr">Run these three checks before introducing any fault to establish a working baseline:</span>

### <span dir="ltr">2.1 Next Hop (Routing Check)</span>
1. <span dir="ltr">Go to **Network diagnostic > Next hop**.</span>
2. <span dir="ltr">Select:</span>
   * <span dir="ltr">**Resource group:** `network-monitor`</span>
   * <span dir="ltr">**Virtual machine:** `vmnm1`</span>
   * <span dir="ltr">**Source IP address:** `VM1-IP`</span>
   * <span dir="ltr">**Destination IP address:** `VM2-IP`</span>
3. <span dir="ltr">Click **Next hop**.</span>
4. <span dir="ltr">**Expected result:** `Next hop type: VirtualNetworkPeering`.</span>

### <span dir="ltr">2.2 IP Flow Verify (NSG Simulation)</span>
1. <span dir="ltr">Go to **Network diagnostic tools > IP flow verify**.</span>
2. <span dir="ltr">Select **Virtual machine:** `vmnm1` | **Network interface:** `nic-vmnm1`.</span>
3. <span dir="ltr">Enter:</span>
   * <span dir="ltr">**Protocol:** `TCP`</span>
   * <span dir="ltr">**Direction:** `Outbound`</span>
   * <span dir="ltr">**Local IP address:** `VM1-IP` | **Local port:** `60000`</span>
   * <span dir="ltr">**Remote IP address:** `VM2-IP` | **Remote port:** `22`</span>
4. <span dir="ltr">Click **Check**.</span>
5. <span dir="ltr">**Expected result:** **Access: Allowed** (via default rule `AllowVnetOutBound`).</span>

### <span dir="ltr">2.3 Connection Troubleshoot (End-to-End Live Test)</span>
1. <span dir="ltr">Go to **Network diagnostic tools > Connection troubleshoot**.</span>
2. <span dir="ltr">Configure:</span>
   * <span dir="ltr">**Source:** `vmnm1`</span>
   * <span dir="ltr">**Destination:** `vmnm2` (or specify `VM2-IP`)</span>
   * <span dir="ltr">**Protocol:** `TCP` | **Destination port:** `22`</span>
   * <span dir="ltr">**Diagnostic tests:** Check **Connectivity**, **NSG diagnostic**, and **Next hop**; leave **Port scanner** unchecked.</span>
3. <span dir="ltr">Click **Run diagnostic tests**.</span>
4. <span dir="ltr">**Expected result:** **Reachable** (confirms live TCP connectivity, latency, and hop path without requiring an SSH login).</span>

---

## <span dir="ltr">Step 3: Break Connectivity, Diagnose, and Repair</span>

### <span dir="ltr">3.1 Introduce an Outbound NSG Block</span>
1. <span dir="ltr">In a separate tab, open **Resource group `network-monitor` > `nsg-nm1` > Settings > Outbound security rules > + Add**.</span>
2. <span dir="ltr">Configure the rule:</span>

   | <span dir="ltr">Setting</span> | <span dir="ltr">Value</span> |
   | ---: | ---: |
   | <span dir="ltr">**Source**</span> | <span dir="ltr">IP Addresses: `VM1-IP/32` (`10.10.1.10/32`)</span> |
   | <span dir="ltr">**Source port ranges**</span> | <span dir="ltr">`*`</span> |
   | <span dir="ltr">**Destination**</span> | <span dir="ltr">IP Addresses: `VM2-IP/32` (`10.20.1.10/32`)</span> |
   | <span dir="ltr">**Service / Destination port**</span> | <span dir="ltr">`SSH` (TCP port `22`)</span> |
   | <span dir="ltr">**Action**</span> | <span dir="ltr">**Deny**</span> |
   | <span dir="ltr">**Priority**</span> | <span dir="ltr">`200`</span> |
   | <span dir="ltr">**Name**</span> | <span dir="ltr">`Demo-Deny-SSH-To-VM2`</span> |

3. <span dir="ltr">Click **Add** and wait ~15–20 seconds for rule propagation.</span>

### <span dir="ltr">3.2 Diagnose the Failure</span>
1. <span dir="ltr">**Connection Troubleshoot:** Re-run the test from `vmnm1` to `vmnm2` on TCP `22` → **Expected:** **Unreachable**.</span>
2. <span dir="ltr">**Next Hop:** Re-run Next Hop to `VM2-IP` → **Expected:** Still `VirtualNetworkPeering` (proves routing is intact).</span>
3. <span dir="ltr">**IP Flow Verify:** Re-run the outbound check to `VM2-IP` port `22` → **Expected:** **Access: Denied**, explicitly naming **`Demo-Deny-SSH-To-VM2`** in **`nsg-nm1`**.</span>
4. <span dir="ltr">**Effective Security Rules:** Go to **Network diagnostic tools > Effective security rules**, select `vmnm1` / `nic-vmnm1`, and show how priority `200` (`Demo-Deny-SSH-To-VM2`) overrides the default `AllowVnetOutBound` rule at priority `65001`.</span>

### <span dir="ltr">3.3 Repair</span>
1. <span dir="ltr">Return to **`nsg-nm1` > Outbound security rules** and delete **`Demo-Deny-SSH-To-VM2`**.</span>
2. <span dir="ltr">Re-run **IP Flow Verify** or **Connection Troubleshoot** → **Expected:** **Allowed / Reachable**.</span>

---

## <span dir="ltr">Step 4: Packet Capture (Optional)</span>

1. <span dir="ltr">Go to **Network diagnostic tools > Packet capture > + Add**.</span>
2. <span dir="ltr">Configure:</span>
   * <span dir="ltr">**Resource group:** `network-monitor`</span>
   * <span dir="ltr">**Target virtual machine:** `vmnm1`</span>
   * <span dir="ltr">**Packet capture name:** `demo-vm1-ssh`</span>
   * <span dir="ltr">**Storage location:** Uncheck *Storage account*, check **File**, and enter `/var/captures/demo.cap`</span>
   * <span dir="ltr">**Time limit (seconds):** `180`</span>
3. <span dir="ltr">Under **Filtering**, click **+ Add filter**:</span>
   * <span dir="ltr">**Protocol:** `TCP` | **Remote IP address:** `VM2-IP` | **Remote port:** `22`</span>
4. <span dir="ltr">Click **OK** to start capturing.</span>
5. <span dir="ltr">In another tab, run a fresh **Connection Troubleshoot** check (`vmnm1` → `vmnm2`, TCP `22`) to generate live packets.</span>
6. <span dir="ltr">Return to **Packet capture** and click **Stop**. Explain that the resulting `.cap` file can be downloaded and inspected in Wireshark.</span>

</div>
