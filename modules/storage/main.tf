resource "azurerm_storage_account" "storeacc" {
  provider = azurerm
  name = var.storage_acc_name
  resource_group_name = var.resource_group_name
  location = var.location
  account_kind = var.account_kind
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  enable_https_traffic_only = true
  min_tls_version = var.min_tls_version
  allow_blob_public_access = var.enable_advanced_threat_protecton == true ? true : false

  identity {
      type = var.assign_identity ? "SystemAssigned" : null
  }

  blob_properties {
      delete_retention_policy {
        days = var.soft_delete_retention
      }
  }
  
  dynamic "network_rules" {
      for_each = var.network_rules != null ? ["true"] : []
      content {
          default_action = "Deny"
          bypass = var.network_rules.bypass
          ip_rules = var.network_rules.ip_rules
          virtual_network_subnet_ids = var.network_rules.subnet_ids
      }
  }

}

resource "azurerm_storage_container" "container" {
  provider = azurerm
  count = length(var.container_list)
  name = var.containers_list[count.index].name
  storage_account_name = azurerm_storage_account.storeacc.name
  container_access_type = var.containers_list[count.index].access_type 
}

resource "azurerm_storage_share" "fileshare" {
  provider = azurerm
  count = length(var.file_shares)
  name = var.file_share[count.index].name
  storage_account_name = azurerm_storage_account.storeacc.name
  quota = var.file_share[count.index].quota 
}

resource "azurerm_storage_table" "tables" {
  provider = azurerm
  count = length(var.tables)
  name = var.tables[count.index]
  storage_account_name = azurerm_storage_account.storeacc.name

}

resource "azurerm_storage_queuea" "queues" {
  provider = azurerm
  count = length(var.queues)
  name = var.queues[count.index]
  storage_account_name = azurerm_storage_account.storeacc.name

}