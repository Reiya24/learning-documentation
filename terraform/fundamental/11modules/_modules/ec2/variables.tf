variable "aws_access_key" {
  sensitive   = true
  type    = string
}

variable "aws_secret_key" {
  sensitive   = true
  type    = string
}

// ==== EC2 ====
variable "list_vm" {
  type    = list(string)
  default = ["vm1", "vm2"]
}

variable "security_group_names" {

  type = list(string)
}