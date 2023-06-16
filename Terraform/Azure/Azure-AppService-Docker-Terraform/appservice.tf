#App Service parameter

# Resource Group Creation
resource "azurerm_resource_group" "webapp-01" {
  name     = "webapp-01"
  location = var.location
}

# Create Service Plan
resource "azurerm_service_plan" "app-service-plan-01" {
  name                = "app-service-plan-01"
  resource_group_name = azurerm_resource_group.webapp-01.name
  location            = azurerm_resource_group.webapp-01.location
  os_type             = var.app-service-plan-01-os
  sku_name            = var.app-service-plan-01-sku

}

# Create Web App
resource "azurerm_linux_web_app" "linux-webapp-01" {
  name                = "linux-webapp-01-71234"
  resource_group_name = azurerm_resource_group.webapp-01.name
  location            = azurerm_service_plan.app-service-plan-01.location
  service_plan_id     = azurerm_service_plan.app-service-plan-01.id
  https_only              = "true"
  client_affinity_enabled = "false"


  site_config {
    always_on             = "false"
    application_stack {
      docker_image = "nginx"
      #node_version = "18-lts"
      docker_image_tag = "latest"
    }
  }
}
# Deploy Docker-compose to site
  resource "azapi_update_resource" "update_linux_webapp-01" {
  resource_id = azurerm_linux_web_app.linux-webapp-01.id
  type        = "Microsoft.Web/sites@2022-03-01"
  body = jsonencode({
    properties = {
      "siteConfig" = {
        "linuxFxVersion" = "COMPOSE|${base64encode(file("docker-compose.yml"))}"
      }
    }
  })
  depends_on = [
    azurerm_linux_web_app.linux-webapp-01,azurerm_service_plan.app-service-plan-01
  ]
}