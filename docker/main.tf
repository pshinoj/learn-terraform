terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.0"
    }
  }
}

provider "docker" {
  # Configuration options
}

resource "docker_image" "ms1_image" {
  name         = "tfms1demo"
  force_remove = true

  build {
    context    = "."
    dockerfile = "ms1.dockerfile"
    tag        = ["tfms1demo:v1.0.0"]
  }
}

resource "docker_container" "tfms1demo" {
  name  = "tfms1cdemo"
  image = docker_image.ms1_image.image_id
  ports {
    internal = 8080
    external = 8090
  }
}

output "container_id" {
  value = docker_container.tfms1demo.id
}
