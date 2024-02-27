output "public_ip_gateway" {
  value       = google_compute_instance.gateway.network_interface[0].access_config[0].nat_ip
  description = "public IP from gateway vm"
}

/*
terraform output
terraform output public_ip_gateway
*/