variable "hcloud_token" {
  sensitive = true
  type = string
}

variable "server_type" {
  type = list(string)
  default = "cx11"
}

variable "server_list" {
  type = list(string)
}

variable "firewall_port" {
  type = list(string)
}

variable "ssh_key" {
  type = map(string)
}