##########################################################################
#   Terraform starter template
##########################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.56.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "rpmterraformbackend"
    container_name       = "terraform"
    //Fill out with your unique project name
    //key                  = "PROJECT_NAME.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

provider "azuread" {  
}

locals {
  shared_resource_group_name = "rg-rpm-genesis-common-${terraform.workspace}"
}

//Import current tenant settings
data "azurerm_client_config" "current" {
}

//Import app insights from common rg
data "azurerm_application_insights" "appinsights" {
  provider = azurerm
  name                = "appi-rpm-genesis-${terraform.workspace}"
  resource_group_name = local.shared_resource_group_name
}

//Import Service Bus from common rg
data "azurerm_servicebus_namespace" "servicebus" {
  provider = azurerm
  name                = "sb-rpm-genesis-${terraform.workspace}"
  resource_group_name = local.shared_resource_group_name
}

