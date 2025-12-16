# data "azurerm_virtual_network" "vnet" {
#   name                = "testvm01-vnet"
#   resource_group_name = "OpentelemetryProject"

# }
# data "azurerm_subnet" "subnet" {
#   name                 = "default"
#   virtual_network_name = data.azurerm_virtual_network.vnet.name
#   resource_group_name  = "OpentelemetryProject"
  
  
# }