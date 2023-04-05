Get-ChildItem | Export-Csv -Path child.csv
Get-Content child.csv
Remove-Item -Path child.csv