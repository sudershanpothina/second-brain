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
    