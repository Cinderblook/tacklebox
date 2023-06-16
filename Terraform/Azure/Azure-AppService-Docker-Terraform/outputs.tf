# Outputs
output "app_name" {
  value = azurerm_linux_web_app.linux-webapp-01.name
}

output "app_url" {
  value = "https://${azurerm_linux_web_app.linux-webapp-01.default_hostname}"
}