# all vars start with $

$hi = "hello"

# or

Set-Variable -Name var1 -Value "hello"

# print
$hi

# get type of variable

$hi.GetType()

# display all methods for variable

$hi | get-member

# convert to upper

$hi.ToUpper()

# strong type variables using .net 

[int] $var1 = 2
$var1.GetType()

[string] $var2 = "hello"
$var2.GetType()

# contains menthod

"Powershell contains test".Contains("test")


# mathemaical operators

# -eq equals 
# -ne not equal to 
# -lt less than 
# -gt greater than 
# -le less than or equal 
# -ge greater than or equal 
# -in check value in array 
# -notin not in array 
# -Match match regular expression 
# -NotMatch not matching regular expression

# can do pre or post unary operators ++, -- 

# implicit conversions, value on the right is automatically converted to value on left
42 -eq "042" # results in True
"042" -eq 42 # results in False


# can also assign powershell commandlets
Get-Location
$loc = Get-Location
$loc


# list all vars
Get-Variable

# clear value of var
$var1 = $null
# or
Clear-Variable -Name var1

# Remove varialbe
Remove-Variable -Name var1