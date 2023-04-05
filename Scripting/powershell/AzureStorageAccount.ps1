New-AzResourceGroup -Name test1 -Location 'Central US'
$rg = Get-AzResourceGroup -Name test1


New-AzStorageAccount `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name sdrshnrcks123 -Location $rg.Location `
    -SkuName Standard_LRS -Kind StorageV2  


Get-AzStorageAccount | Select-Object StorageAccountName, Kind

$sa=Get-AzStorageAccount -Name sdrshnrcks123 -ResourceGroupName $rg.ResourceGroupName
# get keys
$saKeys = Get-AzStorageAccountKey -StorageAccountName $sa.StorageAccountName -ResourceGroupName $rg.ResourceGroupName
$saKeys.Value[0]

# create context token in memory
New-AzStorageContext -StorageAccountName $sa.StorageAccountName -StorageAccountKey $saKeys.Value[0]

# create container

$saContainer1 = New-AzStorageContainer -Name "sdrshnrckscont123" -Context $saContext -Permission Container


# upload a file to the container

$location = Get-Location
$psFiles = Get-ChildItem "*.ps1"
$timeout = 500000

foreach($psFile in $psFiles) 
 {
  Set-AzStorageBlobContent -File $psFile.FullName -Container $saContainer1.Name -Blob $psFile.Name -Context $saContext -ServerTimeoutPerRequest $timeout -ClientTimeoutPerRequest $timeout -Force
}


Get-AzStorageBlob -Container $saContainer1.Name -Context $saContext


Remove-AzStorageAccount -Name sdrshnrcks123 -ResourceGroupName $rg.ResourceGroupName -Force

Remove-AzResourceGroup -Name test1 -Force