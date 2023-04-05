$adminUser = Read-Host
$password = Read-Host

# convert to secure string
$passwordSecure = ConvertTo-SecureString -String $password -AsPlainText -Force

# convert secure string back to text
ConvertFrom-SecureString $passwordSecure -AsPlainText

# create credential object
$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminUser , $(ConvertTo-SecureString -String $password -AsPlainText -Force  )