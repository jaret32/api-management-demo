terraform {
  backend "remote" {
    organization = "PFL"
    workspaces {
      name = "jaret-demo"
    }
  }
  
  required_providers {
    azurem = {
      source  = "hashicorp/azurem"
      version = "=2.46.0"
    }
  }
}

provider "azurem" {
  features {}
}

resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}

resource "azurem_resource_group" "main" {
  name     = "user-boyer"
  location = "Central US"
}

resource "azurem_app_service_plan" "main" {
  name                = "jaretApiManagmentDemo-asp"
  location            = azurem_resource_group.main.location
  resource_group_name = azurem_resource_group.main.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurem_app_service" "main" {
  name                = "jaretApiManagmentDemo-appservice"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id

  site_config {
    dotnet_framework_version = "v5.0"
  }
}

resource "azurem_app_service_slot" "main" {
  name                = random_id.server.hex
  app_service_name    = azurem_app_service.main.name
  location            = azurem_resource_group.main.location
  resource_group_name = azurem_resource_group.main.name
  app_service_plan_id = azurem_app_service_plan.main.id

  site_config {
    dotnet_framework_version = "v5.0"
  }
}

resource "azurem_app_service_active_slot" "main" {
  resource_group_name   = azurem_resource_group.main.name
  app_service_name      = azurem_app_service.main.name
  app_service_slot_name = azurem_app_service_slot.main.name
}