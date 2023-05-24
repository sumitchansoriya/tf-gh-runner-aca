resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

resource "azurerm_resource_group" "this" {
  name     = format("%s-rg", local.prefix)
  location = var.location
}

# TODO: May want to change this to premium with geo replication
resource "azurerm_container_registry" "this" {
  name                = format("%s%scr", replace(local.prefix, "-", ""), random_string.this.id)
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_storage_account" "this" {
  name                      = format("%sst", replace(local.prefix, "-", ""))
  resource_group_name       = azurerm_resource_group.this.name
  location                  = azurerm_resource_group.this.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
}

resource "azurerm_storage_queue" "this" {
  name                 = format("%s-ghr-scaler-sq", local.prefix)
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = format("%s-law", local.prefix)
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "this" {
  name                       = format("%s-cae", local.prefix)
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}


# Grant AAD App and Service Principal Contributor to ACA deployment RG + `Storage Queue Data Contributor` on Storage account
# az ad sp list --display-name $appName --query [].appId -o tsv | ForEach-Object {
#     az role assignment create --assignee "$_" `
#         --role "Contributor" `
#         --scope "$acaRGId"

#     az role assignment create --assignee "$_" `
#         --role "Storage Queue Data Contributor" `
#         --scope "$storageId"
# }


#Create Container App from docker image (self hosted GitHub runner) stored in ACR
# az containerapp create --resource-group "$acaResourceGroupName" `
#     --name "$acaName" `
#     --image "$acrImage" `
#     --environment "$acaEnvironment" `
#     --registry-server "$acrLoginServer" `
#     --registry-username "$acrUsername" `
#     --registry-password "$acrPassword" `
#     --secrets gh-token="$pat" storage-connection-string="$storageConnection" `
#     --env-vars GH_OWNER="$githubOrg" GH_REPOSITORY="$githubRepo" GH_TOKEN=secretref:gh-token `
#     --cpu "1.75" --memory "3.5Gi" `
#     --min-replicas 0 `
#     --max-replicas 3

resource "azurerm_container_app" "this" {
  name                         = format("%s-ca", local.prefix)
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = azurerm_resource_group.this.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}




