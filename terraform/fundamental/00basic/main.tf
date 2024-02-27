#terraform provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.73.0"
    }
  }
}

#provider block
provider "google" {
  project = "reiya24"
  region  = "asia-southeast2"
}

#data source
data "google_compute_image" "debian" {
  family  = "debian-11"
  project = "debian-cloud"
}

#resource block to create service account
resource "google_service_account" "terraform_service_account" {
  account_id   = "new-service-account"
  display_name = "new-service-account"
}


#resource block to create vm
resource "google_compute_instance" "gateway" {
  name                      = "gateway"
  machine_type              = "e2-micro"
  zone                      = var.compute_zone["a"]
  allow_stopping_for_update = var.allow_stop_vm

  #resource lifecycle
  lifecycle {
    prevent_destroy = true
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link //self link
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = google_service_account.terraform_service_account.email #accessing resource attributes
    scopes = ["cloud-platform"]
  }
  
}

/*

IN:
terraform state list

OUT:
data.google_compute_image.debian
google_compute_instance.gateway
google_service_account.terraform_service_account

*/