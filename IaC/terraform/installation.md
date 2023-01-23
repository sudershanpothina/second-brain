#installation #terraform
```

yum install -y yum-utils

yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

yum -y install terraform

  

touch ~/.bashrc

terraform -install-autocomplete

  

```

```

powershell

  

Get-ExecutionPolicy // if unrestricted run the following

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.Client).DownloadString('https://chocolatey.org.install.ps1'))

  

choco install terraform

```
linux
```
wget https://releases.hashicorp.com/terraform/1.3.7/terraform_1.3.7_linux_386.zip
unzip terraform_1.3.7_linux_386.zip
sudo mv terrafrom /usr/sbin/

```

```

Docker file

FROM registry.access.redhat.com/ubi8/ubi:8.1

RUN yum install -y yum-utils && yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo\

&& yum -y install terraform

RUN touch ~/.bashrc && terraform -install-autocomplete
RUN yum -y install openssh-server ed openssh-clients glibc-langpack-en && yum clean all && systemctl enable sshd
# yum -y install openssh-server ed openssh-clients glibc-langpack-en && yum clean all && systemctl enable sshd


```

  

```

vscode setup

  

// For format details, see https://aka.ms/devcontainer.json. For config options, see the

// README at: https://github.com/devcontainers/templates/tree/main/src/alpine

{

    "name": "rhel-univ-base-image-workspace",

    "image": "registry.access.redhat.com/ubi8/ubi:8.1",

  

    // "image": "terraform-rhel-ubi:1.0",

    // Features to add to the dev container. More info: https://containers.dev/features.

    // "features": {},

  

    // Use 'forwardPorts' to make a list of ports inside the container available locally.

    // "forwardPorts": [],

  

    // Use 'postCreateCommand' to run commands after the container is created.

    // "postCreateCommand": "uname -a",

  

    // Configure tool-specific properties.

    // "customizations": {},

  

    // Uncomment to connect as root instead. More info: https://aka.ms/dev-containers-non-root.

    "remoteUser": "root"

}

```

  

install az cli

```

rpm --import https://packages.microsoft.com/keys/microsoft.asc

  

sh -c 'echo -e "[azure-cli]

name=Azure CLI

baseurl=https://packages.microsoft.com/yumrepos/azure-cli

enabled=1

gpgcheck=1

gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

  

yum install -y azure-cli

  
  

az login --service-principal -u <app-id> -p <password-or-cert> --tenant <tenant>

az login --service-principal -u 4fafc292-23c8-4266-9c01-004223b54cf6 -p Sov8Q~fTO3NUZl~EWlx9OZm5QtE6v9NNxOT~Ubi6 --tenant 3617ef9b-98b4-40d9-ba43-e1ed6709cf0d


  

az account show // get subsid


export ARM_CLIENT_ID="4fafc292-23c8-4266-9c01-004223b54cf6"
export ARM_CLIENT_SECRET="Sov8Q~fTO3NUZl~EWlx9OZm5QtE6v9NNxOT~Ubi6"
export ARM_SUBSCRIPTION_ID="964df7ca-3ba4-48b6-a695-1ed9db5723f8" #id value after az login
export ARM_TENANT_ID="3617ef9b-98b4-40d9-ba43-e1ed6709cf0d"
  
  

```

