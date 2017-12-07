resource "null_resource" "kubelet_kubeadm" {
  count = "${var.count}"

  triggers = {
    count = "${var.count}"
  }

  connection {
    host        = "${element(var.connections, count.index)}"
    user        = "root"
    agent       = true
    private_key = "${var.private_key}"
  }

  provisioner "remote-exec" {
    inline = <<EOF
apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOS >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOS
apt-get update
apt-get install -yq kubelet=1.8.0-00 kubeadm=1.8.1-01 kubectl=1.8.0-00 kubernetes-cni
EOF
  }
}
