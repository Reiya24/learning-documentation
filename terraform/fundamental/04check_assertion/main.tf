terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.4.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

//pull image
resource "docker_image" "nginx_alpine" {
  name         = "httpd:alpine"
  keep_locally = true
}

resource "docker_container" "nginx" {
  image = docker_image.nginx_alpine.image_id

  name = "nginx-con"
  ports {
    external = 8080
    internal = 80
  }
}

check "health_check" {
  data "http" "container" {
    method = "GET"
    url    = "http://localhost:${docker_container.nginx.ports[0].external}/"
  }

  assert {
    condition     = data.http.container.status_code == 200
    error_message = "err:: ${data.http.container.url}"
  }

  assert {
    condition     = length(regexall("nginx*", data.http.container.response_headers.Server)) > 0
    error_message = "webserver should nginx"
  }
}


/*
check block:
mirip seperti data sources, yaitu untuk mengambil informasi dari external resource



check assertion digunakan untuk melakukan pengecekan seletah resource dibuat,
ia melakukan validasi fungsionalitas sebuah resource, check assertion dituliskan didalam
check block

ex: memastikan apakah alamat IP tersebut mengembalikan value yang diharapkan
*/


