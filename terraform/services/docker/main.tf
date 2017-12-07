resource "null_resource" "docker" {
  count = "${var.count}"

  triggers = {
    template = "${data.template_file.docker.rendered}"
  }

  connection {
    host        = "${element(var.connections, count.index)}"
    user        = "root"
    agent       = true
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = <<EOF
${data.template_file.docker.rendered}
EOF
  }
}

data "template_file" "docker" {
  template = "${file("${path.module}/scripts/install_docker.sh")}"
}
