provider "azurerm" {
    features        {}
    subscription_id = "1eee6559-30fe-45aa-8cf6-93089f53115a"
}

resource "azurerm_postgresql_flexible_server" "example" {
    name                         = "rahulsaha-pg2"
    resource_group_name          = "rahulsaha-rg"
    location                     = "Central India"
    version                      = "12"
    public_network_access_enabled = false
    administrator_login          = "psqladmin"
    administrator_password       = "H@Sh1CoR3!"
    zone                         = "1"
    storage_mb                   = 32768
    storage_tier                 = "P4"
    sku_name                     = "B_Standard_B1ms"
}