function Get-ChildName 
{
    Write-Host (Get-ChildItem | Select-Object "Name")
}