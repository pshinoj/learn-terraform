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

resource "local_file" "my_file_ex1" {
  filename        = "${local.prefix}-${var.file_name}"
  content         = "Random String - ${random_string.random_ex1.result}"
  file_permission = "0765"
}

variable "lengths" {
  description = "Create random with varied lengths"
  type        = list(number)
  default     = [5, 8, 16]
}

resource "random_string" "random_ex1" {
  length           = 16
  special          = true
  override_special = "&@£$"                                                                                                                               1,11          Top
}

resource "random_string" "random" {
  count            = length(var.lengths)

  length           = var.lengths[count.index]
  special          = true
  override_special = "&@£$"
}

resource "local_file" "my_file" {
  count = length(var.lengths)

  filename        = "${local.prefix}${var.lengths[count.index]}-${var.file_name}"
  content         = "Random String - ${random_string.random[count.index].result}"
  file_permission = "0766"
}
