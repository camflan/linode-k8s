variable "count" {}

variable "private_key" {
  type = "string"
}

variable "connections" {
  type = "list"
}

variable "private_interface" {
  type = "string"
}

variable "vpn_interface" {
  type = "string"
}

variable "vpn_port" {
  type = "string"
}

variable "private_ips" {
  type = "list"
}

variable "kubernetes_api_port" {
  type = "string"
}
