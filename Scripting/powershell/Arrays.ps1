$string1 = "this is a test string"
$string2 = 'this is a string too!'

$string3 = "Hello world 'Okay'"
$string4 = "Hello world ""Okay"" # this also works"


# can also use backticks for new line and tabs

$string5 = "power`nshell"
$string6 = "power`tshell"

# multiline strings, should start and end with @
$hereText = @"
text 1 
text 2
"@


# interpolation , does not work with single quotes
$var1 = "test"
echo "I am ${var1}ing"


$items = (Get-ChildItem).Count
$loc = Get-Location
echo "There are ${items} items at ${loc}"

# also works with here strings

$hereText1 = @"
There are ${items} at
${loc}
"@

# using expressions in string interpolation
$var1 = "There are $((Get-ChildItem).Count) items at $(Get-Location)"
$var1

# string formatting
$items = (Get-ChildItem).Count
$loc = Get-Location
"There are {0} items at {1}" -f $items, $loc



# Arrays
$array1 = 1,2,3,4,5
#can also be done the following way
$array1 = 1..8
# correct syntax
$array1 = @(1,2,3)
# create empty array, only way
$array1 = @()
$array1 += 1
$array1
$array1[0]

#display last object
$array1[-1]
#display last few objects
$array1[-2,-1]

$array2 = "Test1", "Test2"
$array2

# Arrays are mutable

$array2[1] = "Test3"


$array1 -contains 1
$array1 -notcontains 2


# hash tables
# key value pairs or a dictionary

$hash1 = @{"Key" = "Value";
        "Powershell" = "powershell.com";
        "TestKey" = "TestValue"}


$hash1

$hash1["Powershell"]
$key = "TestKey"
$hash1.$($key)
$hash1.$("Power"+"shell")

# add values

$hash1["TestKey1"] = "TestValue1"
$hash1

# Remove values
$hash1.Remove("Powershell")
$hash1

# check if hash contains keys
$hash1.contains("TestKey1")

$hash1.containsValue("TestValue1")

#get keys
$hash1.keys