# Instructions
## 1. Create a local file with Hello World! text
```terraform
resource "local_file" "my_file" {
  filename        = "my_file.txt"
  content         = "Hello World!"
  file_permission = "0765"
}
```
## 2. Make changes in resource and see how plan works!
```terraform
resource "local_file" "my_file" {
  filename        = "my_file.txt"
  content         = "Hello World! Terraform!"
  file_permission = "0765"
}
```
```terraform
resource "local_file" "my_file" {
  filename        = "my_file.txt"
  content         = "Hello World! Terraform!"
  file_permission = "0766"
}
```
## 3. Using provider

```terraform
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

resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "&@£$"
}

resource "local_file" "my_file" {
  filename        = "my_file.txt"
  content         = "Random String - ${random_string.random.result}"
  file_permission = "0766"
}
```
- Run `tf plan` and see what error you are getting (Error: Inconsistent dependency lock file)
- Run `tf init` and then plan to avoid error

## 4. Define variables
```terraform
variable "file_name" {
  description = "Name of file"
  type        = string
}
resource "local_file" "my_file" {
  filename        = var.file_name
  content         = "Random String - ${random_string.random.result}"
  file_permission = "0766"
}
```
- Run `tf plan` and show how to pass input variable
- How to set default value to a variable?
  - `default = "my_new_file.txt"`

## 5. How to avoid passing input variables while plan and apply?
Option1: Commandline option
`tf plan -var="file_name=myfile.txt"`

Option2: Pass `.tfvars` definition files
- Create a file `terraform.tfvars`
- Add the variable data
```bash
file_name = "my_new_file.txt"
```
Option3: As environment variables

`export TF_VAR_file_name=myfile.txt`

## 5. Use local
```terraform
locals {
    prefix = "dev"
}
resource "local_file" "my_file" {
  filename        = "${local.prefix}-${var.file_name}"
  content         = "Random String - ${random_string.random.result}"
  file_permission = "0766"
}
```

## 6. How do you create same resource multiple times?
```terraform
resource "random_string" "random" {
  count            = 3

  length           = 16
  special          = true
  override_special = "&@£$"
}
```
- After setting this, do a `tf plan` to see what happens
  - Fails with `Error: Missing resource instance key`
- Change below line in code:
`content         = "Random String - ${random_string.random[0].result}"`

## 7. Exercise:
- Create 3 files with each file having one random string as content
- Name the file as dev-my_file-`n`.txt, where `n` is the index of count
- Create each random string with different lengths [5, 8, 16]

*Hint: Define a variable for lengths and use it in other resources*
```terraform
variable "lengths" {
  description = "Create random with varied lengths"
  type        = list(number)
  default     = [5, 8, 16]
}
```

## 8. Destroy resources
```bash
$ terraform destroy
```

## References
[Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)