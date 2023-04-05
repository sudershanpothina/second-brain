# functions are script blocks with names

function Write-HelloWorld() 
{
    Clear-Host
    Write-Host "Hello World"
}
Write-HelloWorld

# Get approved list of verbs
Get-Verb | Sort-Object Verb

function Get-FullName {
    param (
       $firstName, $lastName
    )

    Write-Host ($firstName + $lastName)
    
}

Get-FullName("hello", "man")


# or 

function Get-FullName( $firstName, $lastname) {

    Write-Host ($firstName + $lastName)
    
}


Get-FullName("hello", "man")


# change value of variable outside the function scope
# need to use ref tags while sending and receiving 

function Set-RefVar ([ref] $myparam) 
{
    $myparam.Value = 2
}

$myparam = 1
Set-RefVar([ref] $myparam)
$myparam

# also supports named parameters, will let you switch order

function Get-Avalue ( $one, $two)
{
    return $one * $two
}

Get-Avalue -two 2 -one 1


# Advanced functions
# pipeline functions, needs three blocks begin, process and end

function Get-PSFiles {
    # executes at the start of the script
    begin {
        $retval = "Here are some files `r`n"
    }

    # process block will execute for each object passed 
    process {
        if($_.Name -like "*.ps1")
        {
            $retval += "`t $($_.Name) `r`n"
        }
    }

    # enb block executes once after the end
    end {
        return $retval
    }
    
}
Get-ChildItem | Get-PSFiles


# Advanced functions similar to commandlets

function Send-Greeting {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name
    )
    Process
    {
        Write-Host ("Hello $Name")
    }
}

Send-Greeting -Name test



# stores the output of a function in a variable and also see the output on the screen

Get-ChildItem -OutVariable files

$files


# Error handling
# Try, Catch and Finally

function divZero ($enum, $denom) {
    Write-Host "Begin"
    $result = $enum / $denom
    Write-host "Result: $result"
    Write-Host "End"
}
divZero -enum 11 -denom 2 # no error
divZero -enum 0 -denom 3 
divZero -enum 11 -denom 0 # error

# using try catch

function divZero ($enum, $denom) {
    Write-Host "Begin"
    try {
        $result = $enum / $denom
        Write-host "Result: $result"

    }
    catch {
        Write-Host "Error"
        Write-Host $_.ErrorID
        Write-Host $_. Exception.Message
        break # error propagates to the parent
    }
    finally {
        Write-host "End"
    }
}

divZero -enum 11 -denom 2 # no error
divZero -enum 0 -denom 3 
divZero -enum 11 -denom 0 # no error



# adding help to functions

# built in help for powershell 
Get-Help Get-ChildItem


function Get-ChildName {
   Write-Output (Get-ChildItem | Select-Object "Name")
}

Get-ChildName

Get-Help Get-ChildName # wont give too many details

# using custom tags for this 


function Get-ChildName {
    <#
    .SYNOPSIS 
    Returns a list of names 

    .DESCRIPTION 
    uses get child-name and displays only the name

    .INPUTS
    none

    .OUTPUTS
    Sends a collection of strings

    .EXAMPLE
    Example 1 
    Get-ChildName
    
    .EXAMPLE
    Example2
    Get-ChildName | Where-Object {$Name -like "*.ps1"}
    #>
    Write-Output (Get-ChildItem | Select-Object "Name")
 }

 Get-help Get-ChildName
 Get-help Get-ChildName -Examples




 # load functions from another file
 # its called Dot sourcing
 # . <pathofps1>

 . C:\workspace\second-brain\Scripting\powershell\testfunction.ps1