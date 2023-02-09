terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.50.0"
    }
  }
}

data "cloudfoundry_domain" "apps" {
  name = "cloud.pcftest.com"
}

output "myapp_details" {
  value = {
    id   = cloudfoundry_app.myapp.id
    name = cloudfoundry_app.myapp.name
    route = cloudfoundry_app.myapp.routes
    instances = cloudfoundry_app.myapp.instances
  }
}

