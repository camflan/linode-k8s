output "vpn_ips" {
  depends_on = ["null_resource.wireguard"]
  value      = ["${data.template_file.vpn_ips.*.rendered}"]
}

output "vpn_unit" {
  depends_on = ["null_resource.wireguard"]
  value      = "wireguard@${var.vpn_interface}.service"
}

output "vpn_interface" {
  value = "${var.vpn_interface}"
}

output "vpn_port" {
  value = "${var.vpn_port}"
}
