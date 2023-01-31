```
#providers.tf
 terraform {

   required_version = ">=0.12"

   required_providers {
     azurerm = {
       source = "hashicorp/azurerm"
       version = "~>2.0"
     }
   }
 }

 provider "azurerm" {
   features {}
   skip_provider_registration = true
 }

 # Import the Azure Resource Group
resource "azurerm_resource_group" "k8s" {
  name     = "664-9a7f5228-create-an-aks-cluster-in-azure-with-t"
  location = "eastus"
}

#aks.tf

resource "azurerm_kubernetes_cluster" "k8s" {
    name                = var.cluster_name
    location            = azurerm_resource_group.k8s.location
    resource_group_name = azurerm_resource_group.k8s.name
    dns_prefix          = var.dns_prefix

    linux_profile {
        admin_username = "ubuntu"
        ssh_key {
            key_data = file(var.ssh_public_key)
        }
    }

    default_node_pool {
        name            = "agentpool"
        node_count      = var.agent_count
        vm_size         = "Standard_D2s_v3"
        os_disk_size_gb = 30
    }

    service_principal {
        client_id     = var.aks_service_principal_app_id
        client_secret = var.aks_service_principal_client_secret
    }

    network_profile {
        load_balancer_sku = "Standard"
        network_plugin = "kubenet"
    }

    tags = {
        Environment = "Development"
    }
}

# variables.tf
variable "resource_group_location" {
    default = "eastus"
}

variable "agent_count" {
    default = 3
}

variable "ssh_public_key" {
    default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
    default = "k8sguru"
}

variable cluster_name {
      default = "k8sguru"
}

variable aks_service_principal_app_id {
    default = "8ff1fade-7de3-4ec0-af1c-a862cb9b7976"
}

variable aks_service_principal_client_secret {
    default = "jmd8Q~uyQxg6XuKUql.wYmA828KhtR3VkSW5lbKL"
}

# outputs.tf
output "resource_group_name" {
    value = azurerm_resource_group.k8s.name
}

output "client_key" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
}

output "client_certificate" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
}

output "cluster_username" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.username
}

output "cluster_password" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.password
}

output "kube_config" {
    value = azurerm_kubernetes_cluster.k8s.kube_config_raw
    sensitive = true
}

output "host" {
    value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}

Check for log analytics
https://learn.acloud.guru/course/advanced-terraform-with-azure/learn/1c290842-1adc-4b21-aed4-d5b0123b2479/fb180f4c-02f1-4fd4-9661-79d8ed09feeb/watch

echo "$(terraform output kube_config)" > ./azurek8s
edit EOT at the start and end of the file
export KUBECONFIG=./azurek8s
kubectl get nodes
```