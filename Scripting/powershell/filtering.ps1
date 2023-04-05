Get-ChildItem | Where-Object {$_.Length -gt 1 } | Sort-Object Length


# use the data above and format into a table

Get-ChildItem | Where-Object {$_.Length -gt 2} | Sort-Object Length | Format-Table -Property Name, Lenght -Autosize

#
Get-ChildItem | Where-Object {$_.Length -gt 2} | Sort-object Length | Format-Table -Property Name, Lenght -Autosize

# get particular objects

Get-ChildItem | Select-Object Name, Length


# extend into new line use backtick

Get-ChildItem  |
    Select-Object Name, Lenght

# get all properties
Get-ChildItem | Format-Table -Property *


# another way
Get-ChildItem | Format-list *
    

# get first 5
Get-ChildItem | Select-Object -first 5


# select object properties
Get-ChildItem | Format-list

Get-ChildItem | Select-Object -Property Name,Lenght