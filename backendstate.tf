terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    resource_group_name  = "RG-statefile"
    storage_account_name = "sastatefile"
    container_name       = "statefile"
    key                  = "terraform.tfstate"
    access_key           = "JLO6bFWi2MMX+OZ4EBArKMsuVagvRUJOjFX+LZnGOfFTf+SW/g/d5S7hCsTZUxjcFivmX5RsiEPb+AStC5NB2w=="
  }
}