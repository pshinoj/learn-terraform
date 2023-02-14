terraform {
  required_providers {
    hsdp = {
      source = "philips-software/hsdp"
      version = "0.41.4"
    }
  }
}

resource "hsdp_iam_org" "tutorial_org" {
  name = "MyTutorialOrg"
  description = "Tutorial organization provisioned using Terraform"
  parent_org_id = var.managing_org_id
}

resource "hsdp_iam_proposition" "tutorial_prop" {
  name                = "MYTUTORIALPROP"
  description         = "Test Proposition"
  organization_id     = hsdp_iam_org.tutorial_org.id
}

resource "hsdp_iam_application" "tutorial_app" {
  name                = "MYTUTORIALAPP"
  description         = "Test application"
  proposition_id      = hsdp_iam_proposition.tutorial_prop.id
}

resource "hsdp_iam_service" "tutorial_service" {
  name                = "MYTUTORIALSERVICE"
  description         = "Test service"
  application_id      = hsdp_iam_application.tutorial_app.id

  validity            = 12   # Months

  token_validity      = 3600 # Seconds

  scopes              = ["openid"]
  default_scopes      = ["openid"]
}

resource "hsdp_iam_role" "tutorial_fhir_role" {
  name        = "MYCLINICIAN"
  description = "Role for clinic users with patient CDR access"

  permissions = [
    "PATIENT.READ",
    "PATIENT.WRITE",
  ]

  managing_organization = hsdp_iam_org.tutorial_org.id
}

resource "hsdp_iam_role" "tutorial_admin_role" {
  name        = "MYADMIN"
  description = "Role for admin users with IAM access"

  permissions = [
    "HSDP_IAM_ORGANIZATION.MGMT"
  ]

  managing_organization = hsdp_iam_org.tutorial_org.id  
}

resource "hsdp_iam_group" "tutorial_practitioner_group" {
  name                  = "Practitioners"
  description           = "Group for clinical users"
  roles                 = [hsdp_iam_role.tutorial_fhir_role.id]
  users                 = []
  services              = []
  devices               = []

  managing_organization = hsdp_iam_org.tutorial_org.id
}

resource "hsdp_iam_group" "tutorial_admin_group" {
  name                  = "Administrators"
  description           = "Group for admin users"
  roles                 = [hsdp_iam_role.tutorial_admin_role.id]
  users                 = [hsdp_iam_user.tutorial_user.id]
  services              = [hsdp_iam_service.tutorial_service.id]
  devices               = []

  managing_organization = hsdp_iam_org.tutorial_org.id
}


resource "hsdp_iam_user" "tutorial_user" {
  login           = "${var.username}@hsp.edu"
  email           = "${var.username}@hsp.edu"
  first_name      = "${var.username}"
  last_name       = "Developer"
  password        = random_password.user_password.result
  
  organization_id = hsdp_iam_org.tutorial_org.id
}

resource "random_password" "user_password" {
  length           = 16
  special          = true
  min_upper        = 1
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  override_special = "-!@#.:_?{$"
}