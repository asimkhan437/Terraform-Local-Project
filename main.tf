# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "882939ed-a914-4c3c-8161-a98856cc86f2"

}

# Create a RG
resource "azurerm_resource_group" "rg" {
  name     = "RG-asimkhan"
  location = "westus2"
}
# Create a RG
resource "azurerm_resource_group" "rg2" {
  name     = "RG-asimkhan1"
  location = "westus2"

  tags = {
    Environment  = "Terraform Getting Started"
    Team         = "DevOps"
    Organisation = "NewOrg123"
  }
}


# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "AsimVnet"
  address_space       = ["10.0.0.0/24"]
  location            = "westus2"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    Environment = "Terraform Getting Started"
    Team        = "DevOps"
  }
}

#Create a new RG
resource "azurerm_resource_group" "rg123" {
  name     = "rg-resources"
  location = "West Europe"
}

#Create a Storage account
resource "azurerm_storage_account" "storageac" {
  name                     = "storageasimkhan"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

#Create an AKS with new RG
resource "azurerm_resource_group" "rg-asim" {
  name     = "rg-resources123"
  location = "WestUS2"
}

resource "azurerm_kubernetes_cluster" "rg-asim" {
  name                = "rg-aks1"
  location            = azurerm_resource_group.rg-asim.location
  resource_group_name = azurerm_resource_group.rg-asim.name
  dns_prefix          = "rgaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.rg-asim.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.rg-asim.kube_config_raw

  sensitive = true
}

resource "azurerm_private_dns_zone" "rg-asim" {
  name                = "privatelink.eastus2.azmk8s.io"
  resource_group_name = azurerm_resource_group.rg-asim.name
}

resource "azurerm_user_assigned_identity" "rg123" {
  name                = "aks-rg-identity"
  resource_group_name = azurerm_resource_group.rg-asim.name
  location            = azurerm_resource_group.rg-asim.location
}

#Create an API Management with defined RG in Root Module
resource "azurerm_api_management" "example123" {
  name                = "example-apim12"
  location            = azurerm_resource_group.rg2.location
  resource_group_name = azurerm_resource_group.rg2.name
  publisher_name      = "My Company"
  publisher_email     = "company@terraform.io"

  sku_name = "Developer_1"
}

#Create a Function app with a new RG

resource "azurerm_resource_group" "example12" {
  name     = "azure-functions-test-rg"
  location = "West Europe"
}

resource "azurerm_storage_account" "example13" {
  name                     = "functionsapptestsa12"
  resource_group_name      = azurerm_resource_group.example12.name
  location                 = azurerm_resource_group.example12.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example15" {
  name                = "azure-functions-test-service-plan"
  location            = azurerm_resource_group.example12.location
  resource_group_name = azurerm_resource_group.example12.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_function_app" "example14" {
  name                       = "test-azure-function123"
  location                   = azurerm_resource_group.example12.location
  resource_group_name        = azurerm_resource_group.example12.name
  app_service_plan_id        = azurerm_app_service_plan.example15.id
  storage_account_name       = azurerm_storage_account.example13.name
  storage_account_access_key = azurerm_storage_account.example13.primary_access_key
}


resource "azurerm_function_app_slot" "dev1234" {
  name                       = "test12321"
  location                   = azurerm_resource_group.example12.location
  resource_group_name        = azurerm_resource_group.example12.name
  app_service_plan_id        = azurerm_app_service_plan.example15.id
  function_app_name          = azurerm_function_app.example14.name
  storage_account_name       = azurerm_storage_account.example13.name
  storage_account_access_key = azurerm_storage_account.example13.primary_access_key
}
