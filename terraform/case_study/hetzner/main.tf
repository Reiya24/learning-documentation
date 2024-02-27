terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.42.1"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "ssh_keys" {
  for_each   = var.ssh_key
  name       = each.key
  public_key = each.value
}

resource "hcloud_firewall" "basic_firewall" {
  name = "basic_firewall"

  dynamic "rule" {
    for_each = var.firewall_port
    content {
      direction = "in"
      protocol  = "tcp"
      port      = rule.value
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    }
  }
}

resource "hcloud_network" "main_network" {
  name     = "main_network"
  ip_range = "10.0.0.0/16"

}

resource "hcloud_network_subnet" "subnet1" {
  network_id   = hcloud_network.main_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_server" "server" {
  for_each = toset(var.server_list)

  name        = each.value
  image       = "ubuntu-22.04"
  location    = "nbg1"
  server_type = var.server_type
  ssh_keys    = keys(hcloud_ssh_key.ssh_keys)
  firewall_ids = [hcloud_firewall.basic_firewall.id]

  labels = {
    type = "terraform"
  }


}

resource "hcloud_server_network" "server" {
  for_each   = toset(var.server_list)
  server_id  = hcloud_server.server[each.key].id
  subnet_id = hcloud_network_subnet.subnet1.id

}