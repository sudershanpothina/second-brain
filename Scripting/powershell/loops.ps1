# for loop

for ($i=0; $i -le 5; $i++)
{
    "`$i = $i"
}

#initialize the var separately 

$i = 0

for(; $i -le 4; $i++) {
    "`$i = $i"
}

$array1 = 11,2,3,4,34,53

for ($i=0; $i -lt $array1.Length; $i++) {
    "array value at `$i  $($array1[$i])"
}

# forEach , enhanced for loop for iterating over collections of elements

foreach ($item in $array1) {
    "`$item = $item"
}


foreach ($item in Get-ChildItem) {
    "`$item = $item"
}
# while
$i = 1
while ($i -le 4) 
{
    $i
    $i++
}


# do while
$i = 1
do 
{
    $i
    $i++
}while($i -le 5)



# script blocks, code inside {}

foreach ($item in 1..3)
{ # start of script block 
    $item 
} # end of script block

# script block and exist on its own 

{ Clear-Host; "Testing script block"} # this will only print it

&{ Clear-Host; "Testing script block"} # this will run it

$scriptBlock1 = { Clear-Host; "Testing script block"}

&$scriptBlock1

