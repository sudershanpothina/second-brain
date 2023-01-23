terraform cheats

https://acloudguru-content-attachment-production.s3-accelerate.amazonaws.com/1622032650435-terraform-cheatsheet-from-ACG.pdf

  
  

terraform azure provider

```

export ARM_CLIENT_ID="f0ba1de3-c947-417b-9bd4-5e6e750ce0aa"

export ARM_CLIENT_SECRET="Bfp8Q~B8NeC7ORkTVrUFTF~18mwrrVeqP6GRecGg"

export ARM_SUBSCRIPTION_ID="964df7ca-3ba4-48b6-a695-1ed9db5723f8"

export ARM_TENANT_ID="3617ef9b-98b4-40d9-ba43-e1ed6709cf0d"

  

// or add it in the provider section

  

variable "client_secret" {

}

  

terraform {

  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"

      version = "=3.0.0"

    }

  }

}

  

# Configure the Microsoft Azure Provider

provider "azurerm" {

  features {}

  subscription_id = "00000000-0000-0000-0000-000000000000"

  client_id       = "00000000-0000-0000-0000-000000000000"

  client_secret   = var.client_secret

  tenant_id       = "00000000-0000-0000-0000-000000000000"

}

  
  

terraform init // add providers

terraform plan //verify login

```

  

cheat sheet

  

```

terraform version

  

terraform -chdir=<path to tf> <subcommand>

  

terraform init // first command to run

  

terraform plan // dry run

    terraform plan -out <plan name> // save it to a file

    terraform plan -destroy // dry run destroy

  

terraform apply // apply changes

    terraform apply <plan name>

    terraform apply -target=<resource name> //apply changes only to a single resource

    terraform apply -var my_variable=<variable>

  

terraform destroy // destory changes

  

terraform providers // get list of providers being used

  
  

```

  

```

terraform docker

  

terraform {

    required_providers {

        docker = {

            source = "terraform-providers/docker"

        }

    }

}

  

provider "docker" {

  

}

resource "docker_image" "nginx" {

    name = "nginx:latest"

}

resource "docker_container" "nginx" {

    image = docker_image.nginx.latest

    name = "tutorial"

    ports {

        internal = 80

        external = 8080

    }

}

```

  

override config

```

main.tf

  

resource "aws_instance" "web" {

    instance_type = "t2.micro"

    ami = "ami-408c7f28"

}

  

override.tf

  

resource "aws_instance" "web" {

    ami = "foo

}

  

plan output will be

  

resource "aws_instance" "web" {

    instance_type = "t2.micro"

    ami = "foo"

}

  

// use in moderation

```

  

```

input variable validation rules, use tfvrs extension

  

input_vars.tfvars

  

can also use terraform apply -var-file=input_vars.tfvars"

  

to automatically load it use terraform.tfvars

  

environment variables TF_VAR_image_id (should start with TF_VAR_)

  

variable "image_id" {

    type = string

    description = "id of the machine"

    validation = {

        condition = length(var.image_id) > 4 && substr(var.image_id, 0, 4) == "ami-"

        error_message = "wrong image id"

    }

}

  

sensitive variables, do not show in the output

variable "image_id" {

    type = string

    description = "id of the machine"

    sensitive = true

}

  
  

```
![](https://i.imgur.com/9FMNbP5.png)


output variables
```
output "instance_ip_addr" {
	value = aws_instance.server.private_ip
	description = (optional)
	sensitive = true (optional)
}

to access child module outputs use the following syntax
module.module_name.output_name

can also use depends_on optional argument, //last resort
depends_on = [
	resource1,
	resource2
]
```

local variables - temp variables within a module. Use in moderation

```
locals {
  service_name = "foo"
  owner = "test"
}

using the local values

resource "aws_instace" "example" {
	tags = local.service_name
}
```

Modules - container of multiple resources 
package and re use resources
parameters
source (required) 
version - pull modules from a registry
input variable 
meta - depends_on, lifecycle, count, for_each, providers (passes provider data)

```
to call a module

module "servers" {
	source = "/.app-cluster"
	servers = 5
}

```

![](https://i.imgur.com/ifh9Mt1.png)

![](https://i.imgur.com/7jVTn0g.png)


source types

local 
terraform registry
github
bitbucket
git
http
s3
gcs buckets 

```
module "vpc" {
	source = "git::https://example.com/vpc.git?ref=v1.2.0"
}

ref lets you select the branch
```

expressions and functions

conditional exp

condition ? true_val : false_val
	common place to use is for validation null values
	var.a = "" ? var.a : "default-a"

there are built in functions like min,max ...
	use terraform console to test functions


Backends
only for terraform cli

```
terraform {
	backend "remote"{ // terraform cloud
		organization = "cpr_example"
		workspaces = {
			name = "ex-app-prod"
		}
	}
}
```

when changing backend use terraform init 

```
terraform {

	backend "local"
	path = "/path to the state file"
}



```

Data source config

```
data "terraform_remote_state" "foo" {
	backed = remote
	config = {
		organization = "cpr_example"
		workspaces = {
			name = "ex-app-prod"
		}
	}
}
```

https://developer.hashicorp.com/terraform/language/settings/backends/configuration

azure backend

```
terraform {
	backend "azurerm" {
		resource_group_name = "storage account resource group"
		storage_account_name = "test23"
		container_name = "tfstate"
		key = "prod.terraform.tfstate"
	}

}
```

State 

terraform show
terraform state list
terraform state show <resource>
terraform state mv test test1
terraform state rm 'test.bar'
terraform state pull
terraform state push


Workspaces - separate instances of the state data

terraform workspace select <name>
terraform workspace list
terraform workspace new <name>
terraform workspace delete <name>

terraform creates a backup statefile - good to store this in case of accidental delete
![](https://i.imgur.com/f6O2Mf0.png)


data from remote state file

data "terraform_remote_state" "backend-state" {
	backend = "local"
	config = {
		path = "../somefolder/terraform.tfstate"
	}
}

provider "aws" {
	region = data.terraform_remote_state.backend-state.outputs.region
}


for each

```
locals {
  security_groups = {
    sg_ping = aws_security_group.sg_ping.id,
    sg_8080 = aws_security_group.sg_8080.id,
  }
}

resource "aws_instance" "web_app" {
  for_each               = local.security_groups
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [each.value]
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "${var.name}-learn-${each.key}"
  }
}

output "instance_id" {
  value = [for instance in aws_instance.web_app: instance.id]
}
```