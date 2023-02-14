# Instructions
## 1. Using docker provider
- Create `main.tf` and add docker provider
```bash
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
```

## 2. Create docker image
- Copy target binary to docker VM
    - `mp transfer ./target/microservice1-1.0.0.jar dockerVM:.`
- Create Dockerfile `ms1.dockerfile`
- Add resource details in `main.tf` as follows:

```bash
resource "docker_image" "ms1_image" {
  name = "tfms1demo"
  keep_locally = true

  build {
    context = "."
    dockerfile = "ms1.dockerfile"
  }
}
```

## 3. Add tag
```bash
resource "docker_image" "ms1_image" {
  name = "tfms1demo"
  keep_locally = true

  build {
    context = "."
    dockerfile = "ms1.dockerfile"
    tag = ["tfms1demo:v1.0.0"]
  }
}
```

## 4. Create container
```bash
resource "docker_container" "tfms1demo" {
  name = "tfms1cdemo"
  image = docker_image.ms1_image.image_id
}
```

## 5. Check if the container is running
```bash
$ curl http://localhost:8090/version
```

## 6. Create outputs
```bash
output "container_id" {
  description = "ID of docker container"
  value  = docker_container.tfms1demo.id
}

output "image_id" {
  description = "ID of docker image"
  value = docker_image.ms1_image.id
}
```
## 7. Display outputs
```bash
$ tf output
```

## 8. Destroy 
```bash
$ tf destroy
```

