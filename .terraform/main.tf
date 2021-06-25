terraform {
  backend "remote" {
    organization = "PFL"
    workspaces {
      name = "jaret-demo"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "ecb4f63c-b0e0-4b21-9227-a58fd02cc035"
}

resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}

resource "azurerm_resource_group" "main" {
  name     = "api-management-demo"
  location = "Central US"
}

# resource "azurerm_app_service_plan" "main" {
#   name                = "api-management-demo-asp"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name

#   sku {
#     tier = "Basic"
#     size = "B1"
#   }
# }

# resource "azurerm_app_service" "main" {
#   name                = "api-managment-demo-appservice"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   app_service_plan_id = azurerm_app_service_plan.main.id

#   site_config {
#     dotnet_framework_version = "v5.0"
#   }
# }

# resource "azurerm_app_service_slot" "main" {
#   name                = random_id.server.hex
#   app_service_name    = azurerm_app_service.main.name
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   app_service_plan_id = azurerm_app_service_plan.main.id

#   site_config {
#     dotnet_framework_version = "v5.0"
#   }
# }

# resource "azurerm_app_service_active_slot" "main" {
#   resource_group_name   = azurerm_resource_group.main.name
#   app_service_name      = azurerm_app_service.main.name
#   app_service_slot_name = azurerm_app_service_slot.main.name
# }

resource "azurerm_api_management" "main" {
  name                = "api-management-demo-apim"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = "PFL"
  publisher_email     = "is@pfl.com"
  sku_name            = "Consumption_0"
}

resource "azurerm_api_management_api_version_set" "main" {
  name                = "api-management-demo-apim-versions"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  display_name        = "API Versions"
  versioning_scheme   = "Query"
  version_query_name  = "api-version"
}

resource "azurerm_api_management_api" "main" {
  name                = "order-api"
  resource_group_name = azurerm_resource_group.main.name
  api_management_name = azurerm_api_management.main.name
  revision            = "1"
  display_name        = "Order API"
  path                = ""
  protocols           = ["https"]
  version             = "2021-06-23"
  version_set_id      = azurerm_api_management_api_version_set.main.id

  import {
    content_format = "openapi"
    content_value  = file(abspath("../.openapi/apis/order-api.yaml"))
  }
}