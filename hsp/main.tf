terraform {
  required_providers {
    hsdp = {
      source = "philips-software/hsdp"
      version = "0.41.4"
    }
  }
}

provider "hsdp" {
  # Configuration options
  region             = "us-east"
  environment        = "client-test"
  oauth2_client_id   = var.oauth2_client_id
  oauth2_password    = var.oauth2_password
  org_admin_username = var.org_admin_username
  org_admin_password = var.org_admin_password
}

data "hsdp_iam_org" "my_org" {
  organization_id = var.root_org_id
}

output "org_name" {
  value = data.hsdp_iam_org.my_org.name
}

module "hsp_idm" {
    source = "./modules/iam"

    managing_org_id = data.hsdp_iam_org.my_org.id
    username = var.org_admin_username
}