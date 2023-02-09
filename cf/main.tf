terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.50.0"
    }
  }
}

provider "cloudfoundry" {
  # Configuration options
  api_url             = var.cf_api_url
  user                = var.cf_user_username
  password            = var.cf_user_password
  uaa_client_id       = var.cf_client_id
  uaa_client_secret   = var.cf_client_secret
  skip_ssl_validation = true
  app_logs_max        = 30
}

data "cloudfoundry_org" "my_org" {
  name = var.cf_org
}

data "cloudfoundry_space" "my_space" {
  name = var.cf_space
  org  = data.cloudfoundry_org.my_org.id
}

data "cloudfoundry_service" "vault" {
  name = var.vault_service
}

