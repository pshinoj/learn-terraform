variable "oauth2_client_id" {
  type = string
  sensitive = true
}

variable "oauth2_password" {
  type = string
  sensitive = true
}

variable "org_admin_username" {
  type = string
}

variable "org_admin_password" {
  type = string
  sensitive = true
}

variable "root_org_id" {
  type = string
  default = ""
}
