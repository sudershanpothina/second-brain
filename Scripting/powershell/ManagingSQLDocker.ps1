Install-Module SqlServer

# run as a separate container
<#
docker build -t sql-server:1.0 -f C:\workspace\second-brain\Container\Docker\sql-server\Dockerfile .
docker run --rm --name sqlserver -p 1433:1433 sql-server:1.0
#>
$serverName = '192.168.86.44,1433'
$dbname= 'master'
$username = 'sa'
$pw = 'yourStrong(!)Password'
$queryTimeout = 50000

$sql = 'SELECT * FROM master.INFORMATION_SCHEMA.TABLES '
Invoke-Sqlcmd -Query $sql `
    -ServerInstance $serverName `
    -Database $dbname `
    -Username $username `
    -Password $pw `
    -QueryTimeout $queryTimeout


# can also do 
$sqlParams = @{
    ServerInstance = $serverName;
    Database = $dbname;
    Username = $username;
    Password = $pw;
    QueryTimeout = $queryTimeout;
}


$sql = @"
SELECT * FROM master.INFORMATION_SCHEMA.TABLES
"@
$sql = @"
Create Database MetsDB
"@

Invoke-Sqlcmd -Query $sql @sqlParams