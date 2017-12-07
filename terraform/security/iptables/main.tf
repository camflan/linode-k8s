resource "null_resource" "firewall" {
  count = "${var.count}"

  triggers = {
    template = "${data.template_file.iptables.rendered}"
  }

  connection {
    host        = "${element(var.connections, count.index)}"
    user        = "root"
    agent       = true
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = <<EOF
${data.template_file.iptables.rendered}
EOF
  }
}

data "template_file" "iptables" {
  template = "${file("${path.module}/scripts/iptables.sh")}"

  vars {
    private_interface = "${var.private_interface}"

    private_ips         = "${join(" ", var.private_ips)}"
    vpn_interface       = "${var.vpn_interface}"
    vpn_port            = "${var.vpn_port}"
    kubernetes_api_port = "${var.kubernetes_api_port}"
  }
}
