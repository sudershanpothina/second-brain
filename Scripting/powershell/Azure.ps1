# install module without admin priv
Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force

# install for all users, required admin 
Install-Module -Name Az -AllowClobber -Scope AllUsers -Force

# Connect to Azure
Connect-AzAccount

Get-AzSubscription

# get the current subscription
Get-AzContext

# set context
$subId = Get-AzSubscription | Where-Object {$_.Name -eq "dev"} | Select-Object -Property ID
Set-AzContext -SubscriptionId $subId.Id

# resource groups

Get-AzResourceGroup | 
    Select-Object ResourceGroupName, Location | 
    Sort-Object ResourceGroupName | 
    Format-Table


function Get-RGS() 
{
    Get-AzResourceGroup | 
    Select-Object ResourceGroupName, Location | 
    Sort-Object ResourceGroupName | 
    Format-Table
}

Get-RGS

New-AzResourceGroup -Name test1 -Location 'Central US'

Remove-AzResourceGroup -Name test1 -Force
