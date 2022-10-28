![](https://i.imgur.com/Xhf7Z0L.png)

create a token with an existing user, root in this case 
uncheck the privilege separation box
Note the token Id and the secret

Get template information ![](https://i.imgur.com/HrKnwZx.png)

provider.tf
```
terraform {

  required_providers {

    proxmox = {

      source = "Telmate/proxmox"

      version = "2.9.11"

    }

  }

}

  

variable "proxmox_api_url" {

    type = string

}

variable "proxmox_token_id" {

    type = string

    sensitive = true

}

variable "proxmox_token_secret" {

    type = string

    sensitive = true

}

  

provider "proxmox" {

  pm_api_url = var.proxmox_api_url

  pm_api_token_id = var.proxmox_token_id

  pm_api_token_secret = var.proxmox_token_secret

  pm_tls_insecure = true

}
```

credential.auto.tfvars
```
proxmox_api_url = "https://192.168.20.13:8006/api2/json"

proxmox_token_id = "xxxxxxxxxxxxxx"

proxmox_token_secret = "xxxxxx-xxxxxxxxx-xxxxxx"
```

demovm.tf
```
resource "proxmox_vm_qemu" "demo1" {

  name = "demo1"

  vmid = "401"

  target_node = "skyzone01"

  

  clone = "centos0"

#   agent = 1

  cores = 3

  sockets = 1

  cpu = "host"

  memory = 7860

  network {

    bridge = "vmbr0"

    model = "scsi0"

  }

  disk {

    storage = "local-lvm"

    type = "virtio"

    size = "50G"

  }

  os_type = "cloud-init"

  ipconfig0 = "ip=192.168.20.30/16,gw=192.168.20.1"

  ssh_user = "test"

  sshkeys = <<EOF

  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDJ9qu62zmIfakUjgQ4W7tCYZnOtDjSj2NqjCh1XxeNpNTC5dnF67XYH2ZyRa7bfLEAIBNd6plZ6sfDKrkBp1KgX0GP90l06FiW6rhqYd0dMVrckKrZRC5aI1r3qsK+AIkKZusAohT0nNZYgzNFMvMo59kv5QLexNzX/yIDcjq9sDuAK8uBhBoSJXUt3wRf/UmubHlA3nDP2h93tKuql209UmjB4txd6RgzoylyL22+se8F/84a8XjCRvecdqhTkJg/7ULm3KafIGm/veGm7wZz5do5jMKDIQEJW3cnEGCvhBjjFC/XfnHvqnBsd3g4ji+9r7RBHgrfQXoibmmEVM4MX1tmfRq/QW5REOV5TEKd7fA/woTYGoUxGR70nHMEl5LtThh1RLi0IwJ+8Pz+mTLj/j+NsRzbvsVu6RjkYwFREwrR7AkMPqY4e0jGVx5wF3W1SClX+AU66VOu4gqm96QOt1Ds5SC0mKVZQSoXMjWuFxeU9HP7uctWXMLAOM+WJw8=

  EOF

}
```

Fails after creating VM, need to fix #todo