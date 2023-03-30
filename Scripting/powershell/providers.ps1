# get providers
Get-PSProvider

# get drive info 

Get-PSDrive

# setup provider alias

New-PsDrive -Name PSC `
    -PSProvider FileSystem `
    -Root '/app/'

Set-Location PSC:
Get-ChildItem | Format-Table

# set a differnt location before removing the ps drive
Set-Location /app

Remove-PSDrive PSC