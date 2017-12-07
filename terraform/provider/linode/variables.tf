variable "count" {
  type = "string"
}

variable "linode_api_key" {
  type = "string"
}

variable "root_password" {
  type = "string"
}

variable "public_key" {
  type = "string"
}

variable "domain" {
  type    = "string"
  default = "tapyness.net"
}

variable "hostname_format" {
  type    = "string"
  default = "node-%d"
}
