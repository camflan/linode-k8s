resource "null_resource" "node" {
  count = "${var.worker_count}"

  triggers = {
    total_count = "${var.worker_count + var.master_count}"
  }

  connection {
    host        = "${element(var.connections, var.master_count + count.index)}"
    user        = "root"
    agent       = true
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = <<EOF
kubeadm reset
kubeadm join --token ${var.token} ${var.master_ip}:${var.kubernetes_api_port}
EOF
  }
}
