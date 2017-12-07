provider "linode" {
  key = "${var.linode_api_key}"
}

resource "linode_linode" "node" {
  count                           = "${var.count}"
  image                           = "Ubuntu 16.04 LTS"
  kernel                          = "GRUB 2"
  name                            = "${format(var.hostname_format, count.index + 1)}"
  group                           = "kubernetes"
  region                          = "Dallas, TX, USA"
  size                            = 2048
  helper_distro                   = true
  manage_private_ip_automatically = true
  private_networking              = true
  root_password                   = "${var.root_password}"
  ssh_key                         = "${var.public_key}"
  swap_size                       = 0

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname ${self.name}",
      "echo 'Acquire::ForceIPv4 \"true\";' >> /etc/apt/apt.conf.d/99force-ipv4",
      "apt-get update",
      "apt-get install -yq nfs-common",
    ]

    connection {
      type        = "ssh"
      host        = "${self.ip_address}"
      user        = "root"
      private_key = "${file("~/.ssh/id_rsa")}"
    }
  }
}
