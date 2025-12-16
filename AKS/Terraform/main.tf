locals {
  tags = {
    Owner = "Amel.kalidas@neudesic.com"
    project = "AKS-opentelemetry"
  }
}

resource "azurerm_resource_group" "aksRg01" {
    name = "RG-AKS-OpenTelemetry"
    location = "East US"
    tags = local.tags  
}
resource "azurerm_virtual_network" "LabVnet01" {
  name = "vnet-aks-telemetry"
  resource_group_name = azurerm_resource_group.aksRg01.name
  location = azurerm_resource_group.aksRg01.location
  address_space = ["10.10.0.0/16"]
  
}

resource "azurerm_subnet" "aks-subnet" {
  name = "snet-aks-telemetry"
  resource_group_name = azurerm_resource_group.aksRg01.name
  virtual_network_name = azurerm_virtual_network.LabVnet01.name
  address_prefixes = ["10.10.1.0/24"]
  
}

resource "azurerm_subnet" "defaultsubnet" {
  name = "default-subnet"
  resource_group_name = azurerm_resource_group.aksRg01.name
  virtual_network_name = azurerm_virtual_network.LabVnet01.name
  address_prefixes = ["10.10.2.0/24"]
  
}
resource "azurerm_kubernetes_cluster" "aks_cluster" {
    name = "aks-telemetry-cluster"
    location = azurerm_resource_group.aksRg01.location
    resource_group_name = azurerm_resource_group.aksRg01.name
    dns_prefix = "aks-telemetry"
    default_node_pool {
        name = "default"
        node_count = 2
        vm_size = "Standard_B2s"
    }
    identity {
        type = "SystemAssigned"
    }
    network_profile {
        network_plugin = "azure"
        # network_policy = "overlay"
      
    }
    tags = local.tags
}
resource "azurerm_container_registry" "acr" {
  name                = "acrtelemetry${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.aksRg01.name
  location            = azurerm_resource_group.aksRg01.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = local.tags
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# 6. Allow AKS to pull from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}