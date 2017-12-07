resource "null_resource" "wireguard" {
  count = "${var.count}"

  triggers {
    count = "${var.count}"
  }

  connection {
    host        = "${element(var.connections, count.index)}"
    user        = "root"
    agent       = true
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get install -yq software-properties-common python-software-properties build-essential",
      "add-apt-repository -y ppa:wireguard/wireguard",
      "apt-get update",
    ]
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/install-kernel-headers.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "DEBIAN_FRONTEND=noninteractive apt-get install -yq wireguard-dkms wireguard-tools",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/templates/wireguard@.service"
    destination = "/etc/systemd/system/wireguard@.service"
  }

  provisioner "file" {
    content     = "${element(data.template_file.interface-conf.*.rendered, count.index)}"
    destination = "/etc/wireguard/${var.vpn_interface}.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 700 /etc/wireguard/${var.vpn_interface}.conf",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "${join("\n", formatlist("echo '%s %s' >> /etc/hosts", data.template_file.vpn_ips.*.rendered, var.hostnames))}",
      "systemctl is-enabled wireguard@${var.vpn_interface}.service || systemctl enable wireguard@${var.vpn_interface}.service",
      "systemctl restart wireguard@${var.vpn_interface}.service",
    ]
  }
}

data "template_file" "interface-conf" {
  count    = "${var.count}"
  template = "${file("${path.module}/templates/interface.conf")}"

  vars {
    address     = "${element(data.template_file.vpn_ips.*.rendered, count.index)}"
    port        = "${var.vpn_port}"
    private_key = "${element(data.external.keys.*.result.private_key, count.index)}"
    peers       = "${replace(join("\n", data.template_file.peer-conf.*.rendered), element(data.template_file.peer-conf.*.rendered, count.index), "")}"
  }
}

data "template_file" "peer-conf" {
  count    = "${var.count}"
  template = "${file("${path.module}/templates/peer.conf")}"

  vars {
    endpoint    = "${element(var.private_ips, count.index)}"
    port        = "${var.vpn_port}"
    public_key  = "${element(data.external.keys.*.result.public_key, count.index)}"
    allowed_ips = "${element(data.template_file.vpn_ips.*.rendered, count.index)}/32"
  }
}

data "external" "keys" {
  count = "${var.count}"

  program = ["sh", "${path.module}/scripts/gen_keys.sh"]
}

data "template_file" "vpn_ips" {
  count    = "${var.count}"
  template = "$${ip}"

  vars {
    ip = "${cidrhost(var.vpn_iprange, count.index + 2)}"
  }
}
