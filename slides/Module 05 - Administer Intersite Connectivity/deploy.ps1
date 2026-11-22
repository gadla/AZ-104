# 0. Check for an active Azure session
$azContext = Get-AzContext -ErrorAction SilentlyContinue
if (-not $azContext -or -not $azContext.Account) {
    Write-Host "No active Azure session found. Signing in..." -ForegroundColor Yellow
    Connect-AzAccount
}
else {
    Write-Host "Connected to Azure as $($azContext.Account.Id) (Subscription: $($azContext.Subscription.Name))" -ForegroundColor Green
}

# 1. Create a new resource group
New-AzResourceGroup -Name "rg-az104-routing-demo" -Location "westeurope"

# 2. Deploy Bicep (prompts for the Linux VM password)
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-az104-routing-demo" `
  -TemplateFile ".\main.bicep"

# 3. Immediately stop and deallocate all three VMs to save costs
"vm-nva", "vm-1", "vm-2" | ForEach-Object {
    Stop-AzVM -ResourceGroupName "rg-az104-routing-demo" -Name $_ -Force -NoWait
}