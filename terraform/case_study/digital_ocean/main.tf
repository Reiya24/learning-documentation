resource "digitalocean_vpc" "vpc" {
  name = "vpc"
  region = "sgp1"
  ip_range = "10.10.1.0/24"
}