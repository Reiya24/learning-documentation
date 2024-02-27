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

// pull image
resource "docker_image" "nginx_alpine" {
  name         = "nginx:alpine"
  keep_locally = true
}

variable "list_container" {
  type    = list(string)
  default = ["banana", "jeruk", "durian", "durian"]
}

resource "docker_container" "list_nginx" {
  // input value untuk for_each harus berupa var yang tipenya map | set, maka tipe data akan di convert ke set
  for_each = toset(var.list_container)
  image    = docker_image.nginx_alpine.image_id

  name = "nginx-list-${each.value}" // mendapatkan value dari looping
  ports {
    // cari index keberapa dari sebuah key
    external = 8080 + index(var.list_container, each.key)
    internal = 80
  }
}


variable "map_container" {
  type = map(object({
    name          = string
    external_port = number
  }))

  default = {
    "con_1" = { name = "mendoan", external_port = 8888 },
    "con_2" = { name = "bakwan", external_port = 9999 },
  }
}

resource "docker_container" "map_nginx" {
  for_each = var.map_container
  image    = docker_image.nginx_alpine.image_id

  name = "nginx-map-${each.key}-${each.value.name}"
  ports {
    external = each.value.external_port
    internal = 80
  }

  depends_on = [docker_container.list_nginx]
}


/*
for_each dapat digunakan untuk membuat resource yang mirip, dengan beberapa konfigurasi yang beda
ex: membuat beberapa vm, untuk satu fungsi yang sama tapi beda di jumlah CPU / memory
input value untu for_each harus berupa var yang tipenya map | set
var set mirip seperti list
*/