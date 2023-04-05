$sp = New-AzADServicePrincipal -DisplayName "sp001"

# get password
$sp.PasswordCredentials.SecretText

# add role
New-AzRoleAssignment -ApplicationId $($sp.Appid) -RoleDefinitionName 'Reader'

Remove-AzRoleAssignment -ObjectId $sp.id -RoleDefinitionName 'Reader'


Get-AzADServicePrincipal -DisplayName sp001   

Remove-AzADServicePrincipal -DisplayName $sp.DisplayName



