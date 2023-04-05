# pre reqs 
# install openssh-client and server on the machine to remote
# make sure the following are in place in etc/ssh/sshd config
#   PasswordAutentication yes
#   Subsystem powershell /usr/bin/pwsh -sshs -NoLogo -NoProfile
# restart sshd service

# create ssh server
<#

docker build -t sshserver:1.0 -f C:\workspace\second-brain\Container\Docker\ssh-server\Dockerfile 
docker run --rm --name sshserver -p 22:22 sshserver:1.0
#>


# Remoting 
$session = New-PSSession -HostName 192.168.86.44 -UserName test
$session
Enter-PSSession $session
Invoke-Command $session -ScriptBlock {Get-Process}

# sudo command does not work