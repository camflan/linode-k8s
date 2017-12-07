variable "count" {}

variable "connections" {
  type = "list"
}

variable "private_key" {
  type = "string"
}

variable "private_ips" {
  type = "list"
}

variable "vpn_interface" {
  default = "wg0"
}

variable "vpn_port" {
  default = "51820"
}

variable "hostnames" {
  type = "list"
}

variable "vpn_iprange" {
  default = "10.0.1.0/24"
}
