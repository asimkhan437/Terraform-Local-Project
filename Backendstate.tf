terraform {
  backend "azurerm" {
    resource_group_name  = "RG-Statefile"
    storage_account_name = "sastatefile"
    container_name       = "statefile"
    key                  = "dev.terraform.tfstate"
    # use_azuread_auth     = true
    # use_oidc             = true
    subscription_id = "882939ed-a914-4c3c-8161-a98856cc86f2"
    tenant_id       = "faaba21d-945d-4e9e-9e9b-6366b1018a31"
  }
}