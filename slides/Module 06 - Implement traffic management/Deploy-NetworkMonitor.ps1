<#
.SYNOPSIS
    Deploys the main.bicep template for the Network Watcher demonstration environment.
.DESCRIPTION
    Installs missing Az.Accounts and Az.Resources modules for the current user and, on Windows,
    installs the Bicep CLI in the user's .bicep directory if missing.
    Connects via Connect-AzAccount if needed, ensures the target Resource Group exists,
    and deploys main.bicep to West Europe by default. Installation requires internet access.
    Uses the active subscription and stops on lookup, installation, or deployment failures.
#>

[CmdletBinding()]
param (
    [string]$ResourceGroupName = 'network-monitor',

    [string]$Location = 'westeurope',

    [string]$TemplateFile = (Join-Path -Path $PSScriptRoot -ChildPath 'main.bicep'),

    [string]$AdminUsername = 'azureadmin',

    [SecureString]$AdminPassword = ('AzureIsFun!' | ConvertTo-SecureString -AsPlainText -Force),

    [string]$VmSize = 'Standard_B2s'
)

$ErrorActionPreference = 'Stop'

# 1. Verify Bicep template file exists
if (-not (Test-Path -Path $TemplateFile -PathType Leaf)) {
    throw "Template file not found at path: $TemplateFile"
}

foreach ($moduleName in @('Az.Accounts', 'Az.Resources')) {
    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        Write-Host "Installing $moduleName for the current user..." -ForegroundColor Cyan
        if ($PSVersionTable.PSVersion.Major -lt 6) {
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            if (-not (Get-PackageProvider -ListAvailable | Where-Object Name -eq 'NuGet')) {
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope CurrentUser -Force | Out-Null
            }
        }
        Install-Module -Name $moduleName -Repository PSGallery -Scope CurrentUser -Force -AllowClobber
    }
    Import-Module -Name $moduleName -ErrorAction Stop
}

if (-not (Get-Command -Name bicep -CommandType Application -ErrorAction SilentlyContinue)) {
    if ($env:OS -ne 'Windows_NT') {
        throw 'Automatic Bicep CLI installation requires Windows. Install Bicep on PATH before running this script on another operating system.'
    }

    $installPath = Join-Path -Path $HOME -ChildPath '.bicep'
    $bicepPath = Join-Path -Path $installPath -ChildPath 'bicep.exe'
    if (-not (Test-Path -LiteralPath $bicepPath -PathType Leaf)) {
        $architecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()
        $asset = switch ($architecture) {
            'X64' { 'bicep-win-x64.exe' }
            'Arm64' { 'bicep-win-arm64.exe' }
            default { throw "Unsupported architecture for automatic Bicep installation: $architecture" }
        }

        Write-Host "Installing Bicep CLI in '$installPath'..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $installPath -Force | Out-Null
        $downloadPath = Join-Path -Path $installPath -ChildPath "bicep-$([guid]::NewGuid()).exe"
        try {
            Invoke-WebRequest -Uri "https://github.com/Azure/bicep/releases/latest/download/$asset" -OutFile $downloadPath -UseBasicParsing
            & $downloadPath --version
            if ($LASTEXITCODE -ne 0) {
                throw "Downloaded Bicep CLI verification failed with exit code $LASTEXITCODE."
            }
            Move-Item -LiteralPath $downloadPath -Destination $bicepPath -Force
        }
        finally {
            if (Test-Path -LiteralPath $downloadPath) {
                Remove-Item -LiteralPath $downloadPath -Force
            }
        }
    }
    $env:PATH = "$installPath$([IO.Path]::PathSeparator)$env:PATH"
}

& bicep --version
if ($LASTEXITCODE -ne 0) {
    throw "Bicep CLI verification failed with exit code $LASTEXITCODE."
}

# 2. Check Azure PowerShell connection and login if needed
Write-Host "Checking Azure connection status..." -ForegroundColor Cyan
$azContext = Get-AzContext

if (-not $azContext -or -not $azContext.Account) {
    Write-Host "No active Azure session found. Launching Connect-AzAccount..." -ForegroundColor Yellow
    Connect-AzAccount | Out-Null
    $azContext = Get-AzContext
}

if (-not $azContext.Account -or -not $azContext.Subscription) {
    throw 'No usable Azure account and subscription context is available after login.'
}

Write-Host "Connected to Azure as '$($azContext.Account.Id)' (Subscription: '$($azContext.Subscription.Name)')" -ForegroundColor Green

# 3. Ensure Resource Group exists
Write-Host "Ensuring Resource Group '$ResourceGroupName' exists in '$Location'..." -ForegroundColor Cyan
$rg = Get-AzResourceGroup -ErrorAction Stop | Where-Object ResourceGroupName -eq $ResourceGroupName

if (-not $rg) {
    New-AzResourceGroup -Name $ResourceGroupName -Location $Location | Out-Null
    Write-Host "Resource Group '$ResourceGroupName' created." -ForegroundColor Green
}
else {
    Write-Host "Resource Group '$ResourceGroupName' already exists." -ForegroundColor Green
}

# 4. Deploy main.bicep
$deploymentName = "deploy-network-monitor-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Write-Host "Starting Bicep deployment '$deploymentName'..." -ForegroundColor Cyan

$deploymentParams = @{
    Name                  = $deploymentName
    ResourceGroupName     = $ResourceGroupName
    TemplateFile          = $TemplateFile
    location              = $Location
    adminUsername         = $AdminUsername
    adminPassword         = $AdminPassword
    vmSize                = $VmSize
}

$deployment = New-AzResourceGroupDeployment @deploymentParams -Verbose

if ($deployment.ProvisioningState -eq 'Succeeded') {
    Write-Host "`nDeployment succeeded!" -ForegroundColor Green
    Write-Host "vmnm1 Private IP: $($deployment.Outputs.vmNm1PrivateIp.Value)" -ForegroundColor Cyan
    Write-Host "vmnm2 Private IP: $($deployment.Outputs.vmNm2PrivateIp.Value)" -ForegroundColor Cyan
}
else {
    throw "Deployment finished with state: $($deployment.ProvisioningState)"
}
