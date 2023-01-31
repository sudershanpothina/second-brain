```
terraform init

# add empty resource block
resouce "azurerm_resource_group" "rg" {}

terraform import azurerm_resource_group.rg <resource id>

add values after import, import only adds to the state file
can only import one resource at a time
```