## create Vnet

az network vnet create --name "vnet1" --resource-group <TAB> --address-prefixes 10.1.0.0/16

## create subnet 
az network vnet subnet create --name "subnet1" --vnet-name "vnet1" --resource-group <TAB> --address-prefixes 10.1.1.0/24


## Deligated subnet
process for designating a subnet to azure managed services being injectd to virtual network