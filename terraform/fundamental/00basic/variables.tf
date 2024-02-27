/*

// string variable
variable "compute_zone" {
 type = string
 default = "asia-southeast2-a"
}

// list variable
variable "compute_zone" {
 type = list(any)
 default = [
   "asia-southeast2-a",
   "asia-southeast2-b",
   "asia-southeast2-c",
 ]
}

*/

// map variable
variable "compute_zone" {
  type = map(any)
  default = {
    "a" = "asia-southeast2-a",
    "b" = "asia-southeast2-b",
    "c" = "asia-southeast2-c"
  }
}

//boolean variable
variable "allow_stop_vm" {
  type    = bool
  default = false
}

/*
kita dapat melakukan override value variable pada saat melakukan terraform plan & apply

terraform plan -var key=value
*/
