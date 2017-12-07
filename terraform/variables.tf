variable "master_count" {
  type    = "string"
  default = "1"
}

variable "worker_count" {
  type    = "string"
  default = "3"
}

variable "public_key_path" {
  type = "string"
}

variable "private_key_path" {
  type = "string"
}

variable "linode_api_key" {
  type = "string"
}

variable "root_password" {
  type = "string"
}

variable "domain" {
  type    = "string"
  default = "example.net"
}

variable "hostname_format" {
  type = "string"
}

variable "token" {
  type = "string"
}

variable "kubernetes_api_port" {
  type    = "string"
  default = "6443"
}
