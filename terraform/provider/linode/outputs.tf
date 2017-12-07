output "hostnames" {
  value = ["${linode_linode.node.*.name}"]
}

output "private_ips" {
  value = ["${linode_linode.node.*.private_ip_address}"]
}

output "public_ips" {
  value = ["${linode_linode.node.*.ip_address}"]
}

output "public_network_interface" {
  value = "eth0"
}

output "private_network_interface" {
  value = "eth0:1"
}
