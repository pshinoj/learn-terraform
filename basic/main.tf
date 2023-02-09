terraform {
  required_providers {
    random = { 
      source = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

provider "random" {
  # Configuration options
}

variable "file_name" {
  description = "Name of file"
  type        = string
}

locals {
  prefix = "dev"
}

resource "local_file" "my_file" {
  filename        = "${local.prefix}-${var.file_name}"
  content         = "Random String - ${random_string.random[0].result}"
  file_permission = "0765"
}

resource "random_string" "random" {
  count = 3

  length           = 16
  special          = true
  override_special = "&@£$"                                                                                                                               1,11          Top
}