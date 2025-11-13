terraform {
  required_version = ">= 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}




# ---------------- Variables------------

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  
}


# ---------------- Resources-------------

# Resource Group
resource "azurerm_resource_group" "storage_rg" {
  name     = "${var.prefix_app_name}-rg"
  location = var.location
  tags     = local.common_tags
}

# App Service Plan (Linux)
resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix_app_name}-asp"
  location            = var.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  sku_name            = "S1"
  os_type             = "Linux"
  tags                = local.common_tags
}

# Linux Web App med Docker från ACR och Azure Files mount
resource "azurerm_linux_web_app" "app" {
  name                = "${var.prefix_app_name}-app${random_string.suffix.result}"
  location            = var.location
  resource_group_name = azurerm_resource_group.storage_rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on  = true
    ftps_state = "Disabled"

    application_stack {
      docker_image_name        = "${azurerm_container_registry.acr.login_server}/dashboard:latest"
    }
  }

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    WEBSITES_PORT                       = "5000"
  }