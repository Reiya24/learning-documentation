variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

// ==== EC2 ====
variable "list_vm" {
  type    = list(string)
  default = ["nginx1", "nginx2"]
}


// ==== VPC ====
variable "vpc_id" {
  type    = string
  default = "vpc-013d5fbaee737daad" // ID VPC
}