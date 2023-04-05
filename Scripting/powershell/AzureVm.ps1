$rg = New-AzResourceGroup -Name test1 -Location 'Central US'


function Get-RandomPassword {
    param (
        [Parameter(Mandatory)]
        [int] $length
    )
    $charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789{]+-[*=@:)}$^%;(_!&amp;#?>/|.'.ToCharArray()
    # $charSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.ToCharArray()
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[]($length)
 
    $rng.GetBytes($bytes)
 
    $result = New-Object char[]($length)
 
    for ($i = 0 ; $i -lt $length ; $i++) {
        $result[$i] = $charSet[$bytes[$i]%$charSet.Length]
    }
 
    return (-join $result)
}
Get-RandomPassword 15

$password = Get-RandomPassword 8;
$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force;
$user = "cloud_user";
$cred = New-Object System.Management.Automation.PSCredential ($user, $securePassword);

New-AzVM -ResourceGroupName $rg.ResourceGroupName `
    -Name "vm01" -Location $rg.Location -VirtualNetworkName vnet1 `
    -SubnetName "default" -SecurityGroupName "nsg01" -PublicIpAddressName "pip01" `
    -OpenPorts 80,3389 -Credential $cred

Get-AzVM -Name "vm01"

Remove-AzVm -Name "vm01" -ResourceGroupName $rg.ResourceGroupName -Force

foreach($rg in $(Get-AzResourceGroup).ResourceGroupName) 
{
    Write-Host "removing $rg"
    Remove-AzResourceGroup -Name $rg -Force
}