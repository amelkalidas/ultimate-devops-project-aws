terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 4.12.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-ultimate-devops-project"
  #   storage_account_name = "saultimatedevopsproj"
  #   container_name       = "tfstate"
  #   key                  = "aks-cluster.terraform.tfstate"
    
  # }
}

provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id

    
  
}