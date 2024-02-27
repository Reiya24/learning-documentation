terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_image" "nginx_alpine" {
  name         = "nginx:alpine"
  keep_locally = true
}


variable "container_name" {
  type    = string
  default = "nginx-container"
}

variable "allow_expose_port" {
  type    = bool
  default = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id
  name  = var.container_name

  ports {
    external = 8080
    internal = 80
  }

  network_mode = data.docker_network.default_bridge.name
  lifecycle {
    /*
      precondition & postcondition dapat di definisikan lebih dari 1x

      preconditions digunakan untuk pengecekan sebelum sesuatu dibuat,
      postconditions digunakan untuk pengecekan setelah sesuatu dibuat, ex: 
    */

    precondition {
      condition     = !contains(split(":", docker_image.nginx_alpine.name), "latest")
      error_message = "tidak bisa menggunakan image dengan tag latest"
    }

    postcondition {
      condition     = length(self.ports) > 0
      error_message = "minimum 1 port yang terekspose"
    }

    postcondition {
      condition     = !(var.allow_expose_port == false)
      error_message = "tidak diizinkan untuk mengekspose port"
    }

  }
}

data "docker_network" "default_bridge" {
  name = "bridge"
  lifecycle {
    postcondition {
      condition     = self.driver == "bridge"
      error_message = "driver docker netwrok harus brdige"
    }
  }
}

output "subnet_network" {
  value = one(data.docker_network.default_bridge.ipam_config).subnet
}

/*
command:
terraform plan # err: tidak diizinkan untuk mengekspose port
terraform plan -var allow_expose_port=true

jika block port diberi komentar
terraform plan -var allow_expose_port=true #err: minimum 1 port yang terekspose


*/